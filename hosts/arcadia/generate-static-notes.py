import os
import subprocess
import sys
import threading
import time
from hashlib import md5
from html import escape
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path

ADDR: str = "10.255.254.1"
PORT: int = 8323

CSS = """
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  max-width: 900px;
  margin: auto;
  padding: 2rem;
}
h1, h2, h3, h4, h5, h6 {
  margin-top: 1.2em;
  color: #111;
}
a {
  color: #0366d6;
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
}
ul {
  list-style-type: none;
  padding-left: 1em;
}
li {
  margin: 0.2em 0;
}
pre, code {
  font-family: SFMono-Regular, Consolas, "Liberation Mono", Menlo, monospace;
}
pre {
  overflow-x: auto !important;
  padding: 1em;
  border-radius: 4px;
  border: 1px solid #ddd;
}
"""


def calculate_md5() -> str:
    md5_sum = md5()
    for f in sorted(Path(".").glob("*/*.md")):
        try:
            with Path(f).open() as fd:
                md5_sum.update("".join(fd.readlines()).encode())
        except Exception as e:
            print(e)
    return md5_sum.hexdigest()


def convert_md_to_html(md_file: Path, html_file: Path):
    _ = subprocess.run(
        ["pandoc", md_file, "-s", "-c", "/style.css", "-o", html_file], check=True
    )


def build_index_html():
    tree: dict[Path, list[Path]] = {}

    for f in sorted(Path(".").glob("*/*.md")):
        rel_root = f.parent
        if rel_root in tree:
            tree[rel_root].append(f)
        else:
            tree[rel_root] = [f]

    sorted_dirs = sorted(tree.keys(), key=lambda p: str(p).lower())

    html_lines = ["<ul>"]
    for d in sorted_dirs:
        indent = "  " * len(d.parts)
        if d != Path("."):
            html_lines.append(f"{indent}<li><strong>{escape(str(d))}</strong></li>")
            html_lines.append(f"{indent}<ul>")
            inner_indent = indent + "  "
        else:
            inner_indent = indent

        for f in tree[d]:
            html_name = f.name.rstrip(".md") + ".html"
            link_path = (d / html_name).as_posix()
            html_lines.append(
                f"{inner_indent}<li><a href='{escape(link_path)}'>{escape(f.name)}</a></li>"
            )

        if d != Path("."):
            html_lines.append(f"{indent}</ul>")
    html_lines.append("</ul>")
    return "\n".join(html_lines)


def generate_site(dest_dir: Path):
    dest_dir.mkdir(parents=True, exist_ok=True)

    css_file = dest_dir / "style.css"
    _ = css_file.write_text(CSS)

    for f in sorted(Path(".").glob("*/*.md")):
        rel_root = f.parent
        out_dir = dest_dir / rel_root
        out_dir.mkdir(parents=True, exist_ok=True)
        html_name = f.name.rstrip(".md") + ".html"
        html_path = out_dir / html_name
        convert_md_to_html(f.absolute(), html_path)

    index_html = dest_dir / "index.html"
    index_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Notes Index</title>
<link rel="stylesheet" href="/style.css">
</head>
<body>
<h1>Notes Index</h1>
{build_index_html()}
</body>
</html>
"""
    _ = index_html.write_text(index_content)

    print(f"Index generated at {index_html}")


def serve(dest_dir: Path, addr: str = "127.0.0.1", port: int = 8323):
    # This class is used to specify the directory to serve without
    # using os.chdir
    class Handler(SimpleHTTPRequestHandler):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, directory=dest_dir, **kwargs)

    httpd = HTTPServer((addr, port), Handler)
    print(f"Serving at http://{addr}:{port}")
    httpd.serve_forever()


def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <notes_dir> <dest_dir>")
        sys.exit(1)

    notes_dir = Path(sys.argv[1]).resolve()
    dest_dir = Path(sys.argv[2]).resolve()

    if not notes_dir.is_dir():
        print("Error: notes_dir must be a directory")
        sys.exit(1)

    os.chdir(notes_dir)
    generate_site(dest_dir)
    last_md5_sum: str = calculate_md5()

    t = threading.Thread(target=serve, args=(dest_dir, ADDR, PORT), daemon=True)
    t.start()

    try:
        while True:
            time.sleep(10)
            md5_sum = calculate_md5()
            if md5_sum != last_md5_sum:
                last_md5_sum = md5_sum
                try:
                    generate_site(dest_dir)
                except Exception as e:
                    print(e)
    except KeyboardInterrupt:
        sys.exit(0)


if __name__ == "__main__":
    main()

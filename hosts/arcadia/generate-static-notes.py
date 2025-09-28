import datetime
import os
import subprocess
import sys
from hashlib import md5
from html import escape
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path

ADDR: str = "10.255.254.1"
PORT: int = 8323

CSS = """
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  max-width: 1024px;
  margin: auto;
  padding: 2rem;
}
a {
  color: #0366d6;
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
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
li {
  margin: 0.4em 0;
}
div.items {
  display: grid;
  grid-template-areas: "a a a";
  grid-auto-rows: auto;
  gap: 1em;
  justify-content: center;
}
div.item {
  border-radius: 6px;
  border: 2px solid #f0f0f0;
  padding: 0.3em;
}
a.itemtitle {
  font-weight: bold;
  font-size: 1.2em;
}
button {
  font-family: monospace;
  margin: 1.4em;
}
code.updated_at {
  font-size: 0.8em;
}
"""


def find_md_files() -> list[Path]:
    return sorted(Path(".").glob("**/*.md"))


def calculate_md5() -> str:
    md5_sum = md5()
    for f in find_md_files():
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

    for f in find_md_files():
        rel_root = f.parent
        if rel_root in tree:
            tree[rel_root].append(f)
        else:
            tree[rel_root] = [f]

    sorted_dirs = sorted(tree.keys(), key=lambda p: str(p).lower())

    html_lines = ['<div class="items">']
    for d in sorted_dirs:
        if d != Path("."):
            html_lines.append('<div class="item">')
            html_lines.append(
                f"<a class='itemtitle' href='{escape(d.as_posix())}'>{escape(str(d))}</a>"
            )
            html_lines.append("<ul>")

        for f in tree[d]:
            html_name = f.name.rstrip(".md") + ".html"
            link_path = (d / html_name).as_posix()
            link_name = f.name.rstrip(".md").replace("-", " ").replace("_", " ").title()
            html_lines.append(
                f"<li><a href='{escape(link_path)}'>{escape(link_name)}</a></li>"
            )

        if d != Path("."):
            html_lines.append("</ul></div>")
    html_lines.append("</div>")
    return "\n".join(html_lines)


def generate_site(dest_dir: Path):
    dest_dir.mkdir(parents=True, exist_ok=True)

    css_file = dest_dir / "style.css"
    _ = css_file.write_text(CSS)

    for f in find_md_files():
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
<form action="/regenerate" method="post">
    <button name="regenerate" value="regenerate">REGENERATE</button>
    <code class="updated_at">Updated at: {datetime.datetime.now(tz=datetime.UTC).isoformat(sep=" ", timespec="seconds")}</code>
</form>
{build_index_html()}
</body>
</html>
"""
    _ = index_html.write_text(index_content)

    print(f"Index generated at {index_html}")


def serve(dest_dir: Path, addr: str = "127.0.0.1", port: int = 8323):
    class Handler(SimpleHTTPRequestHandler):
        def __init__(self, *args, **kwargs):
            # This is used to specify the directory to serve without using os.chdir
            super().__init__(*args, directory=dest_dir, **kwargs)

        def do_POST(self):
            if self.path == "/regenerate":
                try:
                    generate_site(dest_dir)
                    self.send_response(301)
                    self.send_header("Location", "/")
                    self.end_headers()
                except Exception as e:
                    self.send_error(
                        500, f"Re-generation of html from md files failed: {e}"
                    )
            else:
                self.send_error(404, "Not Found")

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
    serve(dest_dir, ADDR, PORT)


if __name__ == "__main__":
    main()

import os
import subprocess
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path

ADDR: str = "10.255.254.1"
PORT: int = 8323


def generate_site(notes_dir: Path, dest_dir: Path):
    tmp_dir: Path = Path("/tmp/_notes_src")
    _ = subprocess.run(
        [
            "/bin/sh",
            "-c",
            f"rm -rf '{tmp_dir}' && cp -r '{notes_dir}' '{tmp_dir}' && cd '{tmp_dir}' && quarto render . 2>&1 | strip-ansi",
        ],
        check=True,
    )

    print(f"Site generated at {dest_dir}", flush=True)


def serve(notes_dir: Path, dest_dir: Path, addr: str = "127.0.0.1", port: int = 8323):
    class Handler(SimpleHTTPRequestHandler):
        def __init__(self, *args, **kwargs):
            # This is used to specify the directory to serve without using os.chdir
            super().__init__(*args, directory=dest_dir, **kwargs)

        def do_POST(self):
            if self.path == "/regenerate":
                try:
                    generate_site(notes_dir, dest_dir)
                    self.send_response(301)
                    self.send_header("Location", "/")
                    self.end_headers()
                except Exception as e:
                    self.send_error(500, f"Quarto render failed: {e}")
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

    dest_dir.mkdir(parents=True, exist_ok=True)
    os.chdir(dest_dir)
    generate_site(notes_dir, dest_dir)
    serve(notes_dir, dest_dir, ADDR, PORT)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
import os
import time
import json
from pathlib import Path
from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import urlparse

class P5Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        self.last_modified = {}
        super().__init__(*args, **kwargs)

    def do_GET(self):
        parsed_path = urlparse(self.path)
        if parsed_path.path == '/check-changes':
            # Check for file changes
            changed = self.check_for_changes()
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'true' if changed else b'false')
            return
        # Serve static files
        super().do_GET()

    def check_for_changes(self):
        watched_files = ['sketch.js', 'style.css', 'index.html']
        changed = False
        for file in watched_files:
            if os.path.exists(file):
                current_mtime = os.path.getmtime(file)
                if file not in self.last_modified or current_mtime > self.last_modified[file]:
                    if file in self.last_modified:
                        changed = True
                    self.last_modified[file] = current_mtime
        return changed

if __name__ == '__main__':
    import sys
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
    server = HTTPServer(('localhost', port), P5Handler)
    print(f"Server running at http://localhost:{port}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped")
        server.shutdown()
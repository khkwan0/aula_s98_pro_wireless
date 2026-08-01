#!/usr/bin/env python3
"""Local GitHub webhook receiver for aula-s98 www deploy.

Listens on 127.0.0.1 only. Host nginx proxies
https://nitroxstudios.com/hooks/github/aula-www → this process.
On a verified push to main, runs on-github-push.sh asynchronously and
returns 202 so GitHub does not wait for the Docker build.
"""
from __future__ import annotations

import hashlib
import hmac
import json
import logging
import os
import subprocess
import threading
from http.server import BaseHTTPRequestHandler, HTTPServer

HOST = os.environ.get("WEBHOOK_HOST", "127.0.0.1")
PORT = int(os.environ.get("WEBHOOK_PORT", "9001"))
SECRET = os.environ.get("WEBHOOK_SECRET", "")
DEPLOY_SCRIPT = os.environ.get(
    "DEPLOY_SCRIPT",
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "on-github-push.sh"),
)
BRANCH_REF = os.environ.get("WEBHOOK_BRANCH_REF", "refs/heads/main")

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
log = logging.getLogger("aula-www-webhook")


def verify_signature(body: bytes, header: str | None) -> bool:
    if not SECRET or not header or not header.startswith("sha256="):
        return False
    expected = hmac.new(SECRET.encode("utf-8"), body, hashlib.sha256).hexdigest()
    received = header.split("=", 1)[1]
    return hmac.compare_digest(expected, received)


def run_deploy() -> None:
    log.info("starting deploy: %s", DEPLOY_SCRIPT)
    try:
        result = subprocess.run(
            ["bash", DEPLOY_SCRIPT],
            check=False,
            capture_output=True,
            text=True,
        )
        if result.stdout:
            log.info("deploy stdout:\n%s", result.stdout.rstrip())
        if result.stderr:
            log.warning("deploy stderr:\n%s", result.stderr.rstrip())
        if result.returncode != 0:
            log.error("deploy failed with exit %s", result.returncode)
        else:
            log.info("deploy finished OK")
    except Exception:
        log.exception("deploy raised")


class Handler(BaseHTTPRequestHandler):
    server_version = "aula-s98-www-webhook/1.0"

    def log_message(self, fmt: str, *args) -> None:
        log.info("%s - " + fmt, self.address_string(), *args)

    def _send(self, code: int, body: str = "") -> None:
        data = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        if data:
            self.wfile.write(data)

    def do_GET(self) -> None:
        if self.path in ("/", "/healthz"):
            self._send(200, "ok\n")
        else:
            self._send(404, "not found\n")

    def do_POST(self) -> None:
        # Host nginx may forward the full URI or strip to /
        length = int(self.headers.get("Content-Length", "0"))
        body = self.rfile.read(length) if length > 0 else b""

        event = self.headers.get("X-GitHub-Event", "")
        sig = self.headers.get("X-Hub-Signature-256")

        if not verify_signature(body, sig):
            log.warning("rejected: bad signature")
            self._send(401, "invalid signature\n")
            return

        if event == "ping":
            self._send(200, "pong\n")
            return

        if event != "push":
            self._send(200, f"ignored event {event}\n")
            return

        try:
            payload = json.loads(body.decode("utf-8"))
        except json.JSONDecodeError:
            self._send(400, "invalid json\n")
            return

        ref = payload.get("ref", "")
        if ref != BRANCH_REF:
            log.info("ignoring push to %s", ref)
            self._send(200, f"ignored ref {ref}\n")
            return

        log.info(
            "accepted push %s → %s (%s)",
            payload.get("before", "?")[:8],
            payload.get("after", "?")[:8],
            ref,
        )
        threading.Thread(target=run_deploy, daemon=True).start()
        self._send(202, "accepted\n")


def main() -> None:
    if not SECRET:
        raise SystemExit("WEBHOOK_SECRET is required")
    if not os.path.isfile(DEPLOY_SCRIPT):
        raise SystemExit(f"DEPLOY_SCRIPT not found: {DEPLOY_SCRIPT}")

    server = HTTPServer((HOST, PORT), Handler)
    log.info("listening on http://%s:%s (branch %s)", HOST, PORT, BRANCH_REF)
    server.serve_forever()


if __name__ == "__main__":
    main()

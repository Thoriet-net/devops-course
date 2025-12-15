#!/usr/bin/env python3
import json
import sys
from pathlib import Path
import requests


def fail(msg: str, code: int = 1) -> "None":
    print(f"ERROR: {msg}", file=sys.stderr)
    raise SystemExit(code)


def load_config(path: Path) -> dict:
    if not path.exists():
        fail(f"Config not found: {path}", 11)

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        fail(f"Invalid JSON: {e}", 12)

    # Required keys + types
    for k in ("service", "timeout_seconds", "enabled"):
        if k not in data:
            fail(f"Missing key: {k}", 13)

    if not isinstance(data["service"], str) or not data["service"]:
        fail("service must be a non-empty string", 20)

    if not isinstance(data["timeout_seconds"], int) or data["timeout_seconds"] <= 0:
        fail("timeout_seconds must be a positive integer", 21)

    if not isinstance(data["enabled"], bool):
        fail("enabled must be true/false", 22)

    return data


def main() -> int:
    cfg = load_config(Path("config.json"))

    if not cfg["enabled"]:
        print("Service disabled – skipping")
        return 0

    # Public test API: httpbin
    try:
        r = requests.get(
            "https://api.github.com",
            params={"service": cfg["service"]},
            timeout=cfg["timeout_seconds"],
        )
        r.raise_for_status()
    except requests.RequestException as e:
        fail(f"HTTP request failed: {e}", 30)

    payload = r.json()
    print("OK")
    print(f"HTTP {r.status_code}")
    print(f"Final URL: {r.url}")
    print(f"Service: {cfg['service']}")
    print(f"Rate limit endpoint: {payload.get('rate_limit_url')}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
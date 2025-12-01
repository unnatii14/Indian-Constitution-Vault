"""Download authoritative sources listed in data/catalog/source_urls.csv."""
from __future__ import annotations

import csv
import hashlib
import logging
from pathlib import Path
from typing import Iterable

import requests

CATALOG_PATH = Path("data/catalog/source_urls.csv")
LOG_PATH = Path("data/logs/download_log.csv")
BASE_DIR = Path("data")
TIMEOUT = 45


def ensure_dirs() -> None:
    (BASE_DIR / "logs").mkdir(parents=True, exist_ok=True)
    (BASE_DIR / "raw" / "pdf").mkdir(parents=True, exist_ok=True)
    (BASE_DIR / "raw" / "html").mkdir(parents=True, exist_ok=True)


def read_rows() -> Iterable[dict]:
    with CATALOG_PATH.open(newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        for row in reader:
            yield row


def fetch(url: str) -> bytes:
    resp = requests.get(url, timeout=TIMEOUT)
    resp.raise_for_status()
    return resp.content


def checksum(data: bytes) -> str:
    digest = hashlib.sha256()
    digest.update(data)
    return digest.hexdigest()


def init_log() -> None:
    if LOG_PATH.exists():
        return
    with LOG_PATH.open("w", newline="", encoding="utf-8") as fh:
        writer = csv.writer(fh)
        writer.writerow(
            [
                "act_code",
                "local_filename",
                "status",
                "http_status",
                "sha256",
                "notes",
            ]
        )


def append_log(act_code: str, local_filename: str, status: str, http_status: int | None, sha256_hash: str | None, notes: str) -> None:
    with LOG_PATH.open("a", newline="", encoding="utf-8") as fh:
        writer = csv.writer(fh)
        writer.writerow([act_code, local_filename, status, http_status or "", sha256_hash or "", notes])


def process_row(row: dict) -> None:
    act_code = row.get("act_code", "").strip()
    url = row.get("url", "").strip()
    local = row.get("local_filename", "").strip()
    if not url or url == "UNKNOWN":
        append_log(act_code, local, "skipped", None, None, "URL missing or manual download required")
        return
    if not local:
        append_log(act_code, "", "skipped", None, None, "No local filename configured")
        return
    target = Path(local)
    target.parent.mkdir(parents=True, exist_ok=True)
    try:
        data = fetch(url)
    except requests.RequestException as exc:  # network failure
        append_log(act_code, local, "failed", getattr(exc.response, "status_code", None), None, f"error: {exc}")
        return
    target.write_bytes(data)
    sha = checksum(data)
    http_status = 200
    append_log(act_code, local, "downloaded", http_status, sha, "ok")


def main() -> None:
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    ensure_dirs()
    init_log()
    for row in read_rows():
        process_row(row)


if __name__ == "__main__":
    main()

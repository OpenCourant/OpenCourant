"""Download and validate external libraries required to build OpenCourant."""

import hashlib
import json
from pathlib import Path
import shutil
import sys
import urllib.request
import zipfile


def sha256_file(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def missing_required_files(extlib, manifest):
    return [
        name
        for name in manifest["required_files"]
        if not (extlib / name).is_file()
    ]


def main():
    source_root = Path(__file__).resolve().parents[2]
    manifest_path = source_root / "EXTLIB_VERSION.json"
    extlib = source_root / "extlib"

    with manifest_path.open(encoding="utf-8") as stream:
        manifest = json.load(stream)

    missing = missing_required_files(extlib, manifest)

    if not missing:
        print(f"Using external libraries version {manifest['version']}.")
        return 0

    url = manifest["url"]
    expected_sha256 = manifest["sha256"]
    archive = source_root / "extlib.zip"

    print(f"Need external libraries version {manifest['version']}.")
    print(f"Downloading: {url}")

    try:
        urllib.request.urlretrieve(url, archive)
    except Exception as exc:
        print(f"Download failed: {exc}", file=sys.stderr)
        return 1

    actual_sha256 = sha256_file(archive)

    if actual_sha256.lower() != expected_sha256.lower():
        print("SHA-256 verification failed.", file=sys.stderr)
        print(f"Expected: {expected_sha256}", file=sys.stderr)
        print(f"Actual:   {actual_sha256}", file=sys.stderr)
        archive.unlink(missing_ok=True)
        return 1

    print("SHA-256 verified.")

    if extlib.exists():
        shutil.rmtree(extlib)

    try:
        with zipfile.ZipFile(archive, "r") as zip_ref:
            zip_ref.extractall(source_root)
    except Exception as exc:
        print(f"Extraction failed: {exc}", file=sys.stderr)
        return 1

    missing = missing_required_files(extlib, manifest)

    if missing:
        print("Downloaded package is incomplete:", file=sys.stderr)
        for name in missing:
            print(f"  extlib/{name}", file=sys.stderr)
        return 1

    print(f"External libraries version {manifest['version']} ready.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

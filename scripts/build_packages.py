#!/usr/bin/env python3
"""Build and validate installable Zeus ZIP packages for EaglerModAPI."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import zipfile
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[1]
API_ID = "eaglermodapi"
TEST_MOD_ID = "eaglermodapi_example"
SUPPORTED_VERSIONS = {"26.2", "26.3"}
API_REQUIRED_FILES = (
    "main.lua",
    "src/core/init.lua",
    "src/compat/init.lua",
    "src/compat/detect.lua",
    "src/compat/probe.lua",
    "src/compat/versions/v26_2.lua",
    "src/compat/versions/v26_3.lua",
    "src/modules/player.lua",
    "src/modules/world.lua",
    "src/modules/hud.lua",
    "src/modules/events.lua",
    "src/modules/commands.lua",
    "src/modules/timer.lua",
    "src/modules/ui.lua",
)


def fail(message: str) -> None:
    raise ValueError(message)


def read_json(path: Path) -> dict:
    if not path.is_file():
        fail(f"Required metadata file is missing: {path.relative_to(ROOT)}")
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"Could not read valid JSON from {path.relative_to(ROOT)}: {exc}")
    if not isinstance(value, dict):
        fail(f"Metadata must contain a JSON object: {path.relative_to(ROOT)}")
    return value


def require_string(metadata: dict, key: str, label: str) -> str:
    value = metadata.get(key)
    if not isinstance(value, str) or not value.strip():
        fail(f"{label}: metadata field {key!r} must be a non-empty string")
    return value


def validate_metadata(api_meta: dict, test_meta: dict, expected_version: str | None) -> str:
    api_id = require_string(api_meta, "id", "API")
    test_id = require_string(test_meta, "id", "Test mod")
    if api_id != API_ID:
        fail(f"API metadata id must be {API_ID!r}, not {api_id!r}")
    if test_id != TEST_MOD_ID:
        fail(f"Test mod metadata id must be {TEST_MOD_ID!r}, not {test_id!r}")

    api_version = require_string(api_meta, "version", "API")
    test_version = require_string(test_meta, "version", "Test mod")
    if api_version != test_version:
        fail(
            "API and test mod versions must match "
            f"(API={api_version}, test mod={test_version})"
        )
    if expected_version and api_version != expected_version:
        fail(
            f"Tag version {expected_version!r} does not match metadata version "
            f"{api_version!r}"
        )

    for label, metadata in (("API", api_meta), ("Test mod", test_meta)):
        main_file = require_string(metadata, "main", label)
        if not (ROOT / ("main.lua" if label == "API" else "examples/consumer/main.lua")).is_file():
            fail(f"{label}: entry point {main_file!r} is missing")

        versions = metadata.get("minecraft")
        if not isinstance(versions, list) or not SUPPORTED_VERSIONS.issubset(set(versions)):
            fail(
                f"{label}: metadata.minecraft must include "
                f"{', '.join(sorted(SUPPORTED_VERSIONS))}"
            )

    dependencies = test_meta.get("dependencies")
    if not isinstance(dependencies, dict) or API_ID not in dependencies:
        fail(f"Test mod must declare {API_ID!r} in metadata.dependencies")

    return api_version


def collect_api_files() -> list[tuple[Path, str]]:
    files: list[tuple[Path, str]] = []
    for relative in ("metadata.json", "main.lua"):
        source = ROOT / relative
        if not source.is_file():
            fail(f"Required API package file is missing: {relative}")
        files.append((source, relative))

    for relative in API_REQUIRED_FILES:
        if not (ROOT / relative).is_file():
            fail(f"Required API source file is missing: {relative}")

    src_root = ROOT / "src"
    for source in sorted(src_root.rglob("*")):
        if source.is_symlink():
            fail(f"Symbolic links are not allowed in the package: {source}")
        if source.is_file():
            files.append((source, source.relative_to(ROOT).as_posix()))

    return files


def collect_test_files() -> list[tuple[Path, str]]:
    files = []
    for relative in ("metadata.json", "main.lua"):
        source = ROOT / "examples" / "consumer" / relative
        if not source.is_file():
            fail(f"Required test mod package file is missing: examples/consumer/{relative}")
        files.append((source, relative))
    return files


def create_zip(destination: Path, files: list[tuple[Path, str]]) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(
        destination, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9
    ) as archive:
        for source, archive_name in files:
            normalized = PurePosixPath(archive_name)
            if normalized.is_absolute() or ".." in normalized.parts:
                fail(f"Unsafe ZIP path: {archive_name}")
            # A fixed timestamp keeps package contents reproducible between builds.
            info = zipfile.ZipInfo(archive_name, date_time=(2020, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(
                info, source.read_bytes(), compress_type=zipfile.ZIP_DEFLATED,
                compresslevel=9
            )

    with zipfile.ZipFile(destination, "r") as archive:
        bad_member = archive.testzip()
        if bad_member is not None:
            fail(f"ZIP integrity check failed for {destination.name}: {bad_member}")
        names = set(archive.namelist())
        if "metadata.json" not in names:
            fail(f"{destination.name} does not have metadata.json at its root")
        metadata = json.loads(archive.read("metadata.json").decode("utf-8"))
        if metadata.get("main") not in names:
            fail(f"{destination.name} is missing its declared entry point")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", type=Path, default=ROOT / "dist")
    parser.add_argument(
        "--expected-version",
        help="Optional release-tag version (for example, 0.2.0 for tag v0.2.0)",
    )
    args = parser.parse_args()

    try:
        api_meta = read_json(ROOT / "metadata.json")
        test_meta = read_json(ROOT / "examples/consumer/metadata.json")
        version = validate_metadata(api_meta, test_meta, args.expected_version)

        output_dir = args.output_dir.resolve()
        output_dir.mkdir(parents=True, exist_ok=True)
        api_zip = output_dir / f"EaglerModAPI-{version}.zip"
        test_zip = output_dir / f"EaglerModAPI-TestMod-{version}.zip"

        create_zip(api_zip, collect_api_files())
        create_zip(test_zip, collect_test_files())

        checksum_file = output_dir / "SHA256SUMS.txt"
        checksum_file.write_text(
            f"{sha256(api_zip)}  {api_zip.name}\n"
            f"{sha256(test_zip)}  {test_zip.name}\n",
            encoding="utf-8",
        )

        print(f"Built and verified: {api_zip}")
        print(f"Built and verified: {test_zip}")
        print(f"Checksums: {checksum_file}")
        return 0
    except (OSError, ValueError, zipfile.BadZipFile, json.JSONDecodeError) as exc:
        print(f"Build failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())

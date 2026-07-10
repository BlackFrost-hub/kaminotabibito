from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent


def validate_flat_items(data: object, source_name: str) -> list[dict[str, str]]:
    if not isinstance(data, list):
        raise ValueError(f"flat manifest must be a JSON array: {source_name}")
    for index, item in enumerate(data):
        if not isinstance(item, dict):
            raise ValueError(f"manifest item {index} must be an object: {source_name}")
        if "source" not in item or "target" not in item:
            raise ValueError(f"manifest item {index} requires source and target: {source_name}")
    return data


def expand_group(data: object, source_name: str) -> list[dict[str, str]]:
    if isinstance(data, list):
        return validate_flat_items(data, source_name)
    if not isinstance(data, dict):
        raise ValueError(f"manifest group must be an object: {source_name}")

    source_dir = data.get("sourceDir")
    target_dir = data.get("targetDir")
    files = data.get("files")
    if not isinstance(source_dir, str) or not isinstance(target_dir, str) or not isinstance(files, list):
        raise ValueError(f"manifest group requires sourceDir, targetDir, and files: {source_name}")

    items: list[dict[str, str]] = []
    for index, entry in enumerate(files):
        if isinstance(entry, str):
            file_name = entry
            note = data.get("note")
        elif isinstance(entry, dict) and isinstance(entry.get("name"), str):
            file_name = entry["name"]
            note = entry.get("note", data.get("note"))
        else:
            raise ValueError(f"invalid file entry {index}: {source_name}")

        item = {
            "source": str((PROJECT_ROOT / source_dir / file_name).resolve()),
            "target": f"{target_dir.rstrip('/\\')}/{file_name}",
        }
        if isinstance(note, str) and note:
            item["note"] = note
        items.append(item)
    return items


def load_manifest(path: Path) -> list[dict[str, str]]:
    manifest_files = sorted(path.rglob("*.json")) if path.is_dir() else [path]
    if not manifest_files:
        raise FileNotFoundError(f"no manifest JSON files found: {path}")

    items: list[dict[str, str]] = []
    for manifest_file in manifest_files:
        data = json.loads(manifest_file.read_text(encoding="utf-8-sig"))
        items.extend(expand_group(data, str(manifest_file)))

    targets: set[str] = set()
    for item in items:
        target = item["target"].replace("\\", "/").lower()
        if target in targets:
            raise ValueError(f"duplicate manifest target: {item['target']}")
        targets.add(target)
    return items


def normalize_target(target: str) -> Path:
    clean = target.replace("/", "\\").lstrip("\\/")
    if ":" in clean:
        raise ValueError(f"target must be archive-relative, got absolute path: {target}")
    return Path(clean)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Collect confirmed voice files into a Warcraft 3 external voice pack staging folder."
    )
    parser.add_argument("--manifest", default="voice_pack_manifest", help="manifest JSON file or directory")
    parser.add_argument("--out", default="build/voice-pack/mpq-root", help="staging folder")
    args = parser.parse_args()

    manifest_path = Path(args.manifest).resolve()
    out_dir = Path(args.out).resolve()
    items = load_manifest(manifest_path)

    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    copied: list[str] = []
    for item in items:
        source = Path(item["source"])
        if not source.is_absolute():
            source = (PROJECT_ROOT / source).resolve()
        if not source.is_file():
            raise FileNotFoundError(source)
        target = normalize_target(item["target"])
        dest = out_dir / target
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, dest)
        copied.append(str(target))

    listfile = out_dir / "(listfile)"
    listfile.write_text("\n".join(copied) + "\n", encoding="utf-8")

    print(f"Copied {len(copied)} files to {out_dir}")
    print(f"Wrote {listfile}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path


def load_manifest(path: Path) -> list[dict[str, str]]:
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    if not isinstance(data, list):
        raise ValueError("manifest must be a JSON array")
    for index, item in enumerate(data):
        if not isinstance(item, dict):
            raise ValueError(f"manifest item {index} must be an object")
        if "source" not in item or "target" not in item:
            raise ValueError(f"manifest item {index} requires source and target")
    return data


def normalize_target(target: str) -> Path:
    clean = target.replace("/", "\\").lstrip("\\/")
    if ":" in clean:
        raise ValueError(f"target must be archive-relative, got absolute path: {target}")
    return Path(clean)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Collect confirmed voice files into a Warcraft 3 external voice pack staging folder."
    )
    parser.add_argument("--manifest", default="voice_pack_manifest.json", help="JSON manifest path")
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
        source = Path(item["source"]).resolve()
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

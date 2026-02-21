#!/usr/bin/env python3
"""
新しいリリースを検知し versions.json と Cargo.lock を更新する。
nurl (nix run nixpkgs#nurl) が PATH にある前提。
"""
import argparse
import json
import subprocess
import urllib.request
from pathlib import Path


def get_latest_tag(owner: str, repo: str) -> str:
    url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"
    req = urllib.request.Request(url, headers={"User-Agent": "update-package.py"})
    with urllib.request.urlopen(req) as r:
        return json.loads(r.read())["tag_name"]


def get_src_hash(owner: str, repo: str, tag: str) -> str:
    result = subprocess.run(
        [
            "nix",
            "run",
            "nixpkgs#nurl",
            "--",
            f"https://github.com/{owner}/{repo}",
            tag,
        ],
        capture_output=True,
        text=True,
        check=True,
    )
    for line in result.stdout.splitlines():
        if "hash" in line:
            return line.split('"')[1]
    raise ValueError(f"hash not found in nurl output:\n{result.stdout}")


def download_cargo_lock(owner: str, repo: str, tag: str, subpath: str, dest: Path) -> None:
    raw_url = f"https://raw.githubusercontent.com/{owner}/{repo}/{tag}/{subpath}"
    req = urllib.request.Request(raw_url, headers={"User-Agent": "update-package.py"})
    with urllib.request.urlopen(req) as r:
        dest.write_bytes(r.read())


def main() -> None:
    parser = argparse.ArgumentParser(description="Update Nix package version data")
    parser.add_argument("--name", required=True, help="Package name (e.g. codex)")
    parser.add_argument("--owner", required=True, help="GitHub owner (e.g. openai)")
    parser.add_argument("--repo", required=True, help="GitHub repo (e.g. codex)")
    parser.add_argument("--tag-prefix", required=True, help="Tag prefix (e.g. rust-v)")
    parser.add_argument(
        "--cargo-lock-subpath",
        required=True,
        help="Path to Cargo.lock inside the repo (e.g. codex-rs/Cargo.lock)",
    )
    args = parser.parse_args()

    versions_file = Path(f"nix/pkgs/{args.name}/versions.json")
    lock_dir = Path(f"nix/pkgs/{args.name}/locks")
    lock_dir.mkdir(parents=True, exist_ok=True)

    if versions_file.exists():
        data = json.loads(versions_file.read_text())
    else:
        data = {"latest": "", "versions": {}}

    tag = get_latest_tag(args.owner, args.repo)
    version = tag.removeprefix(args.tag_prefix)

    if version in data["versions"]:
        print(f"Already at {version}, nothing to do.")
        return

    print(f"New version found: {version}")
    src_hash = get_src_hash(args.owner, args.repo, tag)

    lock_dest = lock_dir / f"{version}.lock"
    print(f"Downloading Cargo.lock to {lock_dest} ...")
    download_cargo_lock(args.owner, args.repo, tag, args.cargo_lock_subpath, lock_dest)

    previous = data.get("latest", "?")
    data["versions"][version] = {"srcHash": src_hash}
    data["latest"] = version
    versions_file.write_text(json.dumps(data, indent=2) + "\n")

    print(f"Updated: {args.name} {previous} -> {version}")


if __name__ == "__main__":
    main()

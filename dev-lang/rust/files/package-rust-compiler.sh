#!/usr/bin/env bash
set -Eeuo pipefail

source_dir="${1:-}"
dest_dir="${2:-}"
[[ -n "$source_dir" && -d "$source_dir" && ! -L "$source_dir" ]] || {
    echo 'package-rust-compiler.sh: validated compiler input directory is required' >&2
    exit 2
}
[[ -n "$dest_dir" && "$dest_dir" == */pkg/main/dev-lang.rust.core.* ]] || {
    echo 'package-rust-compiler.sh: APKG core destination is invalid' >&2
    exit 2
}
[[ -x "$source_dir/bin/rustc" && -x "$source_dir/bin/cargo" && -d "$source_dir/lib/rustlib" ]] || {
    echo 'package-rust-compiler.sh: compiler input is incomplete' >&2
    exit 1
}
mkdir -p -- "$dest_dir"
cp -a -- "$source_dir/." "$dest_dir/"

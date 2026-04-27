#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
build_dir="$repo_dir/.build"
binary="$build_dir/hyper-overlay"
source_file="$repo_dir/scripts/HyperOverlay.m"
pid_file="${TMPDIR:-/tmp}/codex-hyper-overlay.pid"

is_running() {
  [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" >/dev/null 2>&1
}

case "${1:-}" in
  show)
    if is_running; then
      exit 0
    fi

    mkdir -p "$build_dir"
    if [ ! -x "$binary" ] || [ "$source_file" -nt "$binary" ]; then
      /usr/bin/clang "$source_file" -framework Cocoa -o "$binary"
    fi

    "$binary" >/dev/null 2>&1 &
    echo "$!" > "$pid_file"
    ;;
  hide)
    if is_running; then
      kill "$(cat "$pid_file")" >/dev/null 2>&1 || true
    fi
    rm -f "$pid_file"
    ;;
  *)
    echo "usage: $0 show|hide" >&2
    exit 2
    ;;
esac

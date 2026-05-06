#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
build_dir="$repo_dir/.build"
binary="$build_dir/hyper-overlay"
source_file="$repo_dir/scripts/HyperOverlay.m"
pid_file="${TMPDIR:-/tmp}/codex-hyper-overlay.pid"
max_seconds="${HYPER_OVERLAY_MAX_SECONDS:-6}"

is_running() {
  [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" >/dev/null 2>&1
}

stop_overlay() {
  if is_running; then
    kill "$(cat "$pid_file")" >/dev/null 2>&1 || true
  fi

  pkill -x "$(basename "$binary")" >/dev/null 2>&1 || true
  rm -f "$pid_file"
}

case "${1:-}" in
  show)
    text="${2:-hyper}"
    stop_overlay

    mkdir -p "$build_dir"
    if [ ! -x "$binary" ] || [ "$source_file" -nt "$binary" ]; then
      /usr/bin/clang "$source_file" -framework Cocoa -o "$binary"
    fi

    "$binary" "$text" "$max_seconds" >/dev/null 2>&1 &
    echo "$!" > "$pid_file"
    ;;
  hide)
    stop_overlay
    ;;
  *)
    echo "usage: $0 show [text]|hide" >&2
    exit 2
    ;;
esac

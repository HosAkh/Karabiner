#!/usr/bin/env sh
set -eu

case "${1:-}" in
  dia) app="Dia" ;;
  messages) app="Messages" ;;
  whatsapp) app="WhatsApp" ;;
  slack) app="Slack" ;;
  codex) app="Codex" ;;
  spark) app="Spark" ;;
  *) echo "usage: $0 dia|messages|whatsapp|slack|codex|spark" >&2; exit 2 ;;
esac

open -a "$app"

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="Brickforge Breakout"
PROCESS_NAME="BrickforgeBreakout"
APP_DIR="$ROOT_DIR/dist/$APP_NAME.app"
MODE="${1:-run}"

if pgrep -x "$PROCESS_NAME" >/dev/null 2>&1; then
  pkill -x "$PROCESS_NAME"
fi

"$ROOT_DIR/scripts/package-brickforge.sh" >/dev/null

open_app() {
  /usr/bin/open -n "$APP_DIR"
}

case "$MODE" in
  run)
    open_app
    ;;
  --debug|debug)
    lldb -- "$APP_DIR/Contents/MacOS/$PROCESS_NAME"
    ;;
  --logs|logs)
    open_app
    /usr/bin/log stream --info --style compact --predicate "process == \"$PROCESS_NAME\""
    ;;
  --telemetry|telemetry)
    open_app
    /usr/bin/log stream --info --style compact --predicate "process == \"$PROCESS_NAME\""
    ;;
  --verify|verify)
    open_app
    sleep 1
    pgrep -x "$PROCESS_NAME" >/dev/null
    echo "$APP_NAME launched"
    ;;
  *)
    echo "usage: $0 [run|--debug|--logs|--telemetry|--verify]" >&2
    exit 2
    ;;
esac

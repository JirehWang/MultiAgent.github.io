#!/usr/bin/env bash
# Stop the brainstorm server and clean up
# Usage: stop-server.sh <session_dir>
#
# Kills the server process. Only deletes session directory if it's
# under the operating system temporary directory (ephemeral). Persistent directories (.superpowers/) are
# kept so mockups can be reviewed later.

SESSION_DIR="$1"

if [[ -z "$SESSION_DIR" ]]; then
  echo '{"error": "Usage: stop-server.sh <session_dir>"}'
  exit 1
fi

CANONICAL_SESSION_DIR=$(python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$SESSION_DIR" 2>/dev/null)
CANONICAL_TEMP_ROOT=$(python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "${TMPDIR:-/tmp}" 2>/dev/null)
if [[ -z "$CANONICAL_SESSION_DIR" ]]; then
  echo '{"status": "failed", "error": "unable to resolve session directory"}'
  exit 1
fi
if [[ -z "$CANONICAL_TEMP_ROOT" ]]; then
  echo '{"status": "failed", "error": "unable to resolve temporary directory"}'
  exit 1
fi
if [[ "$CANONICAL_TEMP_ROOT" == "/" ]]; then
  echo '{"status": "failed", "error": "temporary directory cannot be the filesystem root"}'
  exit 1
fi

STATE_DIR="${SESSION_DIR}/state"
PID_FILE="${STATE_DIR}/server.pid"

if [[ -f "$PID_FILE" ]]; then
  pid=$(cat "$PID_FILE")

  # Try to stop gracefully, fallback to force if still alive
  kill "$pid" 2>/dev/null || true

  # Wait for graceful shutdown (up to ~2s)
  for i in {1..20}; do
    if ! kill -0 "$pid" 2>/dev/null; then
      break
    fi
    sleep 0.1
  done

  # If still running, escalate to SIGKILL
  if kill -0 "$pid" 2>/dev/null; then
    kill -9 "$pid" 2>/dev/null || true

    # Give SIGKILL a moment to take effect
    sleep 0.1
  fi

  if kill -0 "$pid" 2>/dev/null; then
    echo '{"status": "failed", "error": "process still running"}'
    exit 1
  fi

  rm -f "$PID_FILE" "${STATE_DIR}/server.log"

  # Only delete session children of the resolved temporary root; never delete the root itself.
  if [[ "$CANONICAL_SESSION_DIR" == "$CANONICAL_TEMP_ROOT"/* && "$CANONICAL_SESSION_DIR" != "$CANONICAL_TEMP_ROOT" ]]; then
    rm -rf "$CANONICAL_SESSION_DIR"
  fi

  echo '{"status": "stopped"}'
else
  echo '{"status": "not_running"}'
fi

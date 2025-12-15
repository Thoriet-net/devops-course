#!/bin/bash
set -euo pipefail

CONFIG="configs/service.json"

fail() {
  echo "ERROR: $1" >&2
  exit "${2:-1}"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1" 10
}

# --- preflight ---
require_cmd jq
[[ -f "$CONFIG" ]] || fail "Config not found: $CONFIG" 11

# --- helpers ---
require_key() {
  local key="$1"
  jq -e "has(\"$key\") and .${key} != null" "$CONFIG" >/dev/null \
    || fail "Missing or null key in config: $key" 12
}

get_string() {
  local key="$1"
  jq -er ".${key} | strings" "$CONFIG"  # fails if not a string
}

get_number() {
  local key="$1"
  jq -er ".${key} | numbers" "$CONFIG"  # fails if not a number
}

get_bool() {
  local key="$1"
  jq -er ".${key} | booleans" "$CONFIG" # fails if not true/false
}

# --- validate required keys ---
require_key "name"
require_key "port"
require_key "enabled"
require_key "environment"

# --- typed reads (fail fast if wrong type) ---
NAME=$(get_string "name")            || fail "name must be a string" 20
PORT=$(get_number "port")            || fail "port must be a number" 21
ENABLED=$(get_bool "enabled")        || fail "enabled must be true/false" 22
ENV=$(get_string "environment")      || fail "environment must be a string" 23

# --- additional validation ---
# port range
if (( PORT < 1 || PORT > 65535 )); then
  fail "port out of range (1-65535): $PORT" 24
fi

echo "Service: $NAME"
echo "Environment: $ENV"
echo "Port: $PORT"

if [[ "$ENABLED" != "true" ]]; then
  echo "Service disabled – skipping"
  exit 0
fi

echo "Applying configuration for $NAME"
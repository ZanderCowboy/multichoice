#!/usr/bin/env bash
# Resolves PR version labels to a single bump_type using .github/config/version-labels.json.
#
# Environment:
#   LABELS_JSON   - JSON array of PR label objects (or null/empty)
#   CONFIG_PATH   - Path to version-labels.json (default: .github/config/version-labels.json)
#   TARGET_BRANCH - Optional base branch for allowed_bumps check (e.g. develop, rc)
#   MODE          - resolve (default) | validate
#
# Writes to GITHUB_OUTPUT: bump_type, valid, error_message, matched_labels

set -euo pipefail

CONFIG_PATH="${CONFIG_PATH:-.github/config/version-labels.json}"
MODE="${MODE:-resolve}"
TARGET_BRANCH="${TARGET_BRANCH:-}"

write_output() {
  local key="$1"
  local value="$2"
  {
    echo "${key}<<EOF"
    echo "$value"
    echo "EOF"
  } >> "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"
}

fail() {
  local message="$1"
  local hard="${2:-false}"
  write_output "valid" "false"
  write_output "error_message" "$message"
  write_output "bump_type" "none"
  write_output "matched_labels" "${matched_labels_csv:-}"
  echo "::error::$message"
  if [[ "$MODE" == "validate" || "$hard" == "true" ]]; then
    exit 1
  fi
}

# Normalize labels JSON
if [[ -z "${LABELS_JSON:-}" || "$LABELS_JSON" == "null" ]]; then
  LABELS_JSON='[]'
fi

if ! echo "$LABELS_JSON" | jq empty 2>/dev/null; then
  fail "Invalid JSON format in labels" true
fi

if ! echo "$LABELS_JSON" | jq -e 'type == "array"' >/dev/null 2>&1; then
  fail "Labels must be a JSON array" true
fi

if [[ ! -f "$CONFIG_PATH" ]]; then
  fail "Config file not found: $CONFIG_PATH" true
fi

if ! jq empty "$CONFIG_PATH" 2>/dev/null; then
  fail "Invalid JSON in config: $CONFIG_PATH" true
fi

label_names=$(echo "$LABELS_JSON" | jq -r 'map(.name) | .[]' 2>/dev/null || true)

# Build label -> tier lookup from config categories
lookup=$(jq -r '
  .categories
  | to_entries[]
  | .key as $tier
  | .value[]
  | "\(.)\t\($tier)"
' "$CONFIG_PATH")

no_build_labels=$(jq -r '.no_build[]' "$CONFIG_PATH")

has_no_build=false
matched_tiers=()
matched_labels_list=()

tier_for_label() {
  local name="$1"
  echo "$lookup" | awk -F'\t' -v n="$name" '$1 == n { print $2; exit }'
}

is_no_build_label() {
  local name="$1"
  echo "$no_build_labels" | grep -Fxq "$name"
}

while IFS= read -r label_name; do
  [[ -z "$label_name" ]] && continue

  if is_no_build_label "$label_name"; then
    has_no_build=true
    matched_labels_list+=("$label_name")
    continue
  fi

  tier=$(tier_for_label "$label_name")
  if [[ -n "$tier" ]]; then
    matched_labels_list+=("$label_name")
    # Track unique tiers in priority order
    if [[ ! " ${matched_tiers[*]:-} " =~ " ${tier} " ]]; then
      matched_tiers+=("$tier")
    fi
  fi
done <<< "$label_names"

matched_labels_csv=$(IFS=,; echo "${matched_labels_list[*]:-}")

# no-build only: skip semantic bump (deploy workflow skips job separately)
if [[ "$has_no_build" == "true" && ${#matched_tiers[@]} -eq 0 ]]; then
  write_output "bump_type" "none"
  write_output "valid" "true"
  write_output "error_message" ""
  write_output "matched_labels" "$matched_labels_csv"
  echo "********** no-build label present, skipping semantic bump **********"
  exit 0
fi

# no-build + version tier = conflict
if [[ "$has_no_build" == "true" && ${#matched_tiers[@]} -gt 0 ]]; then
  fail "Conflicting labels: no-build cannot be combined with version bump labels (${matched_labels_csv})"
fi

# Multiple distinct version tiers
if [[ ${#matched_tiers[@]} -gt 1 ]]; then
  tiers_csv=$(IFS=,; echo "${matched_tiers[*]}")
  message="Conflicting version labels across tiers (${tiers_csv}): ${matched_labels_csv}"
  if [[ "$MODE" == "validate" ]]; then
    fail "$message"
  fi
  echo "::warning::$message"
  for tier in major minor patch; do
    if [[ " ${matched_tiers[*]} " =~ " ${tier} " ]]; then
      bump_type="$tier"
      break
    fi
  done
  write_output "bump_type" "$bump_type"
  write_output "valid" "false"
  write_output "error_message" "$message"
  write_output "matched_labels" "$matched_labels_csv"
  echo "********** resolved conflict to bump_type=${bump_type} **********"
  exit 0
fi

# Resolve bump_type by priority
bump_type="none"
if [[ ${#matched_tiers[@]} -eq 1 ]]; then
  bump_type="${matched_tiers[0]}"
fi

# Branch rule check
if [[ -n "$TARGET_BRANCH" ]]; then
  allowed=$(jq -r --arg branch "$TARGET_BRANCH" --arg bump "$bump_type" '
    .branches[$branch].allowed_bumps // [] | index($bump) != null
  ' "$CONFIG_PATH")

  if [[ "$allowed" != "true" ]]; then
    allowed_list=$(jq -r --arg branch "$TARGET_BRANCH" '
      (.branches[$branch].allowed_bumps // []) | join(", ")
    ' "$CONFIG_PATH")
    fail "Bump type '${bump_type}' is not allowed on branch '${TARGET_BRANCH}'. Allowed: ${allowed_list}" true
  fi
fi

write_output "bump_type" "$bump_type"
write_output "valid" "true"
write_output "error_message" ""
write_output "matched_labels" "$matched_labels_csv"

case "$bump_type" in
  major) echo "********** major label present, bumping major **********" ;;
  minor) echo "********** minor label present, bumping minor **********" ;;
  patch) echo "********** patch label present, bumping patch **********" ;;
  none)  echo "********** no version label found, bumping build only **********" ;;
esac

exit 0

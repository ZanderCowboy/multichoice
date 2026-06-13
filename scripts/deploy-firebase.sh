#!/usr/bin/env bash
# Redeploy Firebase resources (functions, Firestore rules/indexes, Storage rules)
# for DEV or PROD. Run from any directory; resolves repo root automatically.
#
# Usage:
#   ./scripts/deploy-firebase.sh dev
#   ./scripts/deploy-firebase.sh prod
#   ./scripts/deploy-firebase.sh all
#   ./scripts/deploy-firebase.sh dev --only functions
#   ./scripts/deploy-firebase.sh prod --non-interactive
#
# Requires: Node 22, firebase CLI (firebase login), and per-project env files:
#   functions/.env.multichoice-app-develop
#   functions/.env.multichoice-412309

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEV_PROJECT="multichoice-app-develop"
PROD_PROJECT="multichoice-412309"
DEFAULT_ONLY="firestore:rules,firestore:indexes,storage,functions"

ENVIRONMENT=""
ONLY="$DEFAULT_ONLY"
NON_INTERACTIVE=false

usage() {
  cat <<EOF
Usage: $(basename "$0") <dev|prod|all> [options]

Deploy Firebase resources defined in firebase.json:
  - Cloud Functions (with predeploy lint + build)
  - Firestore rules and indexes
  - Storage rules

Options:
  --only <targets>     firebase deploy --only value (default: $DEFAULT_ONLY)
  --non-interactive    Pass --non-interactive to firebase deploy
  -h, --help           Show this help

Examples:
  $(basename "$0") dev
  $(basename "$0") prod --only functions
  $(basename "$0") all --non-interactive
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    dev|prod|all)
      ENVIRONMENT="$1"
      shift
      ;;
    --only)
      ONLY="${2:-}"
      if [[ -z "$ONLY" ]]; then
        echo "Error: --only requires a value" >&2
        exit 1
      fi
      shift 2
      ;;
    --non-interactive)
      NON_INTERACTIVE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument '$1'" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$ENVIRONMENT" ]]; then
  echo "Error: environment required (dev, prod, or all)" >&2
  usage >&2
  exit 1
fi

if ! command -v firebase >/dev/null 2>&1; then
  echo "Error: firebase CLI not found. Install with: npm install -g firebase-tools" >&2
  exit 1
fi

ensure_functions_deps() {
  if [[ ! -d "$ROOT/functions/node_modules" ]]; then
    echo "Installing functions dependencies..."
    npm --prefix "$ROOT/functions" ci
  fi
}

check_env_file() {
  local project_id="$1"
  local env_file="$ROOT/functions/.env.$project_id"
  if [[ ! -f "$env_file" ]]; then
    echo "Warning: $env_file not found."
    echo "         Functions deploy needs EMAIL_USER and EMAIL_PASS for $project_id."
    echo "         See docs/firebase-functions-environments.md"
  fi
}

deploy_project() {
  local project_id="$1"
  local label="$2"

  echo ""
  echo "=== Deploying $label ($project_id) ==="
  check_env_file "$project_id"
  ensure_functions_deps

  local args=(deploy --only "$ONLY" --project "$project_id")
  if [[ "$NON_INTERACTIVE" == true ]]; then
    args+=(--non-interactive)
  fi

  cd "$ROOT"
  firebase "${args[@]}"
}

case "$ENVIRONMENT" in
  dev)
    deploy_project "$DEV_PROJECT" "DEV"
    ;;
  prod)
    deploy_project "$PROD_PROJECT" "PROD"
    ;;
  all)
    deploy_project "$DEV_PROJECT" "DEV"
    deploy_project "$PROD_PROJECT" "PROD"
    ;;
esac

echo ""
echo "Done. Deployed to: $ENVIRONMENT"

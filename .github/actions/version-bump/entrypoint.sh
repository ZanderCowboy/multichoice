#!/bin/bash

set -e

LABELS=$(gh pr view "$PR_NUMBER" --json labels -q '.labels[].name')

BUMP_TYPE=""
if echo "$LABELS" | grep -qi "major"; then
  BUMP_TYPE="major"
elif echo "$LABELS" | grep -qi "minor"; then
  BUMP_TYPE="minor"
elif echo "$LABELS" | grep -qi "patch"; then
  BUMP_TYPE="patch"
fi

if [ -z "$BUMP_TYPE" ]; then
  echo "No version bump label found (major/minor/patch). Exiting."
  exit 0
fi

# Extract current version from pubspec.yaml
CURRENT_VERSION=$(grep '^version:' "$VERSION_FILE" | sed 's/version: //')

SEMVER=$(echo "$CURRENT_VERSION" | cut -d '+' -f 1)
BUILD_NUM=$(echo "$CURRENT_VERSION" | cut -d '+' -f 2)

MAJOR=$(echo "$SEMVER" | cut -d '.' -f 1)
MINOR=$(echo "$SEMVER" | cut -d '.' -f 2)
PATCH=$(echo "$SEMVER" | cut -d '.' -f 3)

case $BUMP_TYPE in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

# Increment build number always
BUILD_NUM=$((BUILD_NUM + 1))

NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD_NUM"

# Update pubspec.yaml
sed -i -E "s/^version: .*/version: $NEW_VERSION/" "$VERSION_FILE"

# Commit changes
git add "$VERSION_FILE"
git commit -m "chore: bump version to $NEW_VERSION"
git push origin HEAD

echo "Version bumped to $NEW_VERSION"

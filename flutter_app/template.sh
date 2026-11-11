#!/bin/bash
# Generator template: the project comes from `flutter create`. cwd is the
# (empty) project directory kxbuild created.
#
#   1. flutter create .   → Dart package + ios/ + android/ (runs pub get, which
#                           also writes ios/Flutter/Generated.xcconfig)
#   2. PRODUCT_BUNDLE_IDENTIFIER of the Runner target = $KXBUILD_BUNDLE_ID
#   3. kxbuild doctor       → the SDK-level Flutter fixes (iOS engine precache,
#                           xcframework normalization, xcode_backend patch on
#                           Windows) plus the KXBuild Flutter component. Global,
#                           idempotent; the project is complete without it, so a
#                           doctor failure only warns.
set -euo pipefail

FLUTTER=flutter
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) FLUTTER=flutter.bat ;; esac

if ! command -v "$FLUTTER" >/dev/null 2>&1; then
  echo "flutter not found on PATH — install the Flutter SDK (https://docs.flutter.dev/get-started/install) and retry" >&2
  exit 1
fi

# Dart package names are lowercase_with_underscores; the org is the bundle id
# minus its last segment (flutter appends the package name itself, which is
# why the real bundle id is written into the Xcode project afterwards).
PACKAGE=$(printf '%s' "$KXBUILD_PROJECT_NAME" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr 'A-Z' 'a-z')
ORG=${KXBUILD_BUNDLE_ID%.*}

echo "==> flutter create (package $PACKAGE, org $ORG)"
"$FLUTTER" create --project-name "$PACKAGE" --org "$ORG" --platforms ios,android .

echo "==> Setting PRODUCT_BUNDLE_IDENTIFIER = $KXBUILD_BUNDLE_ID on the Runner target"
"$KXBUILD_BIN" project add-setting --key PRODUCT_BUNDLE_IDENTIFIER --value "$KXBUILD_BUNDLE_ID" \
  --target Runner --project ios/Runner.xcodeproj

echo "==> kxbuild doctor (Flutter SDK fixes)"
if ! "$KXBUILD_BIN" doctor; then
  echo "warning: kxbuild doctor failed — run 'kxbuild doctor' again before building the iOS app" >&2
fi

# AGENTS.md: how an AI coding agent builds, runs and inspects this project with kxbuild.
sed -e "s/__NAME__/$KXBUILD_PROJECT_NAME/g" -e "s/__BUNDLE_ID__/$KXBUILD_BUNDLE_ID/g"   "$KXBUILD_TEMPLATE_DIR/template.files/AGENTS.md" > AGENTS.md

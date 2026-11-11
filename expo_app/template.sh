#!/bin/bash
# Generator template: the project comes from create-expo-app. cwd is the
# (empty) project directory kxbuild created.
#
#   1. npx create-expo-app .        → JS project (no ios/ yet)
#   2. app.json                     → ios.bundleIdentifier = $KXBUILD_BUNDLE_ID
#   3. kxbuild doctor .               → patches @expo/cli and runs `expo prebuild -p ios`
#   4. pod install                  → ios/<Name>.xcworkspace
set -euo pipefail

NPX=npx; NODE=node; POD=pod
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) NPX=npx.cmd; NODE=node.exe; POD=pod.bat ;; esac

for tool in "$NPX" "$NODE" "$POD"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "$tool not found — install Node.js / CocoaPods (kxbuild doctor installs CocoaPods) and retry" >&2
    exit 1
  fi
done

echo "==> Creating Expo project $KXBUILD_PROJECT_NAME"
"$NPX" --yes create-expo-app@latest . --yes --no-agents-md

echo "==> Setting ios.bundleIdentifier = $KXBUILD_BUNDLE_ID in app.json"
"$NODE" -e '
const fs = require("fs");
const app = JSON.parse(fs.readFileSync("app.json", "utf8"));
app.expo = app.expo || {};
app.expo.name = process.env.KXBUILD_PROJECT_NAME;
app.expo.ios = Object.assign({}, app.expo.ios, { bundleIdentifier: process.env.KXBUILD_BUNDLE_ID });
fs.writeFileSync("app.json", JSON.stringify(app, null, 2) + "\n");
'

echo "==> kxbuild doctor (Expo patches + expo prebuild --platform ios)"
"$KXBUILD_BIN" doctor .

echo "==> pod install"
(cd ios && "$POD" install)

# AGENTS.md: how an AI coding agent builds, runs and inspects this project with kxbuild.
sed -e "s/__NAME__/$KXBUILD_PROJECT_NAME/g" -e "s/__BUNDLE_ID__/$KXBUILD_BUNDLE_ID/g"   "$KXBUILD_TEMPLATE_DIR/template.files/AGENTS.md" > AGENTS.md

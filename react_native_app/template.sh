#!/bin/bash
# Generator template: the whole project comes from the React Native community
# CLI. cwd is the (empty) project directory kxbuild created.
#
#   1. npx @react-native-community/cli init   → JS project + ios/ (no pods)
#   2. kxbuild doctor .                          → the Windows / Linux patches (the JS
#                                                project is already complete here, so
#                                                a doctor failure only warns; pod
#                                                install surfaces any missing patch)
#   3. pod install                             → ios/<Name>.xcworkspace
set -euo pipefail

NPX=npx; POD=pod
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) NPX=npx.cmd; POD=pod.bat ;; esac

for tool in "$NPX" "$POD"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "$tool not found — install Node.js / CocoaPods (kxbuild doctor installs CocoaPods) and retry" >&2
    exit 1
  fi
done

echo "==> Creating React Native project $KXBUILD_PROJECT_NAME"
# The CLI takes the target as a path relative to its cwd and cannot init into
# the cwd itself (that collapses to "" → mkdir ''), so run it from the parent.
# The directory exists but is empty, which the CLI accepts without prompting.
(cd .. && "$NPX" --yes @react-native-community/cli@latest init "$KXBUILD_PROJECT_NAME" \
  --directory "$(basename "$KXBUILD_PROJECT_DIR")" \
  --package-name "$KXBUILD_BUNDLE_ID" \
  --skip-git-init --install-pods false --pm npm)

# The CLI's AppIcon.appiconset is just a Contents.json with no images, so the
# app would install with a blank icon. Use the same single-size 1024 icon as
# the native templates.
ICONSET="ios/$KXBUILD_PROJECT_NAME/Images.xcassets/AppIcon.appiconset"
if [ -d "$ICONSET" ] && ! ls "$ICONSET"/*.png >/dev/null 2>&1; then
  echo "==> Adding the default app icon"
  cp "$KXBUILD_TEMPLATE_DIR/template.files/AppIcon.png" "$ICONSET/AppIcon.png"
  cat > "$ICONSET/Contents.json" <<'EOF'
{
  "images" : [
    {
      "filename" : "AppIcon.png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
fi

echo "==> kxbuild doctor (React Native patches)"
if ! "$KXBUILD_BIN" doctor .; then
  echo "warning: kxbuild doctor failed — run 'kxbuild doctor .' again before building the iOS app" >&2
fi

echo "==> pod install"
(cd ios && "$POD" install)

# AGENTS.md: how an AI coding agent builds, runs and inspects this project with kxbuild.
sed -e "s/__NAME__/$KXBUILD_PROJECT_NAME/g" -e "s/__BUNDLE_ID__/$KXBUILD_BUNDLE_ID/g"   "$KXBUILD_TEMPLATE_DIR/template.files/AGENTS.md" > AGENTS.md

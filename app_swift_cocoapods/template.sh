#!/bin/bash
# Runs after the template is copied: install the pods so the .xcworkspace
# `kxbuild build` needs exists. cwd is the new project directory.
set -euo pipefail

POD=pod
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) POD=pod.bat ;; esac

if ! command -v "$POD" >/dev/null 2>&1; then
  echo "CocoaPods is not installed. Run 'kxbuild doctor' to install it, then run 'pod install' in $KXBUILD_PROJECT_DIR" >&2
  exit 1
fi

"$POD" install

# Working on __NAME__ with an AI coding agent

This iOS project is built with KXBuild on Windows, Linux and macOS. Use the kxbuild, kxdevice and kxstore commands below; they replace xcodebuild, Xcode and Transporter here. Every command accepts `--json`, which turns stdout into one JSON event per line.

## Project facts

- Name: `__NAME__` · bundle identifier: `__BUNDLE_ID__`
- Build container: `__NAME__.xcodeproj` (pass this path to every kxbuild command)
- Sources: `__NAME__/` (UIKit, Objective-C, Main.storyboard)

## Build, run, test

- Build: `kxbuild build __NAME__.xcodeproj --json --no-ipa`
- Build, install on the connected iPhone, launch, collect 10 s of its logs and take a screenshot: `kxbuild run __NAME__.xcodeproj --json --wait-logs 10s --screenshot build/run.png`
- Re-run the last build without compiling: add `--no-build`; end a running instance first: add `--kill-existing`
- Run the tests on the device: `kxbuild test __NAME__.xcodeproj --json`
- Package a Release .ipa for App Store Connect (an Apple Distribution .p12 and an App Store profile go in `keychain/`): `kxbuild build __NAME__.xcodeproj -c Release --export app-store --json`

## Publish to App Store Connect (only when the user asks)

- kxstore is KXBuild's App Store Connect command line (installed with KXBuild); every command accepts `--json` and `kxstore exit-codes` lists the exit codes. It signs in once with an App Store Connect API key: `kxstore login --api-key-file AuthKey_XXXX.json` (ask the user for the file; never read or print it yourself).
- Upload the Release .ipa: `kxstore build upload build/__NAME__.ipa --json` (bump CFBundleVersion first; a build number Apple already has is reported as a conflict). Add `--wait` when the next step needs the processed build.
- Store listing: `kxstore metadata export --dir metadata-bundle --json`, edit the text files per locale, `kxstore metadata import --json`; screenshots: `kxstore screenshot upload --locale en-US <folder> --json`.
- Whole pipeline (version, upload, metadata, screenshots, compliance, review): `kxstore init --bundle-id __BUNDLE_ID__ --name "__NAME__"` once, then `kxstore release --dry-run --json` to see the plan and `kxstore release --no-submit --json` to do everything except App Review; submit only when the user says so (`kxstore review submit --yes --json`).
- `capability_not_supported` means Apple's API cannot do that step (creating the App record, privacy labels, agreements): tell the user what to do in App Store Connect on the web, then rerun. `kxstore skill --install user` installs the full command reference as a skill file.

## Read the results

- Under `--json` the last `{"type":"result"}` line carries `data.success`. Compiler problems arrive as `{"type":"diagnostic"}` events with `file`, `line`, `col`, `severity` and `message`: fix them and build again.
- On failure read `data.failure.reason` and `data.failure.hint` (run), or the last `{"type":"log","level":"ERROR"}` event. The exit code names the class: 2 usage, 3 license, 4 no usable device, 5 build failed, 6 tests failed, 7 install or launch failed.
- A license refusal (reason starting with `license`): ask the user to run `kxbuild license activate <code>` or `kxbuild license trial`, then retry.

## Change the project

- Schemes, targets, bundle ids and the built executable path: `kxbuild project info __NAME__.xcodeproj --json`.
- Add a Swift package: `kxbuild project add-package`; register a file or asset catalog with a target: `kxbuild project add-resource`; add a target (widget, extension, framework): `kxbuild project add-target`; change build settings: `kxbuild project settings`. Run each with `--help` for its options. Do not edit `project.pbxproj` by hand.

## Device

- The iPhone is connected over USB and has trusted this computer; `kxdevice device list --json` shows it. Installing needs a development-signed build: the `.p12` certificate, its password file and the `.mobileprovision` profile go in a `keychain/` folder in the project.
- Logs of the running app: `kxdevice ostrace --pid <pid> --duration 10s --json` (the pid is in `kxbuild run`'s result). Screenshot: `kxdevice instruments screenshot -o shot.png --json`. View hierarchy: `kxdevice viewdebug capture --pid <pid> --json`. Crash reports: `kxdevice crash list`.

## MCP servers

kxbuild and kxdevice are also MCP servers; prefer them over shelling out when your client supports MCP (build, run, logs, screenshots, UI taps, breakpoints as tools).

- Claude Code: `claude mcp add kxbuild -- kxbuild mcp` and `claude mcp add kxdevice -- kxdevice mcp`
- Cursor, Windsurf, Codex and others: add `{"mcpServers":{"kxbuild":{"command":"kxbuild","args":["mcp"]},"kxdevice":{"command":"kxdevice","args":["mcp"]}}}` to the client's MCP configuration
- VS Code with the KXBuild extension registers both automatically

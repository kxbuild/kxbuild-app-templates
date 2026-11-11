# KXBuild App Templates

**English** · [简体中文](README_zh.md)

Project and target templates used by [KXBuild](https://github.com/kxbuild/kxbuild) when you create a new iOS app
(`kxbuild project create`, or **New Project** in the KXBuild VS Code plugin) or add a target to an existing
project (`kxbuild project add-target`).

Ideas for new templates, fixes and improvements are welcome: open an issue or send a pull request.

## Project templates

Create a project with `kxbuild project create -t <id> -n MyApp -b com.example.myapp`.
`kxbuild project templates` lists the templates installed on your machine.

| id | Template | What you get |
| --- | --- | --- |
| `app_swiftui` | iOS App (SwiftUI) | Single-view SwiftUI app: an `App` entry point and a `ContentView`, no storyboards. |
| `app_swift` | iOS App (Swift, UIKit) | Single-view UIKit app in Swift with a storyboard, scene delegate and asset catalog. |
| `app_objc` | iOS App (Objective-C, UIKit) | Single-view UIKit app in Objective-C with a storyboard and asset catalog. |
| `app_objc_swift` | iOS App (Objective-C + Swift) | Objective-C UIKit app that also compiles Swift, with a bridging header and the generated `-Swift.h` calling both ways. |
| `app_swift_cocoapods` | iOS App (Swift, CocoaPods) | The Swift UIKit app plus a Podfile; `pod install` runs on creation, then build the `.xcworkspace`. Needs CocoaPods. |
| `app_webview` | iOS App (WKWebView shell) | UIKit app whose whole UI is a WKWebView: bundled `www/` pages or a remote URL, progress bar, back gesture and a JS ↔ native message bridge. |
| `flutter_app` | Flutter App | Generated with `flutter create` (iOS + Android); the bundle identifier is applied to the Runner target. Needs the Flutter SDK. |
| `react_native_app` | React Native App | Generated with the React Native community CLI, prepared by `kxbuild doctor`, pods installed. Needs Node.js and CocoaPods. |
| `expo_app` | Expo App | Generated with `create-expo-app`; `kxbuild doctor` runs `expo prebuild` for iOS and the pods are installed. Needs Node.js and CocoaPods. |
| `framework_swift` | Framework (Swift) | Dynamic iOS framework with an umbrella header and a public sample class. |
| `lib_static_objc` | Static Library (Objective-C) | Static library `lib<Name>.a`; public headers are copied to `include/<Name>/`. |

## Target templates

Add a target with `kxbuild project add-target -P MyApp.xcodeproj --type <type> --name <Name>`.
`kxbuild project add-target --list` lists every type. Template directories are named `target_<type>[_<language>]`.

| Group | Type | What it does |
| --- | --- | --- |
| Frameworks & libraries | `framework` (swift / objc) | Dynamic framework, linked and embedded in the app. |
| | `static-library` (swift / objc) | Static library linked into the app. |
| | `bundle` | Resource bundle copied into the app, loaded with `Bundle(url:)`. |
| App Clip | `app-clip` | SwiftUI App Clip embedded in the app, bundle ID `<app>.Clip`. |
| Widgets & notifications | `widget` | WidgetKit extension with one static widget. |
| | `widget-live-activity` | Static widget plus a Live Activity (Lock Screen and Dynamic Island). |
| | `notification-service` | Modifies remote notifications before they are shown, e.g. downloads an image attachment. |
| | `notification-content` | Custom interface for expanded notifications of one category. |
| Sharing & actions | `share` | Share extension for text, a URL or an image. |
| | `action` | Action in the share sheet that views or edits text or an image in place. |
| | `imessage` | App in the Messages drawer that composes interactive messages. |
| | `photo-editing` | Your own edits inside the Photos app. |
| | `quicklook-preview` | Previews your file types in Quick Look. |
| | `thumbnail` | Draws thumbnails for your file types. |
| System integration | `app-intents` | Runs App Intents for Shortcuts, Siri and Spotlight outside the app process. |
| | `keyboard` | System-wide custom keyboard. |
| | `broadcast-upload` | Receives ReplayKit screen broadcast buffers and uploads them. |
| | `broadcast-setup-ui` | Lets the user name and start a ReplayKit broadcast. |
| | `file-provider` | Shows your cloud storage in the Files app. |
| | `credential-provider` | Offers your app's passwords in system AutoFill. |
| | `call-directory` | Blocks or labels incoming phone numbers. |
| | `message-filter` | Sorts SMS/MMS from unknown senders. |
| | `network-extension` | Packet tunnel provider for a custom VPN protocol. |
| | `background-download` | Background Assets: the system downloads your asset packs in the background. |
| Safari | `safari-web-extension` | Safari web extension (manifest v3) with a native message handler. |
| | `content-blocker` | Gives Safari a JSON list of content-blocking rules. |
| Screen Time | `device-activity-monitor` | Runs your code when a monitored schedule starts/ends or a threshold is reached. |
| | `shield-configuration` | Customizes the shield shown over restricted apps and websites. |
| | `shield-action` | Decides what the buttons on a shield do. |

## Use your own templates

Templates are read from the `resources/templates/` folder of your KXBuild installation
(`$KXBUILD_HOME/resources/templates/`). To add your own:

1. Copy an existing template that is close to what you want, e.g. `app_swift`, to a new folder with a unique id,
   e.g. `resources/templates/my_app/`. Use an id of your own so that KXBuild updates never overwrite it.
2. Edit `template.json` (name, description, order) and the files.
3. Run `kxbuild project templates` — your template shows up in the list and in the plugin's **New Project** picker.
4. Try it: `kxbuild project create -t my_app -n Demo -o <dir>`, then `kxbuild build <dir>/Demo/Demo.xcodeproj`.

To share it with everyone, send it as a pull request to this repository.

### Layout

Each sub-directory is one template; **the directory name is the template id**.

```
app_swift/
  template.json            metadata (not copied into the project)
  template.sh              optional: runs in the new project after copying (not copied)
  template.files/          optional: extra files used by template.sh (not copied)
  .gitignore               copied into the project
  __NAME__.xcodeproj/      placeholders in paths are replaced too
  __NAME__/
    AppDelegate.swift …
```

A template can consist of `template.json` + `template.sh` only, and generate the whole project in the script
(that is how `flutter_app`, `react_native_app` and `expo_app` work).

### template.json

```jsonc
{
  "name":        { "en": "iOS App (Swift, UIKit)", "zh": "iOS 应用（Swift · UIKit）" },
  "description": { "en": "…", "zh": "…" },
  "category": "app",          // app | library | hybrid | target
  "language": "swift",        // swift | objc | mixed | dart | javascript
  "ui": "uikit",              // uikit | swiftui | webview
  "order": 10,                // position in the list
  "requires": ["cocoapods"]   // optional: tools template.sh needs, shown when the template is picked
}
```

Target templates (`"category": "target"`) also have:

| Key | Meaning |
| --- | --- |
| `type` | Value of `--type`. One template per language when a type has several (`target_framework_swift` / `target_framework_objc`). |
| `kind` | `app-extension` (PlugIns/), `extensionkit` (Extensions/), `app-clip` (AppClips/), `framework`, `static-library`, `bundle`. |
| `productType` | Overrides the default product type of the kind (e.g. `com.apple.product-type.app-extension.messages`). |
| `extensionPoint` | `NSExtensionPointIdentifier` / extension point of the extension. |
| `minimumDeployment` | Minimum iOS version (the higher of this and the host's is used). |
| `frameworks` | System frameworks to link. |
| `settings` | Extra build settings. |
| `publicHeaders` | Public headers (framework Headers phase; static libraries copy them to `include/<Name>/`). |
| `folderReferences` | Sub-folders of `__NAME__/` copied into the product with their structure. |
| `entitlements` / `hostEntitlements` | Entitlements of the new target / merged into the host app. Placeholders allowed. |
| `hostInfoPlist` | Keys written into the host app's Info.plist (e.g. `NSSupportsLiveActivities`). |
| `capabilities` | Capabilities to enable for the App ID in the Apple Developer portal (shown to the user). |
| `requiresAppGroup` | The target needs an App Group; `group.<host bundle ID>` is used when `--app-group` is not given. |

Target templates contain only the sources, resources and `Info.plist` under `__NAME__/` (no `.xcodeproj`);
KXBuild creates the target and wires it into the host app.

### Placeholders

Replaced in text file contents and in file and directory names:

| Placeholder | Value |
| --- | --- |
| `__NAME__` | Project or target name (`^[A-Za-z][A-Za-z0-9_]*$`) |
| `__BUNDLE_ID__` | Bundle identifier, letters, digits and dots only; default `com.example.<name>` |
| `__DATE__` | Creation date `yyyy/MM/dd` (for file header comments) |
| `__HOST_BUNDLE_ID__` | Target templates: bundle ID of the host app |
| `__APP_GROUP__` | Target templates: App Group, empty when there is none |

### template.sh

Runs with bash after the files are copied, in the new project directory, with no stdin (interactive prompts fail
instead of hanging). Environment variables:

| Variable | Value |
| --- | --- |
| `KXBUILD_PROJECT_NAME` | Project name |
| `KXBUILD_BUNDLE_ID` | Bundle identifier |
| `KXBUILD_PROJECT_DIR` | Absolute path of the project directory (= `$PWD`) |
| `KXBUILD_TEMPLATE_ID` / `KXBUILD_TEMPLATE_DIR` | Template id / template directory (extra files go in `template.files/`) |
| `KXBUILD_HOME` / `KXBUILD_BIN` | KXBuild installation directory / the kxbuild executable (`"$KXBUILD_BIN" doctor .`) |

A non-zero exit code makes `project create` fail; the project directory is kept so the failed step can be rerun
by hand. `--no-script` copies the template without running the script.
On Windows, call native tools by their `.bat` / `.cmd` names (`pod.bat`, `npx.cmd`, `flutter.bat`) — see the
`case "$(uname -s)"` at the top of the existing scripts.

### Before you send a template

Leave out signing material: no `.p12` / `.mobileprovision` files and no `DEVELOPMENT_TEAM` / `PROVISIONING_PROFILE_SPECIFIER` in the project.

Check the template: `kxbuild project create -t <id> -n Demo -o <dir>`, then build the project.
On Windows, use a short output path (e.g. `C:\x`) for React Native and Expo — their Pods tree is deep.

## Related repositories

- [**KXBuild**](https://github.com/kxbuild/kxbuild): build, run and publish iOS apps from Windows, Linux or macOS, on the command line or in VS Code
- [SwiftUI Gallery](https://github.com/kxbuild/swift-gallery): 15 SwiftUI demos: controls, lists, animation, gestures, Swift Charts, MapKit, SwiftData
- [UIKit Gallery (Objective-C)](https://github.com/kxbuild/objc-gallery): 14 UIKit demos in Objective-C, every view built in code
- [Flutter Gallery](https://github.com/kxbuild/flutter-gallery): Material and Cupertino widgets plus four complete sample apps
- [React Native Gallery](https://github.com/kxbuild/react-native-gallery): 16 demos of React Native's built-in components and APIs
- [Expo Gallery](https://github.com/kxbuild/expo-gallery): 22 Expo SDK modules: camera, sensors, location, SQLite and more
- [Godot Gallery](https://github.com/kxbuild/godot-gallery): 10 Godot 4 demos exported to iOS
- [Unity Gallery](https://github.com/kxbuild/unity-gallery): 10 Unity 6 demos exported to iOS

## License

[Apache License 2.0](LICENSE)

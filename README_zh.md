# KXBuild 应用模板

[English](README.md) · **简体中文**

[KXBuild](https://github.com/kxbuild/kxbuild) 新建 iOS 项目（`kxbuild project create`，或 KXBuild VS Code 插件里的「新建项目」）
和给已有项目添加 target（`kxbuild project add-target`）时使用的模板。

欢迎提建议、提新模板、改进现有模板：直接提 Issue 或 Pull Request。

## 项目模板

新建项目：`kxbuild project create -t <id> -n MyApp -b com.example.myapp`。
`kxbuild project templates` 列出本机已安装的模板。

| id | 模板 | 生成内容 |
| --- | --- | --- |
| `app_swiftui` | iOS 应用（SwiftUI） | 单页 SwiftUI 应用：`App` 入口 + `ContentView`，不用 Storyboard。 |
| `app_swift` | iOS 应用（Swift · UIKit） | Swift 编写的单页 UIKit 应用：Storyboard、SceneDelegate、资源目录。 |
| `app_objc` | iOS 应用（Objective-C · UIKit） | Objective-C 编写的单页 UIKit 应用：Storyboard、资源目录。 |
| `app_objc_swift` | iOS 应用（Objective-C + Swift 混编） | Objective-C UIKit 应用并编译 Swift：桥接头文件 + 生成的 `-Swift.h`，双向调用示例。 |
| `app_swift_cocoapods` | iOS 应用（Swift · CocoaPods） | Swift UIKit 应用加 Podfile，创建时自动 `pod install`，之后编译 `.xcworkspace`。需要 CocoaPods。 |
| `app_webview` | iOS 应用（WKWebView 套壳 / H5） | 整个界面是一个 WKWebView：加载打包的 `www/` 页面或远程 URL，带进度条、返回手势和 JS ↔ 原生消息桥。 |
| `flutter_app` | Flutter 应用 | 用 `flutter create` 生成（iOS + Android），Bundle Identifier 写入 Runner target。需要 Flutter SDK。 |
| `react_native_app` | React Native 应用 | 用 React Native 社区 CLI 生成，`kxbuild doctor` 处理后安装 pods。需要 Node.js 和 CocoaPods。 |
| `expo_app` | Expo 应用 | 用 `create-expo-app` 生成，`kxbuild doctor` 执行 iOS 的 `expo prebuild` 并安装 pods。需要 Node.js 和 CocoaPods。 |
| `framework_swift` | Framework（Swift 动态库） | iOS 动态 Framework：伞头文件 + 一个 public 示例类。 |
| `lib_static_objc` | 静态库（Objective-C） | 静态库 `lib<Name>.a`，公开头文件复制到 `include/<Name>/`。 |

## Target 模板

添加 target：`kxbuild project add-target -P MyApp.xcodeproj --type <类型> --name <名称>`。
`kxbuild project add-target --list` 列出全部类型。模板目录命名为 `target_<类型>[_<语言>]`。

| 分组 | 类型 | 作用 |
| --- | --- | --- |
| 框架与库 | `framework`（swift / objc） | 动态框架，链接并嵌入 App。 |
| | `static-library`（swift / objc） | 静态库，链接进 App。 |
| | `bundle` | 资源包，复制进 App，用 `Bundle(url:)` 读取。 |
| App Clip | `app-clip` | SwiftUI App Clip，嵌入 App，Bundle ID 为 `<App>.Clip`。 |
| 小组件与通知 | `widget` | WidgetKit 扩展，含一个静态小组件。 |
| | `widget-live-activity` | 静态小组件 + 实时活动（锁屏与灵动岛）。 |
| | `notification-service` | 推送显示前修改内容，例如下载图片附件。 |
| | `notification-content` | 某一类通知展开后的自定义界面。 |
| 分享与动作 | `share` | 分享扩展，接收文本、网址或图片。 |
| | `action` | 分享面板里的动作，就地查看或编辑文本、图片。 |
| | `imessage` | 「信息」App 抽屉里的小程序，编写可交互消息。 |
| | `photo-editing` | 在「照片」App 里用你的扩展编辑照片。 |
| | `quicklook-preview` | 在快速查看里预览你的文件类型。 |
| | `thumbnail` | 为你的文件类型绘制缩略图。 |
| 系统集成 | `app-intents` | 在 App 进程之外为快捷指令、Siri、聚焦搜索执行 App Intent。 |
| | `keyboard` | 全局自定义键盘。 |
| | `broadcast-upload` | 接收 ReplayKit 屏幕直播的音视频数据并上传。 |
| | `broadcast-setup-ui` | 直播开始前让用户填写名称并开始直播。 |
| | `file-provider` | 把你的云存储显示在「文件」App 里。 |
| | `credential-provider` | 在系统自动填充里提供你的 App 保存的密码。 |
| | `call-directory` | 来电拦截或显示来电标签。 |
| | `message-filter` | 把陌生号码的短信/彩信分到垃圾、推广或交易信息。 |
| | `network-extension` | 自定义 VPN 协议的数据包隧道。 |
| | `background-download` | Background Assets：系统在后台下载你的资源包。 |
| Safari | `safari-web-extension` | Safari 网页扩展（manifest v3），带原生消息处理。 |
| | `content-blocker` | 给 Safari 提供拦截网页内容的 JSON 规则。 |
| 屏幕使用时间 | `device-activity-monitor` | 监控时段开始/结束或用量达到阈值时运行你的代码。 |
| | `shield-configuration` | 自定义受限 App 和网站上显示的屏蔽界面。 |
| | `shield-action` | 决定屏蔽界面上按钮的行为。 |

## 使用自己的模板

模板从 KXBuild 安装目录下的 `resources/templates/`（`$KXBUILD_HOME/resources/templates/`）读取。添加自己的模板：

1. 复制一个最接近的现有模板（如 `app_swift`）到新目录，起一个独有的 id，例如 `resources/templates/my_app/`。
   用自己的 id，KXBuild 更新时就不会覆盖它。
2. 修改 `template.json`（名称、说明、排序）和模板文件。
3. 运行 `kxbuild project templates`，新模板会出现在列表和插件的「新建项目」里。
4. 试用：`kxbuild project create -t my_app -n Demo -o <目录>`，再 `kxbuild build <目录>/Demo/Demo.xcodeproj`。

想让所有人都能用，就把它作为 Pull Request 提交到本仓库。

### 目录结构

每个子目录是一个模板，**目录名就是模板 id**。

```
app_swift/
  template.json            元数据（不会拷进项目）
  template.sh              可选：拷贝完成后在新项目里执行（不会拷进项目）
  template.files/          可选：template.sh 要用的附加文件（不会拷进项目）
  .gitignore               随项目一起生成
  __NAME__.xcodeproj/      路径里的占位符同样会被替换
  __NAME__/
    AppDelegate.swift …
```

模板可以只有 `template.json` + `template.sh`，整个项目由脚本生成（`flutter_app`、`react_native_app`、`expo_app` 就是这样）。

### template.json

```jsonc
{
  "name":        { "en": "iOS App (Swift, UIKit)", "zh": "iOS 应用（Swift · UIKit）" },
  "description": { "en": "…", "zh": "…" },
  "category": "app",          // app | library | hybrid | target
  "language": "swift",        // swift | objc | mixed | dart | javascript
  "ui": "uikit",              // uikit | swiftui | webview
  "order": 10,                // 列表排序
  "requires": ["cocoapods"]   // 可选：template.sh 依赖的外部工具，选模板时提示
}
```

Target 模板（`"category": "target"`）另有：

| 字段 | 含义 |
| --- | --- |
| `type` | `--type` 的值；同一类型有多种语言时各一个模板（`target_framework_swift` / `target_framework_objc`）。 |
| `kind` | `app-extension`（PlugIns/）、`extensionkit`（Extensions/）、`app-clip`（AppClips/）、`framework`、`static-library`、`bundle`。 |
| `productType` | 覆盖该种类默认的产品类型（如 `com.apple.product-type.app-extension.messages`）。 |
| `extensionPoint` | 扩展点标识。 |
| `minimumDeployment` | 最低 iOS 版本（与宿主取较高者）。 |
| `frameworks` | 需要链接的系统框架。 |
| `settings` | 附加构建设置。 |
| `publicHeaders` | 公开头文件（框架放进 Headers 阶段；静态库复制到 `include/<Name>/`）。 |
| `folderReferences` | `__NAME__/` 下按目录结构整体拷进产品的子目录。 |
| `entitlements` / `hostEntitlements` | 新 target 的 entitlements / 要合并到宿主 App 的 entitlements，可用占位符。 |
| `hostInfoPlist` | 写入宿主 App Info.plist 的键值（如 `NSSupportsLiveActivities`）。 |
| `capabilities` | 需要在 Apple 开发者后台为 App ID 打开的能力（会提示用户）。 |
| `requiresAppGroup` | 需要 App Group；未指定 `--app-group` 时使用 `group.<宿主 Bundle ID>`。 |

Target 模板只包含 `__NAME__/` 下的源码、资源和 `Info.plist`，不带 `.xcodeproj`；target 本身和与宿主 App 的关联由 KXBuild 创建。

### 占位符

在文本文件内容和文件、目录名里都会替换：

| 占位符 | 值 |
| --- | --- |
| `__NAME__` | 项目或 target 名称（`^[A-Za-z][A-Za-z0-9_]*$`） |
| `__BUNDLE_ID__` | Bundle Identifier，只能用字母、数字和点；默认 `com.example.<name>` |
| `__DATE__` | 创建日期 `yyyy/MM/dd`（用于文件头注释） |
| `__HOST_BUNDLE_ID__` | Target 模板：宿主 App 的 Bundle ID |
| `__APP_GROUP__` | Target 模板：App Group，没有时为空串 |

### template.sh

文件拷贝完成后用 bash 执行，工作目录是新项目目录，stdin 关闭（遇到交互提示会直接失败，不会卡住）。环境变量：

| 变量 | 值 |
| --- | --- |
| `KXBUILD_PROJECT_NAME` | 项目名 |
| `KXBUILD_BUNDLE_ID` | Bundle Identifier |
| `KXBUILD_PROJECT_DIR` | 项目目录绝对路径（= `$PWD`） |
| `KXBUILD_TEMPLATE_ID` / `KXBUILD_TEMPLATE_DIR` | 模板 id / 模板目录（附加文件放 `template.files/`） |
| `KXBUILD_HOME` / `KXBUILD_BIN` | KXBuild 安装目录 / kxbuild 可执行文件（`"$KXBUILD_BIN" doctor .`） |

脚本退出码非 0 时 `project create` 失败，项目目录保留，可以进去手动重跑失败的那一步。`--no-script` 只拷贝不执行脚本。
Windows 上调用原生工具请用 `.bat` / `.cmd` 名字（`pod.bat`、`npx.cmd`、`flutter.bat`），参考现有脚本开头的 `case "$(uname -s)"`。

### 模板规则

- 不带任何签名材料（`.p12`、`.mobileprovision`），工程里不写 `DEVELOPMENT_TEAM` / `PROVISIONING_PROFILE_SPECIFIER`。
- 不带 `xcuserdata/`、`compile_commands.json` 和构建产物。
- `IPHONEOS_DEPLOYMENT_TARGET = 15.0`、`MARKETING_VERSION = 1.0`、`objectVersion = 56`。
- Storyboard 只用基础元素：label、button、switch、imageView、约束、outlet、action（不用 stackView 和 segue）。Target 模板的界面用代码构建。
- `AccentColor` 要有具体颜色值。
- 不用 `#Preview` 等依赖 Xcode 宏插件的写法，保证模板在 Windows、Linux、macOS 上都能编译。
- 不用 Storyboard 的 App 设置 `INFOPLIST_KEY_UILaunchScreen_Generation = YES`（SwiftUI 应用再加 `INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES`）。

提交前请先验证：`kxbuild project create -t <id> -n Demo -o <目录>`，再编译生成的项目。
Windows 上 React Native 和 Expo 请用短路径（如 `C:\x`），它们的 Pods 目录层级很深。

## 许可证

[Apache License 2.0](LICENSE)

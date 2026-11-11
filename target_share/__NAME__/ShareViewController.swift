//
//  ShareViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit
import Social
import UniformTypeIdentifiers

/// App Group shared with the host app. Empty when the extension was added without one:
/// shared items then stay in the extension's own defaults, which the app cannot read.
let appGroup = "__APP_GROUP__"

var sharedDefaults: UserDefaults {
    appGroup.isEmpty ? .standard : (UserDefaults(suiteName: appGroup) ?? .standard)
}

/// The system compose sheet (text field + Post / Cancel), no storyboard needed.
/// Which content activates the extension is set in Info.plist (NSExtensionActivationRule).
class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        true
    }

    override func didSelectPost() {
        sharedDefaults.set(contentText, forKey: "sharedText")

        // Look for a shared web URL and keep it next to the text.
        let providers = (extensionContext?.inputItems as? [NSExtensionItem] ?? []).flatMap { $0.attachments ?? [] }
        guard let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.url.identifier) }) else {
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { item, _ in
            if let url = item as? URL {
                sharedDefaults.set(url.absoluteString, forKey: "sharedURL")
            }
            DispatchQueue.main.async {
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }

    override func configurationItems() -> [Any]! {
        []
    }
}

//
//  SafariWebExtensionHandler.swift
//  __NAME__
//
//  Created on __DATE__.
//

import SafariServices
import os.log

/// Native side of the web extension in Resources/: answers browser.runtime.sendNativeMessage
/// calls from the extension's JavaScript. Users turn the extension on in Settings > Apps > Safari > Extensions.
class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let profile: UUID?
        if #available(iOS 17.0, *) {
            profile = request?.userInfo?[SFExtensionProfileKey] as? UUID
        } else {
            profile = request?.userInfo?["profile"] as? UUID
        }

        let message = request?.userInfo?[SFExtensionMessageKey]

        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@ (profile: %@)", String(describing: message), profile?.uuidString ?? "none")

        let response = NSExtensionItem()
        response.userInfo = [SFExtensionMessageKey: ["echo": message as Any]]

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}

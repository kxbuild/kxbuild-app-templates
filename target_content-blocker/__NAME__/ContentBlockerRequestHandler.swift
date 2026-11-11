//
//  ContentBlockerRequestHandler.swift
//  __NAME__
//
//  Created on __DATE__.
//

import Foundation

/// Hands Safari the rules in blockerList.json. Users turn the blocker on in
/// Settings > Apps > Safari > Extensions; after the app changes the rules it calls
/// SFContentBlockerManager.reloadContentBlocker(withIdentifier: "__BUNDLE_ID__").
class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!

        let item = NSExtensionItem()
        item.attachments = [attachment]

        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}

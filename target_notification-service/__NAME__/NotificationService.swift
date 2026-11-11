//
//  NotificationService.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UserNotifications

/// Runs for remote notifications whose payload has "mutable-content": 1. If the payload also
/// carries "attachment-url", the file is downloaded and attached (images show as a thumbnail).
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        guard let content = request.content.mutableCopy() as? UNMutableNotificationContent else {
            contentHandler(request.content)
            return
        }
        bestAttemptContent = content

        guard let link = content.userInfo["attachment-url"] as? String, let url = URL(string: link) else {
            contentHandler(content)
            return
        }
        URLSession.shared.downloadTask(with: url) { location, _, _ in
            if let location {
                let file = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension(url.pathExtension)
                if (try? FileManager.default.moveItem(at: location, to: file)) != nil,
                   let attachment = try? UNNotificationAttachment(identifier: "attachment", url: file) {
                    content.attachments = [attachment]
                }
            }
            contentHandler(content)
        }.resume()
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the system kills the extension: deliver what we have.
        if let contentHandler, let bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

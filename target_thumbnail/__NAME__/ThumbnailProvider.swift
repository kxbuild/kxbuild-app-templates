//
//  ThumbnailProvider.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit
import QuickLookThumbnailing

/// Asked for thumbnails of files whose type is listed under NSExtensionAttributes /
/// QLSupportedContentTypes in Info.plist (empty in the template: add the UTIs your app declares).
class ThumbnailProvider: QLThumbnailProvider {

    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {
        let name = request.fileURL.deletingPathExtension().lastPathComponent

        // There are three ways to provide a thumbnail through a QLThumbnailReply. Only one of them should be used.

        // First way: Draw the thumbnail into the current context, set up with UIKit's coordinate system.
        handler(QLThumbnailReply(contextSize: request.maximumSize, currentContextDrawing: { () -> Bool in
            let bounds = CGRect(origin: .zero, size: request.maximumSize)
            UIColor.systemBlue.setFill()
            UIRectFill(bounds)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: bounds.height / 6),
                .foregroundColor: UIColor.white,
            ]
            (name as NSString).draw(in: bounds.insetBy(dx: bounds.width / 10, dy: bounds.height / 3), withAttributes: attributes)
            // Return true if the thumbnail was successfully drawn inside this block.
            return true
        }), nil)

        /*
        // Second way: Draw the thumbnail into a context passed to your block, set up with Core Graphics's coordinate system.
        handler(QLThumbnailReply(contextSize: request.maximumSize, drawing: { context -> Bool in
            // Draw the thumbnail here.
            return true
        }), nil)

        // Third way: Set an image file URL.
        handler(QLThumbnailReply(imageFileURL: Bundle.main.url(forResource: "fileThumbnail", withExtension: "jpg")!), nil)
        */
    }
}

//
//  PreviewViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit
import QuickLook

/// Quick Look shows this view for files whose type is listed under
/// NSExtensionAttributes / QLSupportedContentTypes in Info.plist (empty in the template:
/// add the UTIs your app declares, e.g. "com.example.myformat"). Built in code, no storyboard.
class PreviewViewController: UIViewController, QLPreviewingController {

    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        textView.isEditable = false
        textView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    /*
    func preparePreviewOfSearchableItem(identifier: String, queryString: String?) async throws {
        // Implement this method and set QLSupportsSearchableItems to YES in the Info.plist of the extension if you support CoreSpotlight.

        // Perform any setup necessary in order to prepare the view.
        // Quick Look will display a loading spinner until this returns.
    }
    */

    func preparePreviewOfFile(at url: URL) async throws {
        // Quick Look shows a loading spinner until this returns. Replace with rendering of your format.
        let data = try Data(contentsOf: url)
        textView.text = String(decoding: data.prefix(64 * 1024), as: UTF8.self)
    }
}

//
//  ActionViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit
import UniformTypeIdentifiers

/// App Group shared with the host app. Empty when the extension was added without one.
let appGroup = "__APP_GROUP__"

var sharedDefaults: UserDefaults {
    appGroup.isEmpty ? .standard : (UserDefaults(suiteName: appGroup) ?? .standard)
}

/// Shows the image or text the user ran the action on; built in code, no storyboard.
/// Which content activates the action is set in Info.plist (NSExtensionActivationRule).
class ActionViewController: UIViewController {

    private let imageView = UIImageView()
    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let bar = UINavigationBar()
        let item = UINavigationItem(title: "__NAME__")
        item.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        bar.items = [item]

        imageView.contentMode = .scaleAspectFit
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isEditable = false

        for v in [bar, imageView, textView] as [UIView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        NSLayoutConstraint.activate([
            bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: bar.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.topAnchor.constraint(equalTo: bar.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        loadInput()
    }

    private func loadInput() {
        let providers = (extensionContext?.inputItems as? [NSExtensionItem] ?? []).flatMap { $0.attachments ?? [] }
        if let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.image.identifier) }) {
            provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, _ in
                var image: UIImage?
                if let url = item as? URL, let data = try? Data(contentsOf: url) {
                    image = UIImage(data: data)
                } else if let data = item as? Data {
                    image = UIImage(data: data)
                } else {
                    image = item as? UIImage
                }
                DispatchQueue.main.async { self.imageView.image = image }
            }
        } else if let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) }) {
            provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { item, _ in
                let text = item as? String
                DispatchQueue.main.async { self.textView.text = text }
            }
        }
    }

    @objc private func done() {
        sharedDefaults.set(Date(), forKey: "lastAction")
        // Return the (unchanged) items to the host; an editor action would return modified ones.
        extensionContext?.completeRequest(returningItems: extensionContext?.inputItems, completionHandler: nil)
    }
}

//
//  BroadcastSetupViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import ReplayKit
import UIKit

/// Shown by ReplayKit before a broadcast starts; built in code, no storyboard.
/// The setup info returned here reaches the upload extension's broadcastStarted(withSetupInfo:).
class BroadcastSetupViewController: UIViewController {

    private let nameField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        nameField.placeholder = "Broadcast name"
        nameField.borderStyle = .roundedRect
        nameField.text = "example"

        let startButton = UIButton(type: .system)
        startButton.setTitle("Start Broadcast", for: [])
        startButton.addTarget(self, action: #selector(userDidFinishSetup), for: .touchUpInside)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: [])
        cancelButton.addTarget(self, action: #selector(userDidCancelSetup), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nameField, startButton, cancelButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    /// The user has finished setting up and the broadcast stream can start.
    @objc func userDidFinishSetup() {
        // URL where the broadcast can be viewed, returned to the application.
        let broadcastURL = URL(string: "https://example.com/broadcast/streamID")!

        // Handed to the upload extension when the broadcast starts.
        let setupInfo: [String: NSCoding & NSObjectProtocol] = ["broadcastName": (nameField.text ?? "") as NSString]

        // Tell ReplayKit that the extension is finished setting up and can begin broadcasting.
        extensionContext?.completeRequest(withBroadcast: broadcastURL, setupInfo: setupInfo)
    }

    @objc func userDidCancelSetup() {
        let error = NSError(domain: "__BUNDLE_ID__", code: -1, userInfo: nil)
        // Tell ReplayKit that the extension was cancelled by the user.
        extensionContext?.cancelRequest(withError: error)
    }
}

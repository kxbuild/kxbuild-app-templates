//
//  KeyboardViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit

/// The keyboard's input view, built in code (no storyboard). Users enable it under
/// Settings > General > Keyboard > Keyboards; RequestsOpenAccess in Info.plist controls
/// whether it may reach the network or the App Group ("Allow Full Access").
class KeyboardViewController: UIInputViewController {

    private let nextKeyboardButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        // "Next Keyboard" (globe) key: required whenever needsInputModeSwitchKey is true.
        nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

        let helloKey = makeKey(title: "Hello", action: #selector(insertHello))
        let deleteKey = makeKey(title: "⌫", action: #selector(deleteBackward))

        let row = UIStackView(arrangedSubviews: [nextKeyboardButton, helloKey, deleteKey])
        row.distribution = .fillEqually
        row.spacing = 6
        row.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(row)
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            row.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            row.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            row.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    override func viewWillLayoutSubviews() {
        nextKeyboardButton.isHidden = !needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }

    override func textDidChange(_ textInput: UITextInput?) {
        // The document context has been updated; follow the host's keyboard appearance.
        let color: UIColor = textDocumentProxy.keyboardAppearance == .dark ? .white : .black
        nextKeyboardButton.setTitleColor(color, for: [])
    }

    private func makeKey(title: String, action: Selector) -> UIButton {
        let key = UIButton(type: .system)
        key.setTitle(title, for: [])
        key.backgroundColor = .secondarySystemBackground
        key.layer.cornerRadius = 6
        key.addTarget(self, action: action, for: .touchUpInside)
        return key
    }

    @objc private func insertHello() {
        textDocumentProxy.insertText("Hello")
    }

    @objc private func deleteBackward() {
        textDocumentProxy.deleteBackward()
    }
}

//
//  CredentialProviderViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit
import AuthenticationServices

/// Shown when the user picks this app in the AutoFill password list. The user must first enable
/// it in Settings > General > AutoFill & Passwords. The UI is built in code (no storyboard).
class CredentialProviderViewController: ASCredentialProviderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let navigationBar = UINavigationBar()
        let item = UINavigationItem(title: "Passwords")
        item.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction { [weak self] _ in
            self?.cancel()
        })
        navigationBar.items = [item]

        let passwordButton = UIButton(type: .system, primaryAction: UIAction(title: "Return Example Password") { [weak self] _ in
            self?.passwordSelected()
        })

        for subview in [navigationBar, passwordButton] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            passwordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    /*
     Prepare your UI to list available credentials for the user to choose from. The items in
     'serviceIdentifiers' describe the service the user is logging in to, so your extension can
     prioritize the most relevant credentials in the list.
    */
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    }

    /*
     Implement this method if your extension supports showing credentials in the QuickType bar.
     When the user selects a credential from your app, this method will be called with the
     ASPasswordCredentialIdentity your app has previously saved to the ASCredentialIdentityStore.
     Provide the password by completing the extension request with the associated ASPasswordCredential.
     If using the credential would require showing custom UI for authenticating the user, cancel
     the request with error code ASExtensionError.userInteractionRequired.

    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        let databaseIsUnlocked = true
        if databaseIsUnlocked {
            let passwordCredential = ASPasswordCredential(user: "j_appleseed", password: "apple1234")
            extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
        } else {
            extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userInteractionRequired.rawValue))
        }
    }
    */

    /*
     Implement this method if provideCredentialWithoutUserInteraction(for:) can fail with
     ASExtensionError.userInteractionRequired. In this case, the system may present your extension's
     UI and call this method. Show appropriate UI for authenticating the user then provide the password
     by completing the extension request with the associated ASPasswordCredential.

    override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
    }
    */

    private func cancel() {
        extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
    }

    private func passwordSelected() {
        let passwordCredential = ASPasswordCredential(user: "j_appleseed", password: "apple1234")
        extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
    }
}

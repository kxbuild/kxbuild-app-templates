//
//  WebViewController.swift
//  __NAME__
//
//  Created on __DATE__.
//

import UIKit
import WebKit

/// Hosts the web app. Loads `www/index.html` from the bundle by default; set
/// `startURL` to load a remote site instead (http is allowed for web content
/// by the NSAppTransportSecurity entry in Info.plist).
///
/// JS → native: `window.webkit.messageHandlers.native.postMessage({ action: "...", ... })`
/// native → JS: `callJS("onNativeMessage", payload)` (see www/app.js).
class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {

    /// Remote start page, or nil for the bundled www/index.html.
    let startURL: URL? = nil

    private static let bridgeName = "native"
    private var webView: WKWebView!
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private var progressObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let contentController = WKUserContentController()
        // The content controller retains its handlers; go through a weak proxy so this
        // controller can still be deallocated (and deinit can unregister the handler).
        contentController.add(WeakScriptMessageHandler(self), name: Self.bridgeName)
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            guard let self else { return }
            self.progressView.progress = Float(webView.estimatedProgress)
            self.progressView.isHidden = webView.estimatedProgress >= 1
        }

        loadStartPage()
    }

    deinit {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: Self.bridgeName)
    }

    private func loadStartPage() {
        if let url = startURL {
            webView.load(URLRequest(url: url))
            return
        }
        guard let index = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "www") else {
            webView.loadHTMLString("<h1>www/index.html not found in the bundle</h1>", baseURL: nil)
            return
        }
        // Grant read access to the whole www folder so relative assets resolve.
        webView.loadFileURL(index, allowingReadAccessTo: index.deletingLastPathComponent())
    }

    // MARK: - JS → native

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == Self.bridgeName, let body = message.body as? [String: Any] else { return }
        let action = body["action"] as? String ?? ""
        switch action {
        case "toast":
            showToast(body["text"] as? String ?? "")
        case "deviceInfo":
            let device = UIDevice.current
            callJS("onNativeMessage", ["action": "deviceInfo", "model": device.model, "system": "\(device.systemName) \(device.systemVersion)"])
        default:
            callJS("onNativeMessage", ["action": "error", "message": "unknown action: \(action)"])
        }
    }

    // MARK: - native → JS

    /// Calls `window.<function>(payload)` in the page.
    func callJS(_ function: String, _ payload: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: payload),
              let json = String(data: data, encoding: .utf8) else { return }
        webView.evaluateJavaScript("window.\(function) && window.\(function)(\(json))")
    }

    private func showToast(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { alert.dismiss(animated: true) }
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.loadHTMLString("<h2>Failed to load</h2><p>\(error.localizedDescription)</p>", baseURL: nil)
    }
}

/// Forwards script messages to a weakly held handler, breaking the
/// WKUserContentController → handler retain cycle.
private final class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private weak var target: WKScriptMessageHandler?

    init(_ target: WKScriptMessageHandler) {
        self.target = target
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        target?.userContentController(userContentController, didReceive: message)
    }
}

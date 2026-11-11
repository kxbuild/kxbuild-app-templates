//
//  __NAME__App.swift
//  __NAME__
//
//  Created on __DATE__.
//

import SwiftUI

@main
struct __NAME__App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                // The invocation URL (App Clip Code, NFC tag, Safari banner, link in Messages…)
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    guard let url = activity.webpageURL else { return }
                    print("App Clip launched with \(url)")
                }
        }
    }
}

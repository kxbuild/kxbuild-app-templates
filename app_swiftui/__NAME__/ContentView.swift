//
//  ContentView.swift
//  __NAME__
//
//  Created on __DATE__.
//

import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "hand.tap")
                .font(.system(size: 56))
                .foregroundStyle(.tint)
            Text(tapCount == 0 ? "Hello, __NAME__!" : "Tapped \(tapCount) time\(tapCount == 1 ? "" : "s")")
                .font(.title.bold())
            Button("Tap me") {
                tapCount += 1
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

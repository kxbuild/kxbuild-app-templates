//
//  ContentView.swift
//  __NAME__
//
//  Created on __DATE__.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 56))
                .foregroundStyle(.tint)
            Text("Hello from __NAME__!")
                .font(.title.bold())
            Text("Get the full app for everything else.")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

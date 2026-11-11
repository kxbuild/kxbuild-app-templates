//
//  __NAME__Intent.swift
//  __NAME__
//
//  Created on __DATE__.
//

import AppIntents

/// App Group shared with the host app. Empty when the extension was added without one.
let appGroup = "__APP_GROUP__"

var sharedDefaults: UserDefaults {
    appGroup.isEmpty ? .standard : (UserDefaults(suiteName: appGroup) ?? .standard)
}

/// An action that shows up in the Shortcuts app: saves a note and answers with a confirmation.
struct __NAME__Intent: AppIntent {
    static let title: LocalizedStringResource = "Save Note"
    static let description = IntentDescription("Saves a short note for the app.")

    @Parameter(title: "Note")
    var note: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        sharedDefaults.set(note, forKey: "lastNote")
        return .result(dialog: "Saved \"\(note)\".")
    }
}

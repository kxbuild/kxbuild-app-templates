//
//  __NAME__.swift
//  __NAME__
//
//  Created on __DATE__.
//

import WidgetKit
import SwiftUI

/// App Group shared with the host app. Empty when the extension was added without one:
/// the widget then reads its own defaults, which the app cannot write to.
let appGroup = "__APP_GROUP__"

var sharedDefaults: UserDefaults {
    appGroup.isEmpty ? .standard : (UserDefaults(suiteName: appGroup) ?? .standard)
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "Hello")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date(), text: currentText()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // One entry per hour for the next five hours; WidgetKit asks again after the last one.
        let now = Date()
        let text = currentText()
        let entries = (0..<5).map { offset in
            SimpleEntry(date: Calendar.current.date(byAdding: .hour, value: offset, to: now)!, text: text)
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }

    /// The app writes "widgetText" into the shared defaults and calls
    /// WidgetCenter.shared.reloadAllTimelines() to refresh the widget.
    private func currentText() -> String {
        sharedDefaults.string(forKey: "widgetText") ?? "Hello"
    }
}

struct __NAME__EntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.date, style: .time)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(entry.text)
                .font(.headline)
        }
    }
}

struct __NAME__: Widget {
    let kind: String = "__NAME__"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            __NAME__EntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("__NAME__")
        .description("Shows the latest text from the app.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct __NAME___Previews: PreviewProvider {
    static var previews: some View {
        __NAME__EntryView(entry: SimpleEntry(date: Date(), text: "Hello"))
            .containerBackground(.fill.tertiary, for: .widget)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

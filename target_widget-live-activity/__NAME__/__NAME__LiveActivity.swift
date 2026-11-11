//
//  __NAME__LiveActivity.swift
//  __NAME__
//
//  Created on __DATE__.
//

import ActivityKit
import WidgetKit
import SwiftUI

/// What the Live Activity shows. The app starts one with the same type, e.g.
///
///     let attributes = __NAME__Attributes(name: "Order #42")
///     let state = __NAME__Attributes.ContentState(status: "Preparing")
///     _ = try Activity.request(attributes: attributes, content: .init(state: state, staleDate: nil))
///
/// so copy this struct into the app target (or move it to a file both targets compile).
struct __NAME__Attributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic properties: change over the life of the activity.
        var status: String
    }

    // Fixed properties: set when the activity starts.
    var name: String
}

struct __NAME__LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: __NAME__Attributes.self) { context in
            // Lock Screen / banner presentation.
            VStack(alignment: .leading, spacing: 4) {
                Text(context.attributes.name)
                    .font(.headline)
                Text(context.state.status)
                    .font(.subheadline)
            }
            .padding()
            .activityBackgroundTint(Color.cyan.opacity(0.25))
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.attributes.name)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: "clock")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.status)
                }
            } compactLeading: {
                Image(systemName: "clock")
            } compactTrailing: {
                Text(context.state.status)
            } minimal: {
                Image(systemName: "clock")
            }
            .keylineTint(Color.cyan)
        }
    }
}

//
//  QuestWidgetLiveActivity.swift
//  QuestWidget
//
//  Created by Paing Thu Ta on 26/9/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct QuestWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct QuestWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: QuestWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension QuestWidgetAttributes {
    fileprivate static var preview: QuestWidgetAttributes {
        QuestWidgetAttributes(name: "World")
    }
}

extension QuestWidgetAttributes.ContentState {
    fileprivate static var smiley: QuestWidgetAttributes.ContentState {
        QuestWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: QuestWidgetAttributes.ContentState {
         QuestWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: QuestWidgetAttributes.preview) {
   QuestWidgetLiveActivity()
} contentStates: {
    QuestWidgetAttributes.ContentState.smiley
    QuestWidgetAttributes.ContentState.starEyes
}

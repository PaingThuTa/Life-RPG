//
//  QuestWidget.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 26/9/2567 BE.
//

import WidgetKit
import SwiftUI
import Intents

// Define the app group constant

struct QuestEntry: TimelineEntry {
    let date: Date
    let inProgressCount: Int
    
}

struct QuestProvider: TimelineProvider {
    let appGroupID = "group.com.6530288.Life-RPG"
    

    func placeholder(in context: Context) -> QuestEntry {
        QuestEntry(date: Date(), inProgressCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (QuestEntry) -> Void) {
        // Provide static or cached data for snapshots
        let entry = QuestEntry(date: Date(), inProgressCount: 0) // Use 0 or placeholder data
        completion(entry)
    }


    func getTimeline(in context: Context, completion: @escaping (Timeline<QuestEntry>) -> Void) {
        let currentDate = Date()
        let entry = QuestEntry(date: currentDate, inProgressCount: fetchInProgressQuestsCount())
        
        // Set a short refresh interval for testing (1 minute)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }




    
    func fetchInProgressQuestsCount() -> Int {
        guard let sharedDefaults = UserDefaults(suiteName: appGroupID) else {
            print("Failed to fetch shared defaults for app group: \(appGroupID)")
            return 0
        }
        
        if let savedData = sharedDefaults.data(forKey: UserDefaultsKeys.activeQuestsKey) {
            let decoder = JSONDecoder()
            if let quests = try? decoder.decode([Quest].self, from: savedData) {
                let inProgressCount = quests.filter { $0.status == .Inprogress }.count
                print("Fetched in-progress quest count: \(inProgressCount)")
                return inProgressCount
            }
        } else {
            print("No active quests found in shared defaults.")
        }
        return 0
    }




}

struct QuestWidgetView: View {
    var entry: QuestEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(entry.date, formatter: dayOnlyFormatter)")
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(.black)
            Text("\(entry.inProgressCount) in progress quests")
                .font(.system(size: 16))
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.white) // Custom background color
        .containerBackground(Color.white, for: .widget)
 // Ensure this is included for the system's background management
    }
    
    var dayOnlyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
}


struct QuestWidget: Widget {
    let kind: String = "QuestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuestProvider()) { entry in
            QuestWidgetView(entry: entry)
        }
        .configurationDisplayName("Quest Progress")
        .description("Shows the total number of in-progress quests.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}



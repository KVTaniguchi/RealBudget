//
//  Real_Budget_Widget.swift
//  Real Budget Widget
//
//  Created by Kevin Taniguchi on 10/17/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import CoreData
import Intents
import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct Real_Budget_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: RBState.entity(),
        sortDescriptors: []
    ) var state: FetchedResults<RBState>
    
    @FetchRequest(
        entity: RBEvent.entity(),
        sortDescriptors: []
    ) var events: FetchedResults<RBEvent>
    
    var data: [Forecast] {
        var data: [Forecast] = []
        
        let actualBalance = Int(state.first?.actualBalance ?? 0)
        let financialEvents = events.map {
            FinancialEvent(
                id: $0.id,
                type: FinancialEventType(rawValue: Int($0.type)) ?? .expense,
                name: $0.name ?? "no name",
                value: Int($0.change),
                frequency: Frequency(rawValue: Int($0.frequency)) ?? .monthly,
                startDate: $0.startDate ?? Date(),
                endDate: $0.endDate
            )
        }
        let state = FinancialState(actualBalance: actualBalance, events: financialEvents)
        let predictions = PredictionEngine.shared.predict(state: state)
        
        let sortedDates = predictions.keys.sorted()
        
        for date in sortedDates {
            if let forecast = predictions[date] {
                data.append(forecast)
            }
        }
        
        return data
    }

    var body: some View {
        VStack {
            Text(entry.date, style: .time)
            if let first = data.first {
                Text("\(RBDateFormatter.shared.formatter.string(from: first.date)) \(first.balance)")
            }
            if let next = data[1] {
                Text("\(RBDateFormatter.shared.formatter.string(from: next.date)) \(next.balance)")
            }
            if let last = data[2] {
                Text("\(RBDateFormatter.shared.formatter.string(from: last.date)) \(last.balance)")
            }
        }
    }
}

@main
struct Real_Budget_Widget: Widget {
    let kind: String = "Real_Budget_Widget"
    
    var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FinancialState")
        let storeURL = URL.storeURL(for: "group.realbudget", databaseName: "realbudget")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { (description, error) in
            #if DEBUG
                print(error.debugDescription)
            #endif
        }
    }

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            Real_Budget_WidgetEntryView(entry: entry).environment(\.managedObjectContext, container.viewContext)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

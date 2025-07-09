//
//  HomeWidgetExtension.swift
//  HomeWidgetExtension
//
//  Created by Thang Nguyen on 9/7/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Method to retrieve data from Flutter app
    private func getDatafromFlutter()-> SimpleEntry{
        let userDefault = UserDefaults(suiteName: "group.com.victoryverse.flutterkit")
        let textFromFlutterApp = userDefault?.string(forKey: "text_from_flutter_app") ?? "0"

        return SimpleEntry(date: Date(), text: textFromFlutterApp)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = getDatafromFlutter()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getDatafromFlutter()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
}

struct HomeWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.text)
        }
    }
}

struct HomeWidgetExtension: Widget {
    let kind: String = "HomeWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HomeWidgetExtensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HomeWidgetExtensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    HomeWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, text: "😀")
    SimpleEntry(date: .now, text: "🤩")
}

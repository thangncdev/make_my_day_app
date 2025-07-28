//
//  MessageBox.swift
//  MessageBox
//
//  Created by Thang Nguyen on 9/7/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Method to retrieve data from Flutter app
    private func getDatafromFlutter()-> SimpleEntry{
        let userDefault = UserDefaults(suiteName: "group.com.thangnc.MessageBox")
        let textFromFlutterApp = userDefault?.string(forKey: "message_from_flutter_app") ?? ""

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

struct MessageBoxEntryView : View {
    var entry: Provider.Entry
    
    // New: Add the helper function.
    var bundle: URL {
        let bundle = Bundle.main
               if bundle.bundleURL.pathExtension == "appex" {
                   // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
                   var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
                url.append(component: "Frameworks/App.framework/flutter_assets")
                 return url
        }
        return bundle.bundleURL
    }
    
    // New: Register the font.
    init(entry: Provider.Entry){
      self.entry = entry
      CTFontManagerRegisterFontsForURL(bundle.appending(path: "assets/fonts/ShantellSans-Regular.ttf") as CFURL, CTFontManagerScope.process, nil)
    }
    
    var body: some View {
        
                VStack {
                    Text(entry.text).font(Font.custom("ShantellSans-Regular", size: 16))
                        .foregroundColor(.black)
                }
    }
}

struct MessageBox: Widget {
    let kind: String = "MessageBox"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MessageBoxEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MessageBoxEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//
//  HomeWidgetExtensionBundle.swift
//  HomeWidgetExtension
//
//  Created by Thang Nguyen on 9/7/25.
//

import WidgetKit
import SwiftUI

@main
struct HomeWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        HomeWidgetExtension()
        HomeWidgetExtensionControl()
        HomeWidgetExtensionLiveActivity()
    }
}

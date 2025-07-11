//
//  MessageBoxBundle.swift
//  MessageBox
//
//  Created by Thang Nguyen on 11/7/25.
//

import WidgetKit
import SwiftUI

@main
struct MessageBoxBundle: WidgetBundle {
    var body: some Widget {
        MessageBox()
        MessageBoxControl()
    }
}

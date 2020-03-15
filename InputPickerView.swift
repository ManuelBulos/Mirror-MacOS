//
//  InputPickerView.swift
//  mirror
//
//  Created by Manuel on 14/03/20.
//  Copyright © 2020 manuelbulos. All rights reserved.
//

import AppKit
import SwiftUI

struct InputPickerView: View {

    @State private var selectedScreen: String?

    var inputDevices: [String] {
        var screens = NSScreen.screens.map {$0.localizedName}
        screens.append("Camera")
        return screens
    }

    var body: some View {
        Form {
            Section {
                Picker(selection: $selectedScreen, label: Text("")) {
                    ForEach(0..<inputDevices.count) { index in
                        Text(self.inputDevices[index]).tag(index)
                    }
                }
            }
        }
    }
}

extension NSScreen: Identifiable {
    var displayID: Int {
        return deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? Int ?? Int()
    }
}

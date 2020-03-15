//
//  AppDelegate.swift
//  mirror
//
//  Created by Manuel on 14/03/20.
//  Copyright © 2020 manuelbulos. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = NSHostingView(rootView: ContentView())

        // Create the window and set the content view.
        window = MainWindow(contentView: contentView)

        window.makeKeyAndOrderFront(nil)
    }
}

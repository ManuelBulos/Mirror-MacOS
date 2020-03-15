//
//  MainWindow.swift
//  mirror
//
//  Created by Manuel on 14/03/20.
//  Copyright © 2020 manuelbulos. All rights reserved.
//

import AppKit

class MainWindow: NSWindow, NSWindowDelegate {

    /// Returns true if window is centered in the main Screen
    private(set) var isInSpeakerMode: Bool = true

    /// Set at mouseDragged and mouseUp events
    private var isDragging: Bool = false

    init(contentView: NSView?) {
        super.init(contentRect: .zero,
                   styleMask: [.miniaturizable,
                               .resizable,
                               .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        self.delegate = self
        self.level = .floating
        self.backgroundColor = .clear
        self.contentView = contentView
        self.isMovableByWindowBackground = true
        self.setFrameAutosaveName("MainWindow")
        self.resizeToSpeakerMode()
    }

    override func mouseDragged(with event: NSEvent) {
        isDragging = true
    }

    override func mouseUp(with event: NSEvent) {
            if !isDragging {
                if isInSpeakerMode {
                    resizeToMiniatureMode()
                } else {
                    resizeToSpeakerMode()
                }
            }
        isDragging = false
    }

    /// Resizes the window to speaker mode
    private func resizeToSpeakerMode() {
        guard let currentScreenFrame = self.screen?.frame, !isInSpeakerMode else { return }
        let size = CGSize(width: currentScreenFrame.width / 1.5, height: currentScreenFrame.height / 1.5)
        self.setFrame(NSRect(origin: currentScreenFrame.origin, size: size), display: true, animate: true)
        self.center()
        isInSpeakerMode = true
    }

    /// Resizes the window to miniature mode
    private func resizeToMiniatureMode() {
        guard let currentScreenFrame = self.screen?.frame, isInSpeakerMode else { return }
        let size = CGSize(width: currentScreenFrame.height / 4, height: currentScreenFrame.height / 4)
        self.setFrame(NSRect(origin: currentScreenFrame.origin, size: size), display: true, animate: true)
        isInSpeakerMode = false
    }
}

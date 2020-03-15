//
//  CameraView.swift
//  mirror
//
//  Created by Manuel on 14/03/20.
//  Copyright © 2020 manuelbulos. All rights reserved.
//

import Foundation
import SwiftUI
import AppKit

struct CameraView: NSViewRepresentable {
    typealias NSViewType = CameraPreview

    var inputType: CameraPreview.InputType = .camera

    func makeNSView(context: NSViewRepresentableContext<CameraView>) -> CameraPreview {
        return CameraPreview(inputType: inputType)
    }

    func updateNSView(_ nsView: CameraPreview, context: NSViewRepresentableContext<CameraView>) {}
}

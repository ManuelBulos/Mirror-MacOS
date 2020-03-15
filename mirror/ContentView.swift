//
//  ContentView.swift
//  mirror
//
//  Created by Manuel on 14/03/20.
//  Copyright © 2020 manuelbulos. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CameraView()
            .shadow(radius: 4)
            .padding(12)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

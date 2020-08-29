//
//  ContentView.swift
//  FlickTypeKit Sample Extension
//
//  Created by Kosta Eleftheriou on 8/26/20.
//  Copyright © 2020 Kpaw. All rights reserved.
//

import SwiftUI
import FlickTypeKit

struct ContentView: View {
  @State private var text1: String = ""
  @State private var text2: String = ""
  @State private var text3: String = ""
  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        Button(action: {
          WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("Root-WatchKit", NSObject())])
        }) {
          Text("SwiftUI").foregroundColor(.orange)
        }.frame(maxWidth: 100)
        FlickTypeTextEditor(title: "Tap to edit…", text: $text1)
        FlickTypeTextEditor(title: "Tap to edit…", text: $text2)
        FlickTypeTextEditor(title: "Tap to edit…", text: $text3)
        Text("FlickTypeKit v\(Bundle.flickTypeKitBundle.versionAndBuild)").font(.footnote).foregroundColor(.gray)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

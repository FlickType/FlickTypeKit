//
//  ContentView.swift
//  FlickTypeKit Sample WatchKit Extension
//
//  Created by Kosta Eleftheriou on 8/26/20.
//  Copyright © 2020 Kpaw. All rights reserved.
//

import SwiftUI
import FlickTypeKit

struct ContentView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        Button(action: {
          WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("Root-WatchKit", NSObject())])
        }) {
          Text("SwiftUI").foregroundColor(.orange)
        }.frame(maxWidth: 100)
        FlickTypeView(title: "Tap to edit…")
        FlickTypeView(title: "Tap to edit…")
        FlickTypeView(title: "Tap to edit…")
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

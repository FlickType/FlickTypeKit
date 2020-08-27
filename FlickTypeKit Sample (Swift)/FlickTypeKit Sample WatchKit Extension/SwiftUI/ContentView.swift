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
  @State var text1: String = ""
  @State var text2: String = "Testing"
  var body: some View {
    ScrollView {
      VStack {
        Button(action: {
          WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("Root-WatchKit", NSObject())])
        }) {
          Text("SwiftUI").foregroundColor(.orange)
        }
        FlickTypeView(title: "Tap to edit…", text: "")
        Spacer()
        FlickTypeView(title: "Tap to edit…", text: "")
        Spacer()
        FlickTypeView(title: "Tap to edit…", text: "")
        Spacer()
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

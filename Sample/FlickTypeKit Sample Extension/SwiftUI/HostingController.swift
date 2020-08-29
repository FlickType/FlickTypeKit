//
//  HostingController.swift
//  FlickTypeKit Sample Extension
//
//  Created by Kosta Eleftheriou on 8/26/20.
//  Copyright © 2020 Kpaw. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView()
    }
}

struct HostingController_Previews: PreviewProvider {
  static var previews: some View {
    /*@START_MENU_TOKEN@*/Group {
      ContentView()
    }/*@END_MENU_TOKEN@*/
  }
}

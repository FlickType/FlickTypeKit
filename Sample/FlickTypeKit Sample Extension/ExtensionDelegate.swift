//
//  ExtensionDelegate.swift
//  FlickTypeKit Sample Extension
//
//  Created by Kosta Eleftheriou on 12/31/18.
//  Copyright © 2018 Kpaw. All rights reserved.
//

import WatchKit
import FlickTypeKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
  
  func applicationDidFinishLaunching() {
    // This should be your own app url. The recommended format is "https://your.app.domain/flicktype/"
    FlickType.returnURL = URL(string: "https://www.flicktype.com/flicktype/")
  }
  
  func handle(_ userActivity: NSUserActivity) {
    if FlickType.handle(userActivity) { return }
    // Handle other activities here
    print("Received non-FlickType activity \(userActivity)")
  }
  
}

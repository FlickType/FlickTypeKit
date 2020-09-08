//
//  InterfaceController.swift
//  FlickTypeKit Sample Extension
//
//  Created by Kosta Eleftheriou on 12/31/18.
//  Copyright © 2018 Kpaw. All rights reserved.
//

import WatchKit
import Foundation

import FlickTypeKit

class InterfaceController: WKInterfaceController {
  
  @IBOutlet weak var label1: WKInterfaceLabel!
  @IBOutlet weak var label2: WKInterfaceLabel!
  @IBOutlet weak var label3: WKInterfaceLabel!
  @IBOutlet weak var tapRecognizer1: WKTapGestureRecognizer!
  @IBOutlet weak var tapRecognizer2: WKTapGestureRecognizer!
  @IBOutlet weak var tapRecognizer3: WKTapGestureRecognizer!
  @IBOutlet weak var versionLabel: WKInterfaceLabel!
  
  // We keep this mapping in order to use the same action code for all recognizers/labels
  var recognizerLabels: [WKTapGestureRecognizer : WKInterfaceLabel]!
  
  // We store the current text of each label so that we can support editing existing content
  var labelTexts = NSMutableDictionary()
  
  //////////////////////////////////////
  //////      Initial setup       //////
  //////////////////////////////////////
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    // Set initial label content. The empty string will show a placeholder.
    [label1, label2, label3].forEach { label in
      label.setText("", storeIn: labelTexts)
    }
    versionLabel.setText("FlickTypeKit v\(Bundle.flickTypeKitBundle.versionAndBuild)")
  }
  
  // We need a place to initialize `recognizerLabels`, but we can't yet access the fully
  // realized objects in `awake()`... (we instead get a "WKPlaceholderGestureRecognizer" there)
  override func willActivate() {
    super.willActivate()
    // This is a good place to initialize the `recognizerLabels` dictionary
    _ = initializeRecognizerMappings
  }
  
  private lazy var initializeRecognizerMappings: Void = {
    recognizerLabels = [
      tapRecognizer1 : label1,
      tapRecognizer2 : label2,
      tapRecognizer3 : label3,
    ]
  }()
  
  //////////////////////////////////////
  //////     Typing & editing     //////
  //////////////////////////////////////
  
  @IBAction func startTyping(_ tapRecognizer: WKTapGestureRecognizer) {
    
    // Grab the relevant label and its current text
    let label = recognizerLabels[tapRecognizer]!
    let startingText = labelTexts[label.interfaceProperty] as? String ?? ""
    
    presentTextInputController(
      withSuggestions: nil,
      allowedInputMode: .allowEmoji,
      flickType: .ask,
      startingText: startingText) { items in
        if let text = items?.first as? String {
          label.setText(text, storeIn: self.labelTexts)
        }
    }
  }
  
}

// A simple `setText()` wrapper
extension WKInterfaceLabel {
  func setText(_ text: String, storeIn labelTexts: NSMutableDictionary) {
    if text.isEmpty {
      setAttributedText(NSAttributedString(string: "Tap to edit…"))
      setTextColor(.gray)
    } else {
      setText(text)
      setTextColor(.white)
    }
    labelTexts[self.interfaceProperty] = text
  }
}

extension InterfaceController {
  @IBAction func switchToSwiftUISample() {
    WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("Root-SwiftUI", NSObject())])
  }
}

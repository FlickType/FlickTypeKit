//
//  InterfaceController.swift
//  FlickTypeKit Sample WatchKit Extension
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
  @IBOutlet weak var settingButton: WKInterfaceButton!
  
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
    // Initialize to always ask between FlickType and Standard input modes.
    flickTypeMode = .always
    
    
    if ProcessInfo().operatingSystemVersion.majorVersion < 7 {
      // This is useful for testing the initial downloading of FlickType resources.
      addMenuItem(with: .trash, title: "Delete resource files", action: #selector(deleteResourceFiles))
    }
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
      flickTypeMode: flickTypeMode,
      startingText: startingText) { items in
        if let text = items?.first as? String {
          label.setText(text, storeIn: self.labelTexts)
        }
    }
  }
  
  //////////////////////////////////////
  //////  Changing flickTypeMode  //////
  //////////////////////////////////////
  
  @IBAction func settingButtonTapped() {
    flickTypeMode = FlickType.Mode(rawValue: (flickTypeMode.rawValue + 1) % 3)!
  }
  
  var flickTypeMode: FlickType.Mode! {
    // Update button appearance
    didSet {
      settingButton.setAttributedTitle(NSAttributedString(string: "FlickType: \(flickTypeMode!)", attributes: [.foregroundColor: UIColor.gray]))
      switch flickTypeMode! {
      case .always:   settingButton.setBackgroundColor(.alwaysColor)
      case .off:      settingButton.setBackgroundColor(.disabledColor)
      case .ask:      settingButton.setBackgroundColor(.askColor)
      default: preconditionFailure()
      }
    }
  }
  
}

// A simple `setText()` wrapper
extension WKInterfaceLabel {
  func setText(_ text: String, storeIn labelTexts: NSMutableDictionary) {
    if text.isEmpty {
      setAttributedText(NSAttributedString(string: "Tap to edit...", attributes: [.obliqueness: 0.2]))
      setTextColor(.lightGray)
    } else {
      setText(text)
      setTextColor(.white)
    }
    labelTexts[self.interfaceProperty] = text
  }
}

extension UIColor {
  static let alwaysColor   = UIColor(red:  32.0/255.0, green: 222.0/255.0, blue: 113.0/255.0, alpha: 0.3)
  static let disabledColor = UIColor(red: 252.0/255.0, green:  34.0/255.0, blue:  79.0/255.0, alpha: 0.3)
  static let askColor: UIColor? = nil
}

extension InterfaceController {
  @objc func deleteResourceFiles() {
    FlickType.deleteLocalResourceFiles()
  }
}

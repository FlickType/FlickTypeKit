//
//  FlickTypeKit-SwiftUI.swift
//  FlickTypeKit
//
//  Created by Kosta Eleftheriou on 9/13/20.
//  Copyright © 2020 Kpaw. All rights reserved.
//

import SwiftUI

@available(watchOSApplicationExtension 6.0, *)
public struct FlickTypeTextEditor: View {
  
  @Binding
  private var text: String
  private let title: String
  private let mode: FlickType.Mode
  
  public init(title: String = "", text: Binding<String>, mode: FlickType.Mode = .ask) {
    self.title = title
    self._text = text
    self.mode = mode
  }
  
  public var body: some View {
    Button(action: {
      WKExtension.shared().visibleInterfaceController?.presentTextInputController(
        withSuggestions: nil,
        allowedInputMode: .allowEmoji,
        flickType: self.mode,
        startingText: self.text) { items in
          if let newText = items?.first as? String {
            self.text = newText
          }
      }
    }) {
      Group {
        if text.isEmpty {
          Text(title).foregroundColor(.init(UIColor.gray))
        } else {
          Text(text)
        }
      }.frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

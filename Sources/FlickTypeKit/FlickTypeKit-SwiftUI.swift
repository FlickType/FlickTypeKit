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
  private let onCommit: () -> Void
  
  public init(title: String = "", text: Binding<String>, mode: FlickType.Mode = .ask, onCommit: @escaping () -> Void = {}) {
    self.title = title
    self._text = text
    self.mode = mode
    self.onCommit = onCommit
  }
  
  public var body: some View {
    Button(action: {
      // There are cases where `visibleInterfaceController` might be nil, for example the destination of a `NavigationLink`.
      // In those instances we'll try to use the root controller, even though we get the warning:
      // "Presenting view controller XYZ from detached view controller XYZ is discouraged."
      guard let controller = WKExtension.shared().visibleInterfaceController ?? WKExtension.shared().rootInterfaceController else {
        print("FlickTypeTextEditor: Error: could not get required current controller")
        return
      }
      controller.presentTextInputController(
        withSuggestions: nil,
        allowedInputMode: .allowEmoji,
        flickType: self.mode,
        startingText: self.text) { items in
          guard let newText = items?.first as? String else { return }
          self.text = newText
          if items?.completionType == .action {
            onCommit()
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

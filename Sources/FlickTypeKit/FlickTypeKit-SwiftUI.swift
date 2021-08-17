//
//  FlickTypeKit-SwiftUI.swift
//  FlickTypeKit
//
//  Created by Kosta Eleftheriou on 9/13/20.
//  Copyright © 2020 Kpaw. All rights reserved.
//

// This conditional is here because Xcode SwiftUI previews try to compile FlickTypeKit for non-watchOS platforms, despite it being a watchOS-only package.
#if os(watchOS)
import SwiftUI

@available(watchOSApplicationExtension 6.0, *)
public struct FlickTypeTextEditor: View {
  
  @Binding
  private var text: String
  private let title: LocalizedStringKey
  private let mode: FlickType.Mode
  private let flickTypeProperties: [String : String]
  private let onCommit: () -> Void
  
  public init(_ title: LocalizedStringKey = "", text: Binding<String>, mode: FlickType.Mode = .ask, flickTypeProperties: [String : String] = [:], onCommit: @escaping () -> Void = {}) {
    self.title = title
    self._text = text
    self.mode = mode
    self.flickTypeProperties = flickTypeProperties
    self.onCommit = onCommit
  }
  
  private func action() {
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
        flickTypeProperties: flickTypeProperties,
        startingText: self.text) { items in
          guard let items = items else { return }
          guard let newText = items.first as? String else { return }
          self.text = newText
          switch items.completionType {
            case nil, .action: onCommit() // FlickType wasn't used, or the FlickType "Done" button was used
            case .dismiss: break // FlickType was dismissed
          }
      }
  }
  
  public var body: some View {
    Button(action: action) {
      HStack {
        if text.isEmpty {
          Text(title).foregroundColor(.init(UIColor.gray))
        } else {
          Text(text)
        }
        Spacer()
      }
      .contentShape(Rectangle())
    }
  }
}

#endif // os(watchOS)

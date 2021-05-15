//
//  FlickTypeKit.swift
//  FlickTypeKit
//
//  Created by Kosta Eleftheriou on 12/26/18.
//  Copyright © 2018-2020 Kpaw. All rights reserved.
//

import WatchKit


public extension WKInterfaceController {
  
  // TODO: address case where `presentTextInputController()` or `presentTextInputControllerWithSuggestions()` are called while
  // there's already a system input or FlickType controller presented.
  
  @objc
  func presentTextInputController(
    withSuggestions suggestions: [String]?,
    allowedInputMode inputMode: WKTextInputMode,
    flickType flickTypeMode: FlickType.Mode,
    flickTypeProperties: [String: String] = [:],
    startingText: String = "",
    completion: @escaping ([Any]?) -> Void) {
    
    // This source version of FlickTypeKit only supports watchOS 7 or later
    guard ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 7 else {
      return presentTextInputController(withSuggestions: suggestions, allowedInputMode: inputMode, completion: completion)
    }
    
    precondition(Thread.isMainThread)
    handlePresentTextInput(TextInputInvocation(
      suggestions: suggestions,
      suggestionsHandler: nil,
      inputMode: inputMode,
      flickTypeMode: flickTypeMode,
      flickTypeProperties: flickTypeProperties,
      startingText: startingText,
      completion: completion)
    )
  }
  
  @objc
  func presentTextInputControllerWithSuggestions(
    forLanguage suggestionsHandler: ((String) -> [Any]?)?,
    allowedInputMode inputMode: WKTextInputMode,
    flickType flickTypeMode: FlickType.Mode,
    flickTypeProperties: [String: String] = [:],
    startingText: String = "",
    completion: @escaping ([Any]?) -> Void) {
    
    // This source version of FlickTypeKit only supports watchOS 7 or later
    guard ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 7 else {
      return presentTextInputControllerWithSuggestions(forLanguage: suggestionsHandler, allowedInputMode: inputMode, completion: completion)
    }
    
    precondition(Thread.isMainThread)
    handlePresentTextInput(TextInputInvocation(
      suggestions: nil,
      suggestionsHandler: suggestionsHandler,
      inputMode: inputMode,
      flickTypeMode: flickTypeMode,
      flickTypeProperties: flickTypeProperties,
      startingText: startingText,
      completion: completion)
    )
  }
  
  private func handlePresentTextInput(_ invocation: TextInputInvocation) {
    // You can only edit existing text with FlickType.
    let existingText = invocation.startingText.isEmpty == false
    var flickTypeMode: FlickType.Mode = existingText ? .always : invocation.flickTypeMode
    
    // Don't force FlickType if the app is not known to be installed on the device
      if flickTypeMode == .always && !FlickType.hasSwitchedFromFlickType {
        flickTypeMode = .ask
      }

    switch flickTypeMode {
    case .ask:      presentSystemInputController(invocation)
    case .always:   presentFlickTypeOrIntermediateController(invocation)
    case .off:      presentSystemInputController(invocation)
    }
  }
  
  internal func presentSystemInputController(_ invocation: TextInputInvocation) {
    
    let flickTypeText = "⌨︎\tFlickType\n\tKeyboard"
    func completionWrapper(textInputControllerReturnedItems: [Any]?) {
      if let inputText = textInputControllerReturnedItems?.first as? String {
        if inputText == flickTypeText {
          return presentFlickTypeOrIntermediateController(invocation)
        }
      }
      invocation.completion(textInputControllerReturnedItems)
    }
    
    // Handle the 4 combinations of (list or handler) x (include flicktype or not)
    if let suggestionsHandler = invocation.suggestionsHandler {
      let wrappedSuggestionsHandler = { (invocation.flickTypeMode == .off ? [] : [flickTypeText]) + (suggestionsHandler($0) ?? []) }
      presentTextInputControllerWithSuggestions(forLanguage: wrappedSuggestionsHandler, allowedInputMode: invocation.inputMode, completion: completionWrapper)
    } else {
      let suggestions = (invocation.flickTypeMode == .off ? [] : [flickTypeText]) + (invocation.suggestions ?? [])
      presentTextInputController(withSuggestions: suggestions, allowedInputMode: invocation.inputMode, completion: completionWrapper)
    }
  }
  
  internal func alert(_ message: String) {
    presentAlert(withTitle: "⚠️\nFlickTypeKit", message: message, preferredStyle: .alert, actions: [.init(title: "OK", style: .default, handler: {})])
  }
  
  internal func presentFlickTypeOrIntermediateController(_ invocation: TextInputInvocation) {
    
    // A returnURL is mandatory regardless of watchOS version
    guard let returnURL = FlickType.returnURL else { return alert("FlickType.returnURL is not set") }
    
      func switchToFlickType(includeStartingText: Bool) {
        let token = "\(Date.timeIntervalSinceReferenceDate)"
        FlickType.returnHandler = (token, invocation.completionHandler)
        let queryItems = [
          "token" : token,
          "returnURL" : returnURL.absoluteString,
          "startingText" : includeStartingText ? invocation.startingText : "",
        ].merging(invocation.flickTypeProperties, uniquingKeysWith: { current, _ in current })
        var urlComps = URLComponents(string: FlickType.typeURL)!
        urlComps.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        WKExtension.shared().openSystemURL(urlComps.url!)
      }

      if FlickType.hasSwitchedFromFlickType {
        switchToFlickType(includeStartingText: true)
      } else {
        let flickTypeAppStoreURL = URL(string: "https://apps.apple.com/us/app/flicktype-keyboard/id1359485719")!
        presentAlert(
          withTitle: "⌨️", // TODO: see if another keyboard emoji shows up better
          message: "Download “FlickType Keyboard” from the App Store?",
          preferredStyle: .alert,
          actions: [
            .init(title: "Download now", style: .default, handler: { WKExtension.shared().openSystemURL(flickTypeAppStoreURL) }),
            .init(title: "I already have it", style: .default, handler: {
              // Redact `startingText` until the first successful app-switch roundtrip, to prevent sensitive content from
              // ever reaching our server if watchOS implements opening a web browser when our app isn't installed.
              switchToFlickType(includeStartingText: false)
            }),
          ]
        )
      }
  }
    
}

public class FlickType : NSObject {
  
  public static let sdkVersion = "2.0.0 (source)"
  
  @objc
  public enum CompletionType : Int {
    case dismiss
    case action
  }
  
  @objc
  public enum Mode : Int {
    case ask
    case always
    case off
  }
  
  private override init() {
  }
  
  // eg "https://www.my-app.com/flicktype"
  public static var returnURL: URL!
  
  fileprivate static let typeURL = "https://flicktype.com/type/"
  fileprivate static var returnHandler: (token: String, completion: InvocationCompletionHandler)!
  fileprivate static var hasSwitchedFromFlickType: Bool {
    get { UserDefaults.standard.bool(forKey: "FlickType_HAS_SWITCHED_FROM_MAIN_APP") }
    set { UserDefaults.standard.setValue(newValue, forKey: "FlickType_HAS_SWITCHED_FROM_MAIN_APP")}
  }
  
  // Returns true if it was a FlickType response activity
  public static func handle(_ userActivity: NSUserActivity) -> Bool {
    print("handle userActivity", userActivity)
    // TODO: main thread check?
    
    func alert(_ message: String) {
      print("⚠️ FlickTypeKit alert: \(message)")
      WKExtension.shared().visibleInterfaceController?.alert(message)
    }
        
    // Get URL components from the incoming user activity
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let incomingURL = userActivity.webpageURL,
      let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else { return false }
    
    guard let returnURL = returnURL else {
      alert("Return URL is not set")
      return false
    }
    
    guard incomingURL.absoluteString.starts(with: returnURL.absoluteString) else { return false }
    
    guard let (expectedToken, completionHandler) = returnHandler else {
      alert("Unexpected activity")
      return true
    }
    
    guard let params = components.queryItems else {
      alert("No query items")
      return true
    }
    
    guard let token = params.first(where: { $0.name == "token" } )?.value else {
      alert("No token param")
      return true
    }
    
    guard token == expectedToken else {
      alert("Unexpected token")
      return true
    }
    
    guard let text = params.first(where: { $0.name == "text" } )?.value else {
      alert("No text param")
      return true
    }
    
    var completionType = CompletionType.action
    // App versions < 2020.8 did not supply a completion type on return
    if let _completionParam = params.first(where: { $0.name == "completion" } )?.value,
      // Make sure we can handle malformed values
      let _completionInt = Int(_completionParam),
      let _completionType = CompletionType(rawValue: _completionInt) {
      // We got a valid CompletionType, use it
      completionType = _completionType
    }
    
    hasSwitchedFromFlickType = true
    returnHandler = nil
    completionHandler(text, completionType)
    
    return true
  }
  
}

internal typealias InvocationCompletionHandler = (String, FlickType.CompletionType) -> Void

internal struct TextInputInvocation {
  let suggestions: [String]?
  let suggestionsHandler: ((String) -> [Any]?)?
  let inputMode: WKTextInputMode
  let flickTypeMode: FlickType.Mode
  let flickTypeProperties: [String: String]
  let startingText: String
  let completion: ([Any]?) -> Void
  var completionHandler: InvocationCompletionHandler { return { self.completion([$0, $1]) } } // append `CompletionType` at the end of the returned array
}

// TODO: don't add anything to `Array`, redefine as `FlickType.something()`
public extension Array {
  var completionType: FlickType.CompletionType {
    return compactMap { $0 as? FlickType.CompletionType }.first!
  }
}

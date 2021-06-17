[![FlickType icon](docs/icon.png)](https://apps.apple.com/us/app/flicktype-keyboard/id1359485719)
[![FlickType screenshot](docs/screenshot-1.png)](https://apps.apple.com/us/app/flicktype-keyboard/id1359485719)
[![FlickType screenshot](docs/screenshot-2.png)](https://apps.apple.com/us/app/flicktype-keyboard/id1359485719)

# FlickTypeKit 🚀
[![Build Status](https://travis-ci.com/FlickType/FlickTypeKit.svg?branch=main)](https://travis-ci.com/FlickType/FlickTypeKit) 

[_“Best of 2020”_](https://apps.apple.com/us/story/id1535572713) - Apple
<br>
[_“Apple Watch App of the Year”_](https://appadvice.com/post/appadvices-top-10-apple-watch-apps-2018/764638) - AppAdvice
<br>
[_“Makes Typing a Breeze”_](https://www.forbes.com/sites/davidphelan/2019/03/02/apple-watch-flicktype-gesture-keyboard-app-makes-typing-a-breeze-is-it-any-good/) - Forbes

Add a powerful keyboard to your watchOS apps and dramatically improve the text input experience for users. Leverage full typing and editing capabilities to greatly enhance existing parts of your app, or enable entirely new features like messaging and note-taking directly on Apple Watch.

### Usage
Modify your `[self presentTextInputController ...]` calls to include the `flickType` argument:

<pre>
<b>#import "FlickTypeKit/FlickTypeKit.h"</b>

[self presentTextInputControllerWithSuggestions:nil
  allowedInputMode:WKTextInputModeAllowEmoji
  <b>flickType:FlickTypeModeAsk</b>
  completion:^(NSArray *results) {
    if ([results.firstObject isKindOfClass:[NSString class]]) {
        NSLog(@"User typed text: %@", text);
    }
}];
</pre>

 `FlickTypeModeAsk` will offer a choice between FlickType and the standard input methods _(recommended)_.
 <br>
 `FlickTypeModeAlways` will always open FlickType, skipping the input method selection.
 <br>
 `FlickTypeModeOff` will present the standard input method selection without the FlickType option.

_**Note:** The optional `startingText` argument can be used to support editing of existing text with FlickType._

## Integration

### Swift Package Manager

```
https://github.com/FlickType/FlickTypeKit
```

### Universal links

FlickType uses [universal links](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content) to seamlessly switch between your app and the [FlickType Keyboard](https://apps.apple.com/us/app/flicktype-keyboard/id1359485719) app. Thus the keyboard always stays up-to-date without you having to update your app, and utilizes the user's settings and custom dictionary.

To support universal links in your app: 

1. Add an [applinks](https://developer.apple.com/documentation/safariservices/supporting_associated_domains) associated domain entitlement to your watch extension target:
![Associated domains screenshot](docs/associated-domains.png)

2. Create a file named [`apple-app-site-association`](https://developer.apple.com/documentation/safariservices/supporting_associated_domains) (without an extension) with the following contents, and place it in your site’s `.well-known` directory:

```
{
  "applinks": {
      "details": [
           {
             "appIDs": [ "<Team ID>.your.watchkitextension.identifier" ],
             "components": [
               {
                  "/": "/flicktype/*",
                  "comment": "Matches any URL whose path starts with /flicktype/"
               }
             ]
           }
       ]
   }
}
```

The file’s URL should match the format `https://your.app.domain/.well-known/apple-app-site-association` and must be hosted with a valid certificate and with no redirects.

3. Add the following inside your `[WKExtensionDelegate applicationDidFinishLaunching]`:
```
FlickType.returnURL = [NSURL URLWithString:@"https://your.app.domain/flicktype/"];
```
4. Add the following inside your `[WKExtensionDelegate handleActivity:(NSUserActivity *)userActivity]`:
```
if ([FlickType handle:userActivity]) { return; }
```

### Help & support
 - Check out the provided sample app. 
 - [Email](mailto:sdk@flicktype.com) me or find me on [Twitter](https://twitter.com/keleftheriou)!

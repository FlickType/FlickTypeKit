//
//  ObjcUtilities.h
//  Keyboard
//
//  Created by Kosta Eleftheriou on 4/29/18.
//  Copyright © 2018 Kpaw LLC. All rights reserved.
//

#ifndef ObjcUtilities_h
#define ObjcUtilities_h

// For UUID_from hack
#import <Foundation/NSUUID.h>

#if TARGET_OS_WATCH || TARGET_OS_IOS
// For UIAccessibilityNotifications
#import <UIKit/UIAccessibilityConstants.h>
#endif

@interface NSUUID (NoCrash)
- (BOOL) isNil;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ObjcUtilities : NSObject

#if TARGET_OS_IOS
// This is needed because when the UUID is nil (happens when switching fields), calling textDocumentProxy.documentIdentifier from Swift
// results in a really awesome crash since it's not marked as an optional in Swift: https://bugs.swift.org/browse/SR-6143
+ (NSUUID*) UUID_from:(id) textDocumentProxy; // UITextDocumentProxy

// TODO: we could use something like this for a pure Swift workaround:
//extension UITextDocumentProxy {
//    public var safeDocumentIdentifier: UUID? {
//        return self.perform(#selector(getter: UITextDocumentProxy.documentIdentifier))?.takeUnretainedValue() as! UUID?
//    }
//}

#endif

+ (NSArray<NSString*> *) tokenize: (NSString*) string;
+ (NSDictionary<NSString*, NSNumber*>*) processMemoryStats;

@end


#if TARGET_OS_WATCH

@interface WatchOSAccessibilityNotificationHelper : NSObject
+ (void) post:(UIAccessibilityNotifications) notification argument:(_Nullable id) argument;
@end

@interface WatchOSObjCHelper : NSObject
// [UIView setAnimationsEnabled:]
+ (void) setAnimationsEnabled:(BOOL)enabled;
+ (void) setBackgroundColor: (id) color forObject: (id) object;
+ (id) superviewOf: (id) object;
@end

#endif

NS_ASSUME_NONNULL_END

#endif /* ObjcUtilities_h */

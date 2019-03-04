//
//  BigramContextProvider.h
//  FlickTypeKit
//
//  Created by Kosta Eleftheriou on 1/24/19.
//  Copyright © 2019 Kpaw. All rights reserved.
//

#ifndef BigramContextProvider_h
#define BigramContextProvider_h

#import <Foundation/Foundation.h>

typedef u_int16_t WordID;
typedef Float32   Probability;

@interface BigramContextProvider : NSObject {
  void* internalProvider;
  NSData* data;
}

- (instancetype) init NS_UNAVAILABLE;
// Data argument expected to be NSData*. Using `id` to ensure we avoid any unnecessary NSData<>Data Swift conversion work (TODO: profile to see if this is actually true)
- (instancetype) initWithData: (id) data NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithFile: (NSURL*) fileURL;
- (long) dataForPrecedingTokenID: (WordID) tokenID results: (Probability*) results maxWordID: (WordID) maxWordID;

@end

#endif /* BigramContextProvider_h */

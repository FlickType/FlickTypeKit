//
//  RandomNumberGeneratorObjC.h
//  FlickTypeKit
//
//  Created by Kosta Eleftheriou on 1/24/19.
//  Copyright © 2019 Kpaw. All rights reserved.
//

#ifndef RandomNumberGeneratorObjC_h
#define RandomNumberGeneratorObjC_h

#import <Foundation/Foundation.h>
#include "./GeometryCommon.h"

// We need this class for the `nextGaussian` function.
// If GameplayKit was available for watchOS we'd use that instead, but it's not there yet :(

@interface RandomNumberGeneratorObjC : NSObject {
  void* internalGenerator;
}
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithSeed: (long) seed NS_DESIGNATED_INITIALIZER;
- (void) seedWith: (long) seed;
- (FLFloat) nextGaussian;
- (FLFloat) nextUniform;
- (UInt64) next;
@end


#endif /* RandomNumberGeneratorObjC_h */

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
#import <CoreGraphics/CGBase.h>

@interface RandomNumberGeneratorObjC : NSObject {
  void* internalGenerator;
}
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithSeed: (long) seed NS_DESIGNATED_INITIALIZER;
- (void) seedWith: (long) seed;
- (CGFloat) nextGaussian;
- (CGFloat) nextUniform;
@end


#endif /* RandomNumberGeneratorObjC_h */

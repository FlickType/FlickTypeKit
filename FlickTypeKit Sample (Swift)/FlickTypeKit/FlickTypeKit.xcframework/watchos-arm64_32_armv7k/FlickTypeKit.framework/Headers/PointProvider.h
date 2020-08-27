//
//  PointProvider.h
//  FlickTypeKit
//
//  Created by Kosta Eleftheriou on 5/3/20.
//  Copyright © 2020 Kpaw. All rights reserved.
//

#ifndef PointProvider_h
#define PointProvider_h

#import <Foundation/Foundation.h>

#include "GeometryCommon.h" // only for typedefs

@interface PointProvider : NSObject {
  id reader;
}

- (instancetype) init NS_UNAVAILABLE;
// Data arguments expected to be NSData*. Using `id` to ensure we avoid any unnecessary NSData<>Data Swift conversion work (TODO: profile to see if this is actually true)
- (instancetype) initWithMapData: (id) mapData listData: (id) listData NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithMapFile: (NSURL*) mapFileURL listFile: (NSURL*) listFileURL;

- (const FLPoint*) pointsFor: (ShapeID) shapeID count: (u_int16_t*) count;

+ (void) writeShapes: (ShapeDictionaryObjC*) shapes toMapFile: (NSURL*) mapFileURL toListFile: (NSURL*) listFileURL binaryValueType: (NSString*) binaryValueType;

@end


#endif /* PointProvider_h */

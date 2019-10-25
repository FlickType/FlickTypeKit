//
//  GeometricHashReader.h
//  FlickTypeKit
//
//  Created by Kosta Eleftheriou on 1/19/19.
//  Copyright © 2019 Kpaw. All rights reserved.
//

#ifndef GeometricHashReader_h
#define GeometricHashReader_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GeometricHashCommon.h"

struct GeometricHashReaderPimpl;

@interface GeometricHashReader : NSObject {
  ShapeID maxShapeID;
  struct GeometricHashReaderPimpl* pImpl;
}

- (instancetype) init NS_UNAVAILABLE;
// Data arguments expected to be NSData*. Using `id` to ensure we avoid any unnecessary NSData<>Data Swift conversion work (TODO: profile to see if this is actually true)
- (instancetype) initWithMapData: (id) mapData listData: (id) listData maxShapeID: (ShapeID) maxShapeID NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithMapFile: (NSURL*) mapFileURL listFile: (NSURL*) listFileURL maxShapeID: (ShapeID) maxShapeID;

// Querying (incremental)
- (void) reset;
- (void) processLastPointFromPoints: (NSArray<NSValue*>*) points estimatedInputNoise: (CGPoint) estimatedInputNoise kernelsUsed: (long*) kernelsUsed cellsUsed: (long*) cellsUsed votesCast: (double*) votesCast;
- (void) peekUnsortedResultScores: (ShapeScore*) resultScores maxResults: (long) maxResults;
- (long) pointsAdded;

@property (readonly) ShapeID maxShapeID;

@end

#endif /* GeometricHashReader_h */

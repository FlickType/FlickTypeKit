//
//  GeometryCommon.h
//  FlickTypeKit
//
//  Created by Kosta Eleftheriou on 1/30/19.
//  Copyright © 2019 Kpaw. All rights reserved.
//

#ifndef GeometryCommon_h
#define GeometryCommon_h

#import <Foundation/Foundation.h>

typedef Float32 FLFloat;
struct
FLPoint {
    FLFloat x;
    FLFloat y;
};
typedef struct FLPoint FLPoint;

typedef u_int16_t ShapeID;
typedef NSDictionary<NSNumber*, NSArray<NSValue*>*> ShapeDictionaryObjC;

#endif /* GeometryCommon_h */

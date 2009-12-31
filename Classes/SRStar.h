//	
//	SRStar.h
//
//  A part of Sterren.app, planetarium iPhone application.
//  Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//  Use without premission by Mote of Life is not authorised.
//
//  Mote of Life is a registred company at the Dutch Chamber of Commerce.
//  Chamber of Commerce registration number: 37126951
//

#import <UIKit/UIKit.h>
#import "OpenGLCommon.h"

typedef struct {
	float red;
	float green;
	float blue;
	float alpha;
} StarColor;

static inline StarColor StarColorMake(float inRed, float inGreen, float inBlue, float inAlpha)
{
    StarColor ret;
	ret.red = inRed;
	ret.green = inGreen;
	ret.blue = inBlue;
	ret.alpha = inAlpha;
    return ret;
}

@interface SRStar : NSObject {
	
	int starID;
	NSString *name;
	NSString *bayer;
	NSString * x;
	NSString * y;
	NSString * z;
	NSString * mag;
	NSString * ci;
	BOOL selected;
	
}



@property (nonatomic, readwrite) int starID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * bayer;
@property (nonatomic, retain) NSString * x;
@property (nonatomic, retain) NSString * y;
@property (nonatomic, retain) NSString * z;
@property (nonatomic, retain) NSString * ci;
@property (nonatomic, retain) NSString * mag;
@property (nonatomic, readwrite) BOOL selected;

-(BOOL)visibleWithZoom:(float)zoomf;
-(float)size;
-(StarColor)color;
-(float)alpha;
-(Vertex3D)myCurrentPosition;
-(Vertex3D)position;

@end
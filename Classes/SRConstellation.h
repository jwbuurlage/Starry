//
//  SRConstellation.h
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


#import <Foundation/Foundation.h>
#import "SRConstellationLine.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface SRConstellation : NSObject {		
	NSMutableArray* lines;
	NSString* name;
	float ra;
	float dec;
	
	GLfloat constellationPoints[150];
}
	
@property (readonly) float ra;
@property (readonly) float dec;
@property (nonatomic, retain) NSMutableArray *lines;
@property (nonatomic, retain) NSString *name;

-(void)calculateRADec;
-(void)draw;
-(void)makeArray;

@end

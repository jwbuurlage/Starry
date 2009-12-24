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
#import "OpenGLCommon.h"
#import "Texture2D.h"

@interface SRConstellation : NSObject {		
	NSMutableArray* lines;
	NSString* name;
	float ra;
	float dec;
	
	Texture2D* nameTexture;
	Vertex3D texturePosition;
	
	GLfloat constellationPoints[200];
}
	
@property (nonatomic, assign) float ra;
@property (nonatomic, assign) float dec;
@property (nonatomic, retain) NSMutableArray *lines;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Texture2D *nameTexture;

-(void)calculateRADec;
-(void)draw;
-(void)drawText;
-(void)makeArray;

@end

//
//  SRModule.h
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
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class SRInterface;

@interface SRModule : NSObject {
	NSMutableArray* elements;
	BOOL visible; 
	int yTranslate;
	
	NSTimer* posiTimer;
	NSTimer* negiTimer;
	
	GLuint textures[9];
	GLfloat textureCorners[150];
	GLfloat textureCoords[100];
}

@property (readonly) BOOL visible;
@property (readonly) int yTranslate;
@property (readonly) NSMutableArray* elements;

-(void)hide;
-(void)show;
-(void)translate:(NSTimer*)theTimer;
-(void)draw;
-(void)loadTexture:(NSString *)name intoLocation:(GLuint)location;
-(void)loadTextureWithString:(NSString *)text intoLocation:(GLuint)location;
-(CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle;

@end

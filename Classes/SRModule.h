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
	BOOL hiding;
	BOOL keyboardVisible;
		
	GLuint textures[9];
	GLfloat textureCorners[150];
	GLfloat textureCoords[100];
	
	float xValueIcon;
	float initialXValueIcon;
	float alphaValue;
}

@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL hiding;
@property (nonatomic, assign) BOOL keyboardVisible;
@property (nonatomic, assign) float alphaValue;
@property (nonatomic, assign) float xValueIcon;
@property (nonatomic, assign) float initialXValueIcon;
@property (readonly) NSMutableArray* elements;

-(void)hide;
-(void)show;
-(void)draw;

@end

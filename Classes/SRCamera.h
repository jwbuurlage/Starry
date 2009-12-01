//
//  SRCamera.h
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
#import <UIKit/UIKit.h>
#import "GLView.h"
#import "OpenGLCommon.h"

@interface SRCamera : NSObject {
	int touchX;
	int touchY;
	
	float sphereRadius;
	
	float deltaXRadians, deltaYRadians;
	
	float lookAtX;
	float lookAtY;
	float lookAtZ;
	
	float altitude;
	float azimuth;
	
	float deacco;
	float hSpeed;
	float vSpeed;
	int accH;
	int accV;
	
	GLfloat fieldOfView;
	GLView* theView;
	
	CGRect rect;
	GLfloat size;
	
	BOOL swipeHor;
	BOOL swipeVer;
	
	int hSteps;
	int vSteps;
	
	GLfloat zoomingValue; 
}

-(GLfloat)zoomingValue;
- (id)initWithView:(GLView*)view;
- (void)adjustView;
- (void)rotateCameraWithX:(int)deltaX Y:(int)deltaY;
- (void)zoomCameraWithDelta:(int)delta centerX:(int)cx centerY:(int)cy;
- (void)initiateHorizontalSwipeWithX:(int)theX;
- (void)initiateVerticalSwipeWithY:(int)theY;
- (void)reenable;
- (void)RAAndDecForPoint:(CGPoint)point;

@end

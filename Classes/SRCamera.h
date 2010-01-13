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
	BOOL tapZoom;
	BOOL zoomOut;
	BOOL planetView;
	
	int zoomDeltaX;
	int zoomDeltaY;
	
	//float rotationY1;
	//float rotationZ;
	
	float preRA;
	int tSteps;
	int oSteps;
	float hSteps;
	float vSteps;
	
	GLfloat zoomingValue; 
}

@property (readwrite) BOOL planetView;
@property (readwrite) float altitude;
@property (readwrite) float azimuth;
@property (readonly) float fieldOfView;

-(GLfloat)zoomingValue;
- (id)initWithView:(GLView*)view;
- (void)adjustView;
- (void)rotateCameraWithX:(int)deltaX Y:(int)deltaY;
- (void)zoomCameraWithDelta:(int)delta centerX:(int)cx centerY:(int)cy;
- (void)zoomCameraWithX:(int)deltaX andY:(int)deltaY;
- (void)zoomCameraOut;
- (void)initiateHorizontalSwipeWithX:(int)theX;
- (void)initiateVerticalSwipeWithY:(int)theY;
- (void)reenable;
- (void)resetZoomValue;
//- (void)RAAndDecForPoint:(CGPoint)point;

-(float)calculateAzimuthWithX:(int)deltaX Y:(int)deltaY;
-(float)calculateAltitudeWithX:(int)deltaX Y:(int)deltaY;

- (void)doAnimations:(float)timeElapsed;

@end

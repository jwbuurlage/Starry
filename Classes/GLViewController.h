//
//  GLViewController.h
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
#import "GLView.h"

#import "SRCamera.h"
#import "SRRenderer.h"

@interface GLViewController : UIViewController <GLViewDelegate>
{
	SRCamera *camera;
	GLView *theView;
	SRRenderer *renderer;
	
	int lastTouchCount;
	int dTouch;
	GLfloat initialTouchDistance;
	GLfloat lastTouchDistance;
	CGPoint pinchCenter;
	
	BOOL UIClick;
	BOOL ScreenClick;
	
	int dX;
	int dY;
}

@property (assign) SRCamera *camera;
@property (readonly) GLView *theView;
@property (readonly) SRRenderer *renderer;

@end

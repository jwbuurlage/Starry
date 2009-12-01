//
//  GLViewController.m
//
//  A part of Sterren.app, planitarium iPhone application.
//  Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//  Use without premission by Mote of Life is not authorised.
//
//  Mote of Life is a registred company at the Dutch Chamber of Commerce.
//  Chamber of Commerce registration number: 37126951
//


#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"

@implementation GLViewController

@synthesize camera,theView,renderer;

- (void)drawView:(UIView *)theView
{
    glColor4f(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Drawing code here
	[renderer render];
}

-(void)setupView:(GLView*)view
{
	
	theView = view;
	theView.multipleTouchEnabled = YES;
	camera = [[SRCamera alloc] initWithView:view];
	renderer = [[SRRenderer alloc] setupWithOwner:self];
}

- (void)dealloc 
{
    [super dealloc];
}

/* Event handling. 
 * Swipe beweging -> Camera draait naar tegenovergestelde kant
 * Move beweging -> Camera beweegt met de vinger mee
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *aTouch = [touches anyObject];

	if([[renderer interface] UIElementAtPoint:[aTouch locationInView:theView]]) {
		UIClick = YES;
	}
	else {
		UIClick = NO;
	}
	
	//NSUInteger touchCount = [touches count];	
	//NSLog(@"touchesBegan count: %d", touchCount);
	//lastTouchCount = touchCount;
	dTouch = 1;
	
	//[camera registerInitialLocationWithX:[aTouch locationInView:theView].x y:[aTouch locationInView:theView].y]
	
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if(!UIClick) {
	NSUInteger touchCount = [touches count];
	dTouch++;
	//NSLog(@"touchesMoved count: %d lastTouchCount: %d dTouch: %d", touchCount, lastTouchCount, dTouch);
	
	
	/*if(dTouch < 5 && lastTouchCount == 1) 
		lastTouchCount = touchCount;
	else {
		if(touchCount != lastTouchCount)
			return;
	//}*/
	
	if(touchCount == 1) {
		UITouch *aTouch = [touches anyObject];
		
		int x, y;
		x = [aTouch locationInView:theView].x - [aTouch previousLocationInView:theView].x;
		y = [aTouch locationInView:theView].y - [aTouch previousLocationInView:theView].y;
		[camera rotateCameraWithX:x 
							Y:y];
		return;
	}
	else if(touchCount == 2) {
		NSArray *twoTouches = [touches allObjects];
		UITouch *firstTouch = [twoTouches objectAtIndex:0];
		UITouch *secondTouch = [twoTouches objectAtIndex:1];
		
		CGPoint firstPoint = [firstTouch locationInView:theView];
		CGPoint secondPoint = [secondTouch locationInView:theView];
		
		CGFloat smallestx;
		if (firstPoint.x < secondPoint.x) 
			smallestx = firstPoint.x;
		else 
			smallestx = secondPoint.x;
		
		CGFloat smallesty;
		if (firstPoint.y < secondPoint.y) 
			smallesty = firstPoint.y;
		else 
			smallesty = secondPoint.y;
		
		CGFloat dx = abs(firstPoint.x - secondPoint.x);
		CGFloat dy = abs(firstPoint.y - secondPoint.y);
		
		CGFloat touchDistance = sqrt(dx*dx + dy*dy);
		if (lastTouchCount != 2 || dTouch < 6) {
			initialTouchDistance = touchDistance;
			lastTouchDistance = touchDistance;
		}
		CGPoint touchCenter;
		touchCenter.x = smallestx+dx;
		touchCenter.y = smallesty+dy;
		
		CGFloat zoomDelta;
		
		//if (lastTouchCount == 2) {
			zoomDelta = lastTouchDistance - touchDistance;
		
			[camera zoomCameraWithDelta:zoomDelta
							  centerX:touchCenter.x
							  centerY: touchCenter.y];
		//}
		
		lastTouchDistance = touchDistance;
		
		//NSLog(@"Delta zoom %f", zoomDelta);
	
	}
	
	lastTouchCount = touchCount;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(UIClick) {
		[[renderer interface] touchEnded];	
	}
	else {
	UITouch *aTouch = [touches anyObject];
	int x, y;
	
	dTouch = 0; // zet delta touch terug naar nul
	
	//testen voor swipe
	x = [aTouch locationInView:theView].x - [aTouch previousLocationInView:theView].x;
	y = [aTouch locationInView:theView].y - [aTouch previousLocationInView:theView].y;
	
	if(x > 8 || x < -8) {
		//NSLog(@"swipe horizontal");
		[camera initiateHorizontalSwipeWithX:x];
	}
	else if(y > 8 || y < -8) {
		[camera initiateVerticalSwipeWithY:y];
	}
	else {
		//geen swipe, enkele touch?
		[camera RAAndDecForPoint:[aTouch previousLocationInView:theView]];
	}
	}
}

@end

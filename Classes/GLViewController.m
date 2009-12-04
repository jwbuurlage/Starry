//
//  GLViewController.m
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
		ScreenClick = NO;
	}
	else {
		UIClick = NO;
		ScreenClick = YES;
	}
	
	//NSUInteger touchCount = [touches count];	
	//NSLog(@"touchesBegan count: %d", touchCount);
	//lastTouchCount = touchCount;
	dTouch = 1;
	dX = 0;
	dY = 0;
	
	//[camera registerInitialLocationWithX:[aTouch locationInView:theView].x y:[aTouch locationInView:theView].y]
	
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	//if(!UIClick) {
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
		
		if (UIClick == NO) {
			[camera rotateCameraWithX:x 
							Y:y];
		}
		
		dX += x;
		dY += y;
		
		// Als er teveel wordt verschuift cancel de clicks
		if ( -15 < dX < 15 || -15 < dY < 15) {
			//NSLog(@"Click canceld");
			ScreenClick = NO;
			if(UIClick) {
				UIClick = NO;
				[[renderer interface] touchEndedAndExecute:NO];
			}
		}
		
		return;
	}
	else if(touchCount == 2 && UIClick == NO) {
		
		ScreenClick = NO;
		
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
	//}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSUInteger touchCount = [touches count]; // Voor kliken mag maar 1 touch gebruikt worden
	
	if(UIClick && touchCount == 1) {
		//NSLog(@"Clicked the interface");
		[[renderer interface] touchEndedAndExecute:YES];	
	}
	else if(ScreenClick && dTouch < 4 && touchCount == 1) { // Het scherm mag niet lang aangeraakt worden vandaar dTouch < 4
		UITouch *aTouch = [touches anyObject];
		int x = [aTouch locationInView:theView].x;
		int y = [aTouch locationInView:theView].y;
		
		// Aan de buitenste zeide is de destortion veel erger dan verder naar binnen.
		if (40 < y && y < 440 && 30 < x && x < 290) {
			
			// Tenopzichte van het midden uitrekenen iPhone screen (480*320)
			int dmX = -x+160;
			int dmY = -y+240;
			
			
			// Voor het testen zoom de camera daar heen
			//[camera rotateCameraWithX:dmX 
			//						Y:dmY];
			
			float readRADeg = fmod([camera calculateAzimuthWithY:dmY],360);
			if (readRADeg < 0) {
				readRADeg = readRADeg + 360;
			}
			float readDECDeg = fmod(90+[camera calculateAltitudeWithX:dmX],180);
			float readRARad = readRADeg * (M_PI/180);
			float readDECRad = (readDECDeg * (M_PI/180));
			//NSLog(@"RA/DEC punt RA:%f DEC:%f",azimuth,altitude);
			
			// Uit de php
			//$x = 20*sin($dec)*cos($ra);
			//$y = 20*sin($dec)*sin($ra);
			//$z = 20*cos($dec);
			//NSLog(@"Aangeklikt punt in graden RA:%f DEC:%f",readRADeg,readDECDeg);
			//NSLog(@"Aangeklikt punt in radialen RA:%f DEC:%f",readRARad,readDECRad);
			
			float brX = sin(readDECRad)*cos(readRARad);
			float brY = sin(readDECRad)*sin(readRARad);
			float brZ = cos(readDECRad);
			//NSLog(@"Aangeklikte locatie op bol x:%f y:%f z:%f",brX,brY,brZ);
			
			
			float rotationY = (90-[[renderer location] latitude])*(M_PI/180);
			float rotationZ1 = [[renderer location] longitude]*(M_PI/180);
			float rotationZ2 = [[[[renderer interface] timeModule] manager] elapsed]*(M_PI/180);
			//float rotationZ2 = rotationZ1 + rotationZ3;
			
			// voor goed voorbeeld: http://www.math.umn.edu/~nykamp/m2374/readings/matvecmultex/
			// wikipedia rotatie matrix: http://en.wikipedia.org/wiki/Rotation_matrix
			
			float maX,maY,maZ;
			
			// Matrix vermenigvuldiging met draai om de y-as (locatie)
			maX = (cos(rotationY)*brX+0*brY+sin(rotationY)*brZ);
			maY = (0*brX+1*brY+0*brZ);
			maZ = ((-sin(rotationY)*brX)+0*brY+cos(rotationY)*brZ);
			
			brX = maX;
			brY = maY;
			brZ = maZ;
			
			// Matrix vermenigvuldiging met draai om de  z-as (locatie)
			maX = (cos(rotationZ1)*brX+(-sin(rotationZ1)*brY)+0*brZ);
			maY = (sin(rotationZ1)*brX+cos(rotationZ1)*brY+0*brZ);
			maZ = (0*brX+0*brY+1*brZ);
			
			brX = maX;
			brY = maY;
			brZ = maZ;
			
			// Matrix vermenigvuldiging met draai om de  z-as (tijd)
			maX = (cos(rotationZ2)*brX+(-sin(rotationZ2)*brY)+0*brZ);
			maY = (sin(rotationZ2)*brX+cos(rotationZ2)*brY+0*brZ);
			maZ = (0*brX+0*brY+1*brZ);
			
			brX = maX;
			brY = maY;
			brZ = maZ;
			
			float stX,stY,stZ;
			stX = -20*brX;
			stY = -20*brY;
			stZ = -20*brZ;
			
			float alOm = acos(-brZ/sqrt(pow(-brX,2)+pow(-brY,2)+pow(-brZ,2)));
			float fiOm = atan2(-brY,-brX); // klopt niet? hoe kan deze 2 parm nemen?
			
			NSLog(@"RA/DEC punt RA:%f DEC:%f",alOm,fiOm);
			
			//NSLog(@"Aangeklikte locatie voor sterren database x:%f y:%f z:%f",stX,stY,stZ);
			
			if(stX < 1 &&
			   stX >= 0 &&
			   stY < 1 &&
			   stY >= 0 &&
			   stZ <= 20 &&
			   stZ > 19) {
					//Poolster aangeklikt
				if ([[[renderer interface] theNameplate] visible]) {
					[[[renderer interface] theNameplate] hide];
					// Iets van een timer
					//[[[renderer interface] theNameplate] setName:@"Polaris" inConstellation:@"Kleine beer" showInfo:NO];
					
				}
				else {
					[[[renderer interface] theNameplate] setName:@"Polaris" inConstellation:@"Kleine beer" showInfo:NO];
				}
			}
			
		}
		
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

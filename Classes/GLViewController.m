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
#import "SterrenAppDelegate.h"

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
		
		if(
		   ![renderer planetView]) {
		int x, y;
		x = [aTouch locationInView:theView].x - [aTouch previousLocationInView:theView].x;
		y = [aTouch locationInView:theView].y - [aTouch previousLocationInView:theView].y;
		
		if (UIClick == NO) {
			[camera rotateCameraWithX:x 
									Y:y];
		}
		
		dX += x;
		dY += y;
		}
		
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
	else if(ScreenClick && dTouch < 4 && touchCount == 1 && ![renderer planetView]) { // Het scherm mag niet lang aangeraakt worden vandaar dTouch < 4
		UITouch *aTouch = [touches anyObject];
		int x = [aTouch locationInView:theView].x;
		int y = [aTouch locationInView:theView].y;
		
		// Aan de buitenste zeide is de destortion veel erger dan verder naar binnen.
		//if (40 < y && y < 440 && 30 < x && x < 290) {
			
			//[objectManager clickedAtX:x Y:y];
			
			// Tenopzichte van het midden uitrekenen iPhone screen (480*320)
			int deltaX = -x+160;
			int deltaY = -y+240;
			
			
			// Voor het testen zoom de camera daar heen
			//[camera rotateCameraWithX:dmX 
			//						Y:dmY];
			
			/*float readDECDeg = fmod(90+[camera calculateAltitudeWithX:dmX Y:dmY],180);
			
			float readRADeg = fmod([camera calculateAzimuthWithX:dmX Y:dmY],360);
			if (readRADeg < 0) {
				readRADeg = readRADeg + 360;
			}
			
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
			NSLog(@"Aangeklikte locatie op bol x:%f y:%f z:%f",brX,brY,brZ);*/
		
		float fieldOfView = [camera fieldOfView];
		float altitude = [camera altitude];
		float azimuth = [camera azimuth];
		
		float standardHeight = cosf(0.5*(sqrtf(powf((fieldOfView*480)/320,2)+powf((fieldOfView*480)/320,2))));
		float radPerPixel = sinf(0.5*(sqrtf(powf((fieldOfView*480)/320,2)+powf((fieldOfView*480)/320,2))))/480;
		//float standardHeight = 0.8910065242;
		//float radPerPixel = (0.3*M_PI)/320;
		// Coordinaten in het vlak
		float fiX = deltaX * radPerPixel;
		float fiY = deltaY * radPerPixel;
		float fiZ = -standardHeight;
		// Bereken straal hulp-bol
		float dSphere1 = sqrtf(powf(fiX,2) + powf(fiY,2) + powf(fiZ,2));
		NSLog(@"fiX:%f y:%f z:%f rHulp-Bol:%f",fiX,fiY,fiZ,dSphere1);
		// Bereken coordinaten die de bol raken
		float coX = fiX / dSphere1;
		float coY = fiY / dSphere1;
		float coZ = fiZ / dSphere1;
		//float dSphere2 = sqrtf(powf(coX,2) + powf(coY,2) + powf(coZ,2));
		NSLog(@"coX:%f y:%f z:%f",coX,coY,coZ);
		
		float rotationY1 = (altitude-90)*(M_PI/180);
		float rotationZ = azimuth*(M_PI/180);
		
		float brX = coX;
		float brY = coY;
		float brZ = coZ;
		
		/*float brX = 0;
		 float brY = 0;
		 float brZ = -1;*/
		
		float maX,maY,maZ;
		
		maX = (cos(rotationY1)*brX+0*brY+sin(rotationY1)*brZ);
		maY = (0*brX+1*brY+0*brZ);
		maZ = ((-sin(rotationY1)*brX)+0*brY+cos(rotationY1)*brZ);
		
		brX = maX;
		brY = maY;
		brZ = maZ;
		
		maX = (cos(rotationZ)*brX+(-sin(rotationZ)*brY)+0*brZ);
		maY = (sin(rotationZ)*brX+cos(rotationZ)*brY+0*brZ);
		maZ = (0*brX+0*brY+1*brZ);
		
		brX = maX;
		brY = maY;
		brZ = maZ;
		
			
			
			float rotationY = (90-[[renderer location] latitude])*(M_PI/180);
			float rotationZ1 = [[renderer location] longitude]*(M_PI/180);
			float rotationZ2 = [[[[renderer interface] timeModule] manager] elapsed]*(M_PI/180);
			//float rotationZ2 = rotationZ1 + rotationZ3;
			
			// voor goed voorbeeld: http://www.math.umn.edu/~nykamp/m2374/readings/matvecmultex/
			// wikipedia rotatie matrix: http://en.wikipedia.org/wiki/Rotation_matrix
			
			//float maX,maY,maZ;
			
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
			
			float stX,stY,stZ,plX,plY,plZ;
			stX = -20*brX;
			stY = -20*brY;
			stZ = -20*brZ;
			
			plX = -15*brX;
			plY = -15*brY;
			plZ = -15*brZ;
			
			
			
			float zoomingValue = [camera zoomingValue];
			float xd,yd,zd,sunD,moonD;
			
			SRSun * sun = [[[[UIApplication sharedApplication] delegate] objectManager] sun];
			xd = sun.position.x-plX;
			yd = sun.position.y-plY;
			zd = sun.position.z-plZ;
			sunD = sqrt(xd*xd + yd*yd + zd*zd);
			
			if (sunD < (2 * (1/zoomingValue))) {
				[[[renderer interface] theNameplate] setName:NSLocalizedString(@"Sun", @"") inConstellation:NSLocalizedString(@"Our star", @"") showInfo:NO];
				[[renderer interface] setANameplate:TRUE];

//<<<<<<< HEAD:Classes/GLViewController.m
				Vertex3D position = sun.position;
				//Vertex3D position = Vector3DMake(sun.position.x, sun.position.y-0.2, sun.position.z);
//=======
				//Vertex3D position = ;
//				Vertex3D position = Vector3DMake(sun.position.x, sun.position.y, sun.position.z);
				
				[renderer setHighlightPosition:position];
				[renderer setSelectedStar:nil];
				[renderer setPlanetHighlighted:TRUE];
				[renderer setSelectedPlanet:sun];
				[renderer setHighlightSize:32]; 
				[renderer setHighlight:TRUE];
			}
			else {			
			SRMoon * moon = [[[[UIApplication sharedApplication] delegate] objectManager] moon];
			xd = moon.position.x-plX;
			yd = moon.position.y-plY;
			zd = moon.position.z-plZ;
			moonD = sqrt(xd*xd + yd*yd + zd*zd);
			
			if (moonD < (2 * (1/zoomingValue))) {
				[[[renderer interface] theNameplate] setName:NSLocalizedString(@"Moon", @"") inConstellation:@"" showInfo:NO];
				[[renderer interface] setANameplate:TRUE];

				//Vertex3D position = ;
				Vertex3D position = Vector3DMake(moon.position.x, moon.position.y, moon.position.z);
//>>>>>>> 5b467e71baa2e98bbb44915d597b1fbd5ff73140:Classes/GLViewController.m
				
				[renderer setHighlightPosition:position];
				[renderer setSelectedStar:nil];
				[renderer setPlanetHighlighted:FALSE];
				[renderer setSelectedPlanet:nil];
				[renderer setHighlightSize:32]; 
				[renderer setHighlight:TRUE];
			}
			else {
				float planetD,closestD;
				closestD = 15; // moet een hoge begin waarde hebben vanwege het steeds kleiner worden
				SRPlanetaryObject * planet;
				SRPlanetaryObject * closestPlanet;
				for(planet in [[[[UIApplication sharedApplication] delegate] objectManager] planets]) {
					
					
					// http://freespace.virgin.net/hugo.elias/routines/r_dist.htm
					xd = planet.position.x-plX;
					yd = planet.position.y-plY;
					zd = planet.position.z-plZ;
					planetD = sqrt(xd*xd + yd*yd + zd*zd);
					if (planetD < closestD) {
						closestD = planetD;
						closestPlanet = planet;
						//NSLog(@"Closest planet:%@",planet.name);
					}
				}
				if (closestD < (2 * (1/zoomingValue))) {
//<<<<<<< HEAD:Classes/GLViewController.m
					//NSLog(@"Delta of closest: %f",closestD);

//=======
					[[[renderer interface] theNameplate] setSelectedType:1];					
					[[[renderer interface] theNameplate] setName:closestPlanet.name inConstellation:NSLocalizedString(@"planet", @"") showInfo:YES];
//>>>>>>> 432905627afb0f19ea3c87fa64b8b3ac63459d04:Classes/GLViewController.m
					[[renderer interface] setANameplate:TRUE];
					
					[[[renderer interface] planetInfo] planetClicked:closestPlanet];

					Vertex3D position = closestPlanet.position;
					
					[renderer setHighlightPosition:position];
					[renderer setSelectedStar:nil];
					[renderer setPlanetHighlighted:TRUE];
					[renderer setSelectedPlanet:closestPlanet];
					[renderer setHighlightSize:32]; 
					[renderer setHighlight:TRUE];
				}
				else {
					float messierD;
					closestD = 18; // moet een hoge begin waarde hebben vanwege het steeds kleiner worden
					SRMessier * aMessier;
					SRMessier * closestMessier;
					for(aMessier in [[[[UIApplication sharedApplication] delegate] objectManager] messier]) {	
						xd = aMessier.position.x-plX;
						yd = aMessier.position.y-plY;
						zd = aMessier.position.z-plZ;
						messierD = sqrt(xd*xd + yd*yd + zd*zd);
						if (messierD < closestD) {
							closestD = messierD;
							//NSLog(@"closestD: %f", closestD);
							closestMessier = aMessier;
							//NSLog(@"Closest messier:%@",closestMessier.name);
						}						
					}
					//FIXME waarom zo'n raar getal?
					if(closestD < (5.1)) {
						[[[renderer interface] theNameplate] setSelectedType:0];
						[[[renderer interface] theNameplate] setName:closestMessier.name inConstellation:NSLocalizedString(@"messier", @"") showInfo:YES];
						[[renderer interface] setANameplate:TRUE];

						[[[renderer interface] messierInfo] messierClicked:closestMessier];
						
						// Screen location test
						Vertex3D posTmp = [closestMessier myCurrentPosition];
						// Gaat alleen om de log in de method
						

						
						Vertex3D position = closestMessier.position;
						
						[renderer setHighlightPosition:position];
						[renderer setSelectedStar:nil];
						[renderer setPlanetHighlighted:FALSE];
						[renderer setSelectedPlanet:nil];
						[renderer setHighlightSize:32]; 
						[renderer setHighlight:TRUE];
						

					}
					else {
					
					SRStar * star;
					SRStar * closestStar;
					float starD;
					closestD = 20; // moet een hoge begin waarde hebben vanwege het steeds kleiner worden
					
					for(star in [[[[UIApplication sharedApplication] delegate] objectManager] stars]) {
						
						
						// http://freespace.virgin.net/hugo.elias/routines/r_dist.htm
						xd = [[star x] floatValue]-stX;
						yd = [[star y] floatValue]-stY;
						zd = [[star z] floatValue]-stZ;
						starD = sqrt(xd*xd + yd*yd + zd*zd);
						
						if ([star visibleWithZoom:zoomingValue]) {
							if (starD < closestD) {
								
								closestD = starD;
								closestStar = star;
								
							}
							
						}
						
					}
					
					if (closestD < (1.5 * (1/zoomingValue))) {
						//NSLog(@"Delta of closest: %f",closestD);
						[[[renderer interface] theNameplate] setSelectedType:2];
						/*if (closestStar.name == @"" || closestStar.name == @" ") {
							[[[renderer interface] theNameplate] setName:NSLocalizedString(@"Nameless star", @"") inConstellation:closestStar.bayer showInfo:YES];
						}*/
						//else {
							[[[renderer interface] theNameplate] setName:NSLocalizedString(closestStar.name, @"") inConstellation:closestStar.bayer showInfo:YES];
						//}
						[[renderer interface] setANameplate:TRUE];
						[[[renderer interface] starInfo] starClicked:closestStar];
						
						
						Vertex3D position = Vector3DMake([closestStar.x floatValue], [closestStar.y floatValue], [closestStar.z floatValue]);
						
						[renderer setHighlightPosition:position];
						[renderer setSelectedStar:closestStar];
						[renderer setPlanetHighlighted:FALSE];
						[renderer setSelectedPlanet:nil];
						[renderer setHighlightSize:32]; 
						[renderer setHighlight:TRUE];
						
						// CPU intensieve method
						// Dit moet anders bijvoorbeeld met een selector texture op de x,y,z locatie in de renderer
						/*SRStar * ster;
						 for (ster in [[[[UIApplication sharedApplication] delegate] objectManager] stars]) {
						 ster.selected = NO;
						 }
						 closestStar.selected = YES;
						 [[[[UIApplication sharedApplication] delegate] objectManager] buildStarData];
						 [renderer loadStarPoints];*/
					}
					else {
						if ([[[renderer interface] theNameplate] visible]) {
							
							[renderer setHighlight:FALSE];
							[[[renderer interface] theNameplate] hide];
							[[renderer interface] setANameplate:TRUE];
							/*SRStar * ster;
							 for (ster in [[[[UIApplication sharedApplication] delegate] objectManager] stars]) {
							 ster.selected = NO;
							 }
							 [[[[UIApplication sharedApplication] delegate] objectManager] buildStarData];
							 [renderer loadStarPoints];*/
							
							
						}
					}
					}
					
				}
					
				}	
			//}
			
			
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
			//[camera RAAndDecForPoint:[aTouch previousLocationInView:theView]];
		}
	}
}

@end
//
//  SRCamera.m
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


#import "SRCamera.h"


@implementation SRCamera

- (id)initWithView:(GLView*)view
{
	if(self = [super init]) {
		altitude = 15.0f;
		azimuth = 0.0f;
		sphereRadius = 3.0f;
		deacco = 0.05f;
		
		zoomingValue = 1;
		
		glMatrixMode(GL_PROJECTION); 
		const GLfloat zNear = 0.01, zFar = 1000.0;
		fieldOfView = 0.3 * M_PI; 
		size = zNear * tanf(fieldOfView / 2.0); 
		rect = view.bounds; 
		glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
				   (rect.size.width / rect.size.height), zNear, zFar); 
		glViewport(0, 0, rect.size.width, rect.size.height);  
		
		//NSLog(@"size: %f, width: %f, height:%f", size, rect.size.width, rect.size.height);
	}
	
	return self;
}

- (void)adjustView {
	if(swipeHor) {
		//afremmen in 50 stappen
		if(hSteps == 0) { hSteps = 50; }
		
		hSpeed = accH * hSteps * 0.005;
		altitude -= hSpeed / (4/fieldOfView); // voor het zomen is de / (4/fieldOfView) nodig
		
		--hSteps;
		if(hSteps == 0) {
			swipeHor = FALSE;
		}
		
		//NSLog(@"%i", hSteps);
	}
	if(swipeVer) {
		if(vSteps == 0) { vSteps = 50; }
		
		vSpeed = accV * vSteps * 0.005;
		azimuth += vSpeed / (4/fieldOfView); // voor het zomen is de / (4/fieldOfView) nodig
		
		--vSteps;
		if(vSteps == 0) {
			swipeVer = FALSE;
		}
	}
		
	if(altitude > 90) { altitude = 90; }
	else if (altitude < -90) { altitude = -90; }
	
	glRotatef(-altitude, 0.0f, 1.0f, 0.0f);
	glRotatef(-azimuth, 0.0f, 0.0f, 1.0f);
	//NSLog(@"%f ",altitude);
}

- (void)rotateCameraWithX:(int)deltaX Y:(int)deltaY {
	
	float rotationConstant = 5.5850536;
	// Berekening het scherm is 320 pixels hoog. fieldOfView is normaal 0.3*PI.
	// 0.3PI * 180 / PI = 54 dus de complete verticale hoek in beeld is altijd 54.
	// De bereking is deltaX/constante/fieldOfView=altitude
	// 54=320/(x/0.3PI) => x=5.5850536
	
	if(swipeHor) {
		swipeHor = FALSE;
		accH = 0;
	}
	if(swipeVer) {
		swipeVer = FALSE;
		accV = 0;
	}
	float deltaAzimuth = deltaY / (rotationConstant/fieldOfView);
	float deltaAltitude = -deltaX / (rotationConstant/fieldOfView);
	azimuth += deltaAzimuth;
	azimuth = fmod(azimuth, 360); // Modulo 360
	altitude += deltaAltitude;
	//NSLog(@"Rotate Camera With X:%i Y:%i dAz:%f dAl:%f az:%f al:%f fov:%f",deltaX,deltaY,deltaAzimuth,deltaAltitude,azimuth,altitude,fieldOfView);
}

// Berekeningen voor camera locatie

-(float)calculateAzimuthWithY:(int)deltaY {
	float deltaAzimuth = deltaY / (5.5850536/fieldOfView);
	float result = fmod((azimuth + deltaAzimuth), 360);
	return result;
}

-(float)calculateAltitudeWithX:(int)deltaX {
	float deltaAltitude = -deltaX / (5.5850536/fieldOfView);
	float result = altitude + deltaAltitude;
	return result;

}



- (void)initiateHorizontalSwipeWithX:(int)theX {
	swipeHor = YES;
	accH = theX;
}

- (void)initiateVerticalSwipeWithY:(int)theY {
	swipeVer = YES;
	accV = theY;
}

- (void)zoomCameraWithDelta:(int)delta centerX:(int)cx centerY:(int)cy {

	//NSLog(@"Zooming");
		
	if(delta > 0)
		zoomingValue = 1 + 0.003 * delta;
	else if (delta < 0)
		zoomingValue = 1 - 0.003 * -delta;
	else 
		zoomingValue = 1;
	
	GLfloat newFieldofView;
	if (zoomingValue > 0) {
		
		newFieldofView = fieldOfView * zoomingValue;
		if(newFieldofView > 0.3 && newFieldofView < 1.0) {
			fieldOfView = newFieldofView;
		}
		//NSLog(@"field of view: %f zoomingvalue : %f delta : %i",fieldOfView,zoomingValue,delta);
	}
	else {
		//NSLog(@"zooming value negative");
	}
}

-(GLfloat)zoomingValue {
	float value = (0.3 * M_PI) / fieldOfView;
	return value; //moet nog gefixt worden, doet nu in wel hele grove stappen
	//return 1;
}

-(void)reenable {
	const GLfloat zNear = 0.01, zFar = 1000.0;
	glMatrixMode(GL_PROJECTION); 
	glLoadIdentity();
	size = zNear * tanf(fieldOfView / 2.0); 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar);
	
	//NSLog(@"size: %f, width: %f, height:%f", size, rect.size.width, rect.size.height);
	
	glViewport(0, 0, rect.size.width, rect.size.height);  
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();	
}

- (void)RAAndDecForPoint:(CGPoint)point {
	//test
	float RA = ( ((point.y - 240) / 240) * (fieldOfView * (180/M_PI) ) ) + azimuth;

}

@end

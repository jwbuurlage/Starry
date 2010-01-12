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

@synthesize azimuth, altitude, planetView, fieldOfView;

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
		//NSLog(@"width:%f height:%f",rect.size.width ,rect.size.height);
		//glOrthof( 0, 320, 480, 0, 1, 0 );
		glViewport(0, 0, rect.size.width, rect.size.height);  
		
		//NSLog(@"size: %f, width: %f, height:%f", size, rect.size.width, rect.size.height);
	}
	
	return self;
}

- (void)doAnimations:(float)timeElapsed {
	//if(swipeHor && swipeVer) { NSLog(@"test"); }
	
	if(swipeHor) {
		if(hSteps == 0) { hSteps = 20; }
		hSteps -= (timeElapsed / 0.075);
		hSpeed = accH * 0.020 * hSteps;
		altitude -= hSpeed / (4/fieldOfView); // voor het zomen is de / (4/fieldOfView) nodig
		
		if(hSteps <= 0.0) {
			swipeHor = FALSE;
			hSteps = 0;
		}
	}
	if(swipeVer) {
		if(vSteps == 0) { vSteps = 20; }
		vSteps -= (timeElapsed / 0.075);
		vSpeed = accV * vSteps * 0.020;
		azimuth += vSpeed / (4/fieldOfView); // voor het zomen is de / (4/fieldOfView) nodig
		
		if(vSteps <= 0.0) {
			swipeVer = FALSE;
			vSteps = 0;
		}
	}
	if(tapZoom) {
		if(tSteps == 0) { tSteps = 30; }
		
	 
	 //NSLog(@"deltax:%i deltay:%i",deltaX,deltaY);
	 
	 float DEC3 = (altitude-90)*(M_PI/180);
	 float RA3 = azimuth*(M_PI/180);
	 
	 float standardHeight = cosf(0.5*(sqrtf(powf((fieldOfView*480)/320,2)+powf((fieldOfView*480)/320,2))));
	 float radPerPixel = sinf(0.5*(sqrtf(powf((fieldOfView*480)/320,2)+powf((fieldOfView*480)/320,2))))/(320+(fieldOfView*160));
	 
	 float X1 = zoomDeltaX * radPerPixel;
	 float Y1 = zoomDeltaY * radPerPixel;
	 float Z1 = -standardHeight;
	 
	 float dSphere1 = sqrtf(powf(X1,2) + powf(Y1,2) + powf(Z1,2));
	 
	 float X2 = X1 / dSphere1;
	 float Y2 = Y1 / dSphere1;
	 float Z2 = Z1 / dSphere1;
	 
	 float X6 = cosf(DEC3)*X2+sinf(DEC3)*Z2;
	 float Y6 = Y2;
	 float Z6 = -sinf(DEC3)*X2+cosf(DEC3)*Z2;
	 
	 X2 = X6;
	 Y2 = Y6;
	 Z2 = Z6;
	 
	 X6 = cosf(RA3)*X2-sinf(RA3)*Y2;
	 Y6= sinf(RA3)*X2+cosf(RA3)*Y2;
	 Z6 = Z2;
	 
	 float RA1 = atan2f(Y6,X6);
	 float DEC1 = acosf(Z6);
	 
	 float newFieldOfView = fieldOfView - (0.3/30);
	 float newStandardHeight = cosf(0.5*(sqrtf(powf((newFieldOfView*480)/320,2)+powf((newFieldOfView*480)/320,2))));
	 float newRadPerPixel = sinf(0.5*(sqrtf(powf((newFieldOfView*480)/320,2)+powf((newFieldOfView*480)/320,2))))/(320+(newFieldOfView*160));
	 
	 float X3 = zoomDeltaX * newRadPerPixel;
	 float Y3 = zoomDeltaY * newRadPerPixel;
	 float Z3 = -newStandardHeight;
	 
	 float dSphere2 = sqrtf(powf(X3,2) + powf(Y3,2) + powf(Z3,2));
	 
	 float X4 = X3 / dSphere2;
	 float Y4 = Y3 / dSphere2;
	 float Z4 = Z3 / dSphere2;
	 
	 float X5 = cosf(DEC3)*X4+sinf(DEC3)*Z4;
	 float Y5 = Y4;
	 float Z5 = -sinf(DEC3)*X4+cosf(DEC3)*Z4;
	 
	 X4 = X5;
	 Y4 = Y5;
	 Z4 = Z5;
	 
	 X5 = cosf(RA3)*X4-sinf(RA3)*Y4;
	 Y5 = sinf(RA3)*X4+cosf(RA3)*Y4;
	 Z5 = Z4;
	 
	 float RA2 = atan2f(Y5,X5);
	 float DEC2 = acosf(Z5);
	 
	
	float deltaRA = RA1 - RA2;
	float deltaDEC = DEC1 - DEC2;
		if(newFieldOfView > 0.1) {
			azimuth += (deltaRA)*(180/M_PI);
			altitude += (deltaDEC)*(180/M_PI);
	
			//NSLog(@"ra:%f dec:%f RA1:%f RA2:%f DEC1:%f DEC2:%f",azimuth,altitude,RA1,-RA2,DEC1,-DEC2);
	
			fieldOfView = newFieldOfView;
		}
		
		--tSteps;
		if(tSteps == 0) {
			tapZoom = FALSE;
		}
	}
	
}

- (void)adjustView {		
	if(altitude > 89.9) { altitude = 89.9; }
	else if (altitude < -89.9) { altitude = -89.9; }
	if(azimuth < 0) { azimuth += 360; }
	if(azimuth > 360) { fmod(azimuth, 360); }
	
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
	float deltaAzimuth,deltaAltitude;
		//deltaAzimuth = deltaY / (rotationConstant/fieldOfView) - (azimuth/360)*(-abs(deltaX) / (rotationConstant/fieldOfView));
		//deltaAltitude = (-deltaX / (rotationConstant/fieldOfView)) - (altitude/180)*(abs(deltaY) / (rotationConstant/fieldOfView));
	deltaAzimuth = deltaY / (rotationConstant/fieldOfView);
	deltaAltitude = (-deltaX / (rotationConstant/fieldOfView));
		azimuth += (deltaAzimuth*1.2);
		azimuth = fmod(azimuth, 360); // Modulo 360
		altitude += (deltaAltitude*1.2);
	//NSLog(@"Rotate Camera With X:%i Y:%i dAz:%f dAl:%f az:%f al:%f fov:%f",deltaX,deltaY,deltaAzimuth,deltaAltitude,azimuth,altitude,fieldOfView);
}

// Berekeningen voor camera locatie

-(float)calculateAzimuthWithX:(int)deltaX Y:(int)deltaY {
	
	//NSLog(@"brX:%f y:%f z:%f",brX,brY,brZ);
	
	float rotationConstant = 5.5850536;
	/*float adjustment = (altitude/180)*(-abs(deltaX) / (rotationConstant/fieldOfView));
	float deltaAzimuth = deltaY / (rotationConstant/fieldOfView) + 1*adjustment;
	
	float result,resultAdjustment1,resultAdjustment2;
	resultAdjustment1 = pow(1.4,7*altitude/180)-1.197;
	resultAdjustment2 = 0;*/
	/*if(adjustment/2 > 1)
		result = fmod(azimuth + deltaAzimuth*(adjustment/2), 360);
	else*/
		//result = fmod(azimuth + deltaAzimuth*(1+resultAdjustment1+resultAdjustment2),360);
	float result = azimuth + ( deltaY / (rotationConstant/fieldOfView));
	
	//NSLog(@"Calculate azimuthFromX:%i andY:%i origiginal:%f delta:%f new:%f resultadjust1:%f resultadjust2:%f result:%f",deltaX,deltaY,deltaY / (rotationConstant/fieldOfView) ,adjustment,deltaAzimuth,resultAdjustment1,resultAdjustment2, result);
	/*
	if (deltaAzimuth > 0)
		result = fmod((azimuth + pow(abs(deltaAzimuth),1.01)), 360);
	else 
		result = fmod((azimuth - pow(abs(deltaAzimuth),1.01)), 360);
	 */
	return result;
}

-(float)calculateAltitudeWithX:(int)deltaX Y:(int)deltaY {
	float rotationConstant = 5.5850536;
	//float adjustment = (azimuth/360)*(abs(deltaY) / (rotationConstant/fieldOfView));
	/*float adjustment = 0;
	float deltaAltitude = (-deltaX / (rotationConstant/fieldOfView)) - 1*adjustment;
	
	float result,resultAdjustment1,resultAdjustment2;*/
	/*if(adjustment/2 > 1)
		result = altitude + deltaAltitude*(adjustment/2);
	else*/
	//resultAdjustment1 = 0;
	//resultAdjustment2 = 0;
		//result = altitude + deltaAltitude*(1+resultAdjustment1+resultAdjustment2);
	float result = altitude + ( -deltaX / (rotationConstant/fieldOfView) );
	//NSLog(@"Calculate altitudeFromX:%i andY:%i origiginal:%f delta:%f new:%f resultadust1:%f resultadjust2:%f",deltaX,deltaY,(-deltaX / (rotationConstant/fieldOfView)),adjustment,deltaAltitude,resultAdjustment1,resultAdjustment2);
	/*if(deltaAltitude > 0) 
		result = altitude + abs(deltaAltitude),1.01);
	else 
		result = altitude - pow(abs(deltaAltitude),1.01);*/
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
		zoomingValue = 1 + 0.0075 * delta;
	else if (delta < 0)
		zoomingValue = 1 - 0.0075 * -delta;
	else 
		zoomingValue = 1;
	
	GLfloat newFieldofView;
	if (zoomingValue > 0) {
		
		newFieldofView = fieldOfView * zoomingValue;
		if(!planetView) {
			if(newFieldofView > 0.1 && newFieldofView < 1.0) {
				fieldOfView = newFieldofView;
			}
		}
		else {
			if(newFieldofView > 0.2 && newFieldofView < 2.4) {
				fieldOfView = newFieldofView;
			}
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

-(void)zoomCameraWithX:(int)deltaX andY:(int)deltaY {
	
	
	tapZoom = TRUE;
	zoomDeltaX = deltaX;
	zoomDeltaY = deltaY;
	
	
	
}

/*- (void)RAAndDecForPoint:(CGPoint)point {
	//test
	float RA = ( ((point.y - 240) / 240) * (fieldOfView * (180/M_PI) ) ) + azimuth;

}*/

-(void)resetZoomValue {
	fieldOfView = 0.3 * M_PI;
}

@end

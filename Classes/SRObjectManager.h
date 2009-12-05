//
//  SRObjectManager.h
//  Sterren
//
//  Created by Thijs Scheepers on 05-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLView.h"
#import "OpenGLCommon.h"
#import "SRPlanetaryObject.h"
#import "SRSun.h"
#import "SRCamera.h"
#import "SRStar.h"
#import "SRConstellation.h"
#import "SRInterface.h"
#import "SRLocation.h"


@interface SRObjectManager : NSObject {
	GLfloat planetPoints[56];
	int planetNum;
	//GLfloat stringPoints[56];
	//GLfloat starPoints[15000];
	//GLfloat constellationPoints[15000];
	/*
	int starNum;
	int constellationNum;
	
	//lichamen
	
	SRPlanetaryObject *mercury;
	SRPlanetaryObject *venus;
	SRPlanetaryObject *earth;
	SRPlanetaryObject *mars;
	SRPlanetaryObject *jupiter;
	SRPlanetaryObject *saturn;
	SRPlanetaryObject *uranus;
	SRPlanetaryObject *neptune;*/
	
	SRSun* sun;
	NSMutableArray * planets;
	NSMutableArray * stars;
	NSMutableArray * constellations;
	
	id *appDelegate;
}

@property (nonatomic, retain) NSMutableArray *stars;
@property (nonatomic, retain) NSMutableArray *constellations;

@property (readonly) GLfloat* planetPoints;
@property (readonly) int planetNum;
//@property (readonly) GLfloat planetPoints;

-(id)init;
-(void)parseData;
-(void)buildPlanetData;

@end

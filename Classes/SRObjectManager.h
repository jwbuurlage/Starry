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
#import "SRMoon.h"
#import "SRConstellation.h"
#import "SRInterface.h"
#import "SRLocation.h"


@interface SRObjectManager : NSObject {
	NSMutableArray * planetPoints;
	int planetNum;
	
	NSMutableArray * starPoints;
	int starNum;
	
	NSMutableArray * constellationPoints;
	int constellationNum;
	
	SRSun* sun;
	SRMoon* moon;
	NSMutableArray * planets;
	NSMutableArray * stars;
	NSMutableArray * constellations;
	
	//float brightnessFactor;
	//float zoomFactor;
	
	//id *appDelegate;
}

@property (nonatomic, retain) NSMutableArray *stars;
@property (nonatomic, retain) NSMutableArray *constellations;
@property (readonly) NSMutableArray *planets;
@property (readonly) SRSun *sun;
@property (readonly) SRMoon *moon;

@property (readonly) NSMutableArray *planetPoints;
@property (readonly) int planetNum;
@property (readonly) NSMutableArray *starPoints;
@property (readonly) int starNum;
@property (readonly) NSMutableArray *constellationPoints;
@property (readonly) int constellationNum;

//@property (readonly) GLfloat planetPoints;

-(id)init;
-(void)parseData;
-(void)buildPlanetData;
-(void)buildStarData;
-(void)buildConstellationData;
//-(NSMutableArray*)planetPoints;

@end

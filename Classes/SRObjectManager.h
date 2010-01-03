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
#import "SRMessier.h"
#import "SRMoon.h"
#import "SRConstellation.h"
#import "SRInterface.h"
#import "SRLocation.h"


@interface SRObjectManager : NSObject {
	NSMutableArray * planets;
	NSMutableArray * planetPoints;
	int planetNum;
	SRSun* sun;
	SRMoon* moon;
	
	NSMutableArray * stars;
	NSMutableArray * starPoints;
	int starNum;
	NSMutableArray* starSizeNum;
	
	NSMutableArray * constellations;
	NSMutableArray * constellationPoints;
	int constellationNum;
	
	NSMutableArray * messier;
	NSMutableArray * messierPoints;
	int messierNum;
	
}

@property (readonly) NSMutableArray *planets;
@property (readonly) NSMutableArray *planetPoints;
@property (readonly) int planetNum;
@property (readonly) SRSun *sun;
@property (readonly) SRMoon *moon;

@property (nonatomic, retain) NSMutableArray *stars;
@property (readonly) NSMutableArray *starPoints;
@property (readonly) NSMutableArray *starSizeNum;
@property (readonly) int starNum;

@property (nonatomic, retain) NSMutableArray *constellations;
@property (readonly) NSMutableArray *constellationPoints;
@property (readonly) int constellationNum;

@property (nonatomic, retain) NSMutableArray *messier;
@property (readonly) NSMutableArray * messierPoints;
@property (readonly) int messierNum;


-(id)init;
-(void)parseData;
-(void)buildPlanetData;
-(void)buildStarData;
-(void)buildMessierData;

@end

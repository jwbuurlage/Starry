//
//  SRRenderer.h
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
#import "SRPlanetaryObject.h"
#import "SRSun.h"
#import "SRCamera.h"
#import "SRStar.h"
#import "SRConstellation.h"
#import "SterrenAppDelegate.h"
#import "SRInterface.h"
#import "SRLocation.h"
#import "SRObjectManager.h"
#import "SRHUD.h"

@class GLViewController;

@interface SRRenderer : NSObject {
	SRCamera* camera;
	SRInterface* interface;
	SRLocation* location;
	SterrenAppDelegate *appDelegate;
	SRObjectManager *objectManager;
	GLViewController *myOwner;
	 	
	SRStar * selectedStar;
	SRPlanetaryObject * selectedPlanet;
		
	GLfloat planetPoints[64];
	GLfloat stringPoints[56];
	GLfloat starPoints[120000];
	NSMutableArray* starSizeNum;
	GLfloat constellationPoints[15000];
	GLfloat messierPoints[1500];
	int planetNum;
	int messierNum;
	int starNum;
	int constellationNum;
	
	GLuint textures[21];
	NSMutableArray* textTest;
	
	//highlight
	BOOL highlight;
	BOOL planetHighlighted;
	Vertex3D highlightPosition;
	id objectInFocus;
	float highlightSize;
	
	SRHUD* sharedHUD;
	
	Texture2D* testTexture3D;
	
	BOOL planetView;
	BOOL drawPlanetLabels;
	
	NSTimeInterval lastDrawTime;
	float timeElapsed;
}

@property (readonly) SRInterface* interface;
@property (readonly) SRLocation* location;
@property (readonly) GLViewController* myOwner;
@property (readonly) SRCamera* camera;
@property (assign) BOOL highlight;
@property (assign) BOOL planetHighlighted;
@property (assign) id objectInFocus;
@property (assign) SRStar* selectedStar;
@property (assign) SRPlanetaryObject* selectedPlanet;
@property (assign) BOOL planetView;
@property (assign) Vertex3D highlightPosition;
@property (assign) float highlightSize;

-(id)setupWithOwner:(GLViewController*)theOwner;
-(void)render;
-(void)drawStars;
-(void)drawMessier;
-(void)drawHighlight;
-(void)drawConstellations;
-(void)drawPlanets;
-(void)drawHorizon;
-(void)drawCompass;
-(void)drawEcliptic;

-(void)loadOrbits;
-(void)adjustViewToLocationAndTime:(BOOL)status;
-(void)loadStarPoints;
-(void)loadPlanetPoints;
-(void)loadMessier;

@end
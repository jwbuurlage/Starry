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
#import "SterrenAppDelegate.h"
#import "SRInterface.h"
#import "SRLocation.h"

@class GLViewController;

@interface SRRenderer : NSObject {
	SRCamera* camera;
	SRInterface* interface;
	SRLocation* location;
	SterrenAppDelegate *appDelegate;
	GLViewController *myOwner;
	
	//lichamen
	SRSun* sun;
	SRPlanetaryObject *mercury;
	SRPlanetaryObject *venus;
	SRPlanetaryObject *earth;
	SRPlanetaryObject *mars;
	SRPlanetaryObject *jupiter;
	SRPlanetaryObject *saturn;
	SRPlanetaryObject *uranus;
	SRPlanetaryObject *neptune;

	//sphere:
	Vertex3D    *sphereTriangleStripVertices;
    Vector3D    *sphereTriangleStripNormals;
    GLuint      sphereTriangleStripVertexCount;
    
    Vertex3D    *sphereTriangleFanVertices;
    Vector3D    *sphereTriangleFanNormals;
    GLuint      sphereTriangleFanVertexCount;
	
	GLfloat planetPoints[56];
	GLfloat starPoints[15000];
	int planetNum;
	int starNum;
	
	GLuint textures[16];

	float zoomFactor;
	float brightnessFactor;
}

@property (readonly) SRInterface* interface;
@property (readonly) SRLocation* location;
@property (readonly) GLViewController* myOwner;

-(id)setupWithOwner:(GLViewController*)theOwner;
-(void)render;
-(void)drawStars;
-(void)drawPlanets;
-(void)drawHorizon;
-(void)drawCompass;
-(void)drawEcliptic;
-(SRCamera*)camera;
-(void)recalculatePlanetaryPositions;
-(void)brightnessChanged;



@end

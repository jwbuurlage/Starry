//
//  SRPlanetaryObject.h
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


/* gegevens: http://ssd.jpl.nasa.gov/txt/aprx_pos_planets.pdf
 *
 * a = lengte lange as
 * e = eccentriciteit van de baan
 * I = inclinatie t.o.v. de ecliptica
 * L = gemiddelde longtitude
 * w = longtitude van de perhelion (tw = w - O)
 * O = longtitude van het snijpunt van de baan met het ecliptisch vlak
 *
 */

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"
#import "Texture2D.h"

@interface SRPlanetaryObject : NSObject {
	//baan informatie
	float a,e,i,w,o,Mo;
	//float x,y,z;
	BOOL selected;
	
	//object informatie
	NSString* name;
	
	Vertex3D position;
	Vertex3D positionHelio;
	Texture2D* nameTexture;
}

@property (readonly) Vertex3D position;
@property (readonly) Vertex3D positionHelio;
@property (readonly) float a;
@property (readonly) NSString* name;
@property (readwrite) BOOL selected;

-(id)initWitha:(float)ia		
			 e:(float)ie		
			 i:(float)ii
			 w:(float)iw
			 o:(float)iO
			Mo:(float)iMo
		  name:(NSString*)iName;

-(void)recalculatePosition:(NSDate*)theDate;
-(void)setViewOrigin:(Vertex3D)origin;
-(Vertex3D)myCurrentPosition;
-(void)drawHelio:(BOOL)helio;
-(Vertex3D)heliocentricPosition:(NSDate*)theDate;

//getters
/*
-(Vertex3D)position;
-(float)azimuth;
-(float)altitude;
-(GLuint)texture;
*/

@end

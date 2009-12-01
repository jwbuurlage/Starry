//
//  SRSun.h
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
#import "SRPlanetaryObject.h"

@interface SRSun : SRPlanetaryObject {

}

-(id)initWithEarth:(SRPlanetaryObject*)earth;

@end

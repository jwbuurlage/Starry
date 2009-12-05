//
//	SRStar.m
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

#import "SRStar.h"

@implementation SRStar

@synthesize name,bayer,x,y,z,mag,starID,ci,selected;

- (void) dealloc {
	[name release];
	[bayer release];
	[x release];
	[y release];
	[z release];
	[mag release];
	[ci release];
	//[starID release];
	[super dealloc];
}

@end
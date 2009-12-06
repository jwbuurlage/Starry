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
#import "SRSettingsManager.h"
#import "SterrenAppDelegate.h"

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

-(BOOL)visibleWithZoom:(float)zoomf {
	float size = [self size];
	id appDelegate = [[UIApplication sharedApplication] delegate]; 
	//float zoomf = [[[[appDelegate glView] delegate] camera] zoomingValue]; 
	float brightnessf = [[appDelegate settingsManager] brightnessFactor]; 
	//NSLog(@"Star visible:%f",zoomf * brightnessf * size);
	if ((zoomf * brightnessf * size) >= 1) {
		return YES;
	}
	else {
		return NO;
	}
}

-(float)size {
	float size;
	if([mag floatValue] < 1) {
		size = 4.0;
	}
	else if([mag floatValue] < 2) {
		size = 3.5;
	}
	else if([mag floatValue] < 3) {
		size = 2.5;
	}
	else if([mag floatValue] < 4) {
		size = 2.0;
	}
	else {
		size = 0.9;
	}
	return size;
}

-(float)alpha {
	float alpha;
	if([mag floatValue] < 1) {
		alpha = 1.0;
	}
	else if([mag floatValue] < 2) {
		alpha = 0.7;
	}
	else if([mag floatValue] < 3) {
		alpha = 0.6;
	}
	else if([mag floatValue] < 4) {
		alpha = 0.5;
	}
	else {
		alpha = 0.4;
	}
	return alpha;
}

@end
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
		size = 6.0;
	}
	else if([mag floatValue] < 2) {
		size = 5.0;
	}
	else if([mag floatValue] < 3) {
		size = 3.5;
	}
	else if([mag floatValue] < 4) {
		size = 2.0;
	}
	else {
		size = 0.9;
	}
	return size;
}

-(StarColor)color {
	//http://en.wikipedia.org/wiki/Color_index
	//http://domeofthesky.com/clicks/bv.html
	//color index: lager: blauwer, hoger: roder
	StarColor color;
	if([ci floatValue] > 1.2) {
		//rood
		color = StarColorMake(1.0f, 0.7f, 0.7f, [self alpha]);
	}
	else if([ci floatValue] > 0.7) {
		//oranje
		color = StarColorMake(1.0, 0.8f, 0.7f, [self alpha]);
	}
	else if([ci floatValue] > 0.5) {
		//geel
		color = StarColorMake(1.0f, 1.0f, 0.7f, [self alpha]);
	}
	else if([ci floatValue] > 0.25) {
		//geelachtig
		color = StarColorMake(1.0f, 1.0f, 0.8f, [self alpha]);
	}
	else if([ci floatValue] > 0.0) {
		//wit
		color = StarColorMake(1.0f, 1.0f, 1.0f, [self alpha]);
	}
	else {
		//blauw
		color = StarColorMake(0.7f, 0.7f, 1.0f, [self alpha]);
	}
	
	return color;
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
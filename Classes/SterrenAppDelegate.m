//
//  SterrenAppDelegate.m
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


#import "SterrenAppDelegate.h"
#import "GLView.h"
#import "SRLocation.h"
#import "SRObjectManager.h"
#import "ConstantsAndMacros.h"
#import "SRLocation.h"

@implementation SterrenAppDelegate

@synthesize window, glView, uiElementsView, location, timeManager, objectManager, settingsManager;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	objectManager = [[SRObjectManager alloc] init];
	location = [[SRLocation alloc] init];
	timeManager = [[SRTimeManager alloc] init];
	settingsManager = [[SRSettingsManager alloc] init];
	[objectManager parseData];
	
	// Loading screen annimation;
	glView.animationInterval = 1.0 / kRenderingFrequency;
	[glView startAnimation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / kInactiveRenderingFrequency;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 60.0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// De locatie opslaan voor het geval de applicatie opnieuw opstart
	//FIXME: OOK BRIGHTNESS e.d. doen
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:	[location latitude]						forKey:@"lat"];
	[prefs setFloat:	[location longitude]					forKey:@"long"];
	[prefs setBool:		[location staticValues]					forKey:@"staticCoordinates"];
	[prefs setBool:		[settingsManager showRedOverlay]		forKey:@"showRedOverlay"];
	[prefs setBool:		[settingsManager showConstellations]	forKey:@"showConstellations"];
	[prefs setFloat:	[settingsManager brightnessFactor]		forKey:@"brightness"];
	[prefs synchronize];
}

- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end

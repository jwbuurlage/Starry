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
#import "ConstantsAndMacros.h"
#import "XMLParser.h"
#import "SRLocation.h"

@implementation SterrenAppDelegate

@synthesize window, glView, stars, uiElementsView, location;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSData * data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"stars" ofType: @"xml"]];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
	XMLParser *parser = [[XMLParser alloc] initXMLParser];
	[xmlParser setDelegate:parser];
	BOOL success = [xmlParser parse];
	
	if(success) {
		//NSLog(@"XML Parse completed");
	}
	else {
		//NSLog(@"XML Parse error"); */
	}
	//uiElementsView.opaque = YES;
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
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:	[location latitude]		forKey:@"lat"];
	[prefs setFloat:	[location longitude]	forKey:@"long"];
	[prefs setBool:		[location staticValues]	forKey:@"staticCoordinates"];
	[prefs synchronize];
}

- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end

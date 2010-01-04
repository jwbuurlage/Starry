//
//  SRLocationModule.m
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

#import "SRLocationModule.h"

@implementation SRLocationModule

@synthesize latitude,longitude,longVisible,latVisible,locationManager, GPS;

-(id)initWithSRLocation:(SRLocation*)aLocation {
	if(self = [super init]) {
		NSString* locationString;
		
		locationManager = aLocation;
		
		initialXValueIcon = 12;
		
		[locationManager makeAwareOfInterface:self];
		
		//NSLog(@"SRLocationModule meldt de locatie lo:%f la:%f",longitude,latitude);
		
		elements = [[NSMutableArray alloc] init];
		
		if([locationManager staticValues]) {
			locationString = [[NSString alloc] initWithString:@"location_off.png"];
			GPS = FALSE;
		}
		else {
			locationString = [[NSString alloc] initWithString:@"location_on.png"];
			GPS = TRUE;
		}
		
		//laad elements in - sla op in textures		
		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(12, -55, 31, 31)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"radar.png"]] 
															identifier:@"icon" 
															 clickable:YES]];	
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(104,-60, 80,32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Latitude", @"") dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent"
															 clickable:NO]];
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(224,-60, 80,32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Longitude", @"") dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(104,-72, 80,32) 
															   texture:nil 
															identifier:@"lat" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(70,-55, 28,28) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"latitude.png"]] 
															identifier:@"lat-edit" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(224,-72, 80,32) 
															   texture:nil 
															identifier:@"long" 
															 clickable:YES]];
				 

		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(380,-53, 28,28) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:locationString]]
																							   identifier:@"gps-toggle" 
																							  clickable:YES]];
	
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(190,-55, 28,28) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"longitude.png"]]
															identifier:@"long-edit" 
															 clickable:YES]];
		latVisible = YES;
		longVisible = YES;
		
		[locationString release];
	}
	return self;
}

-(void)draw {
	//draw module zelf
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	for (SRInterfaceElement* mElement in elements) {
		if([mElement identifier] == @"text-transparent") {
			glColor4f(0.4f, 0.4f, 0.4f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"lat") {
			if(latVisible == YES) {
				NSNumber * coordinateNumber = [[NSNumber alloc] initWithFloat:latitude];
				int degrees = [coordinateNumber intValue];
				float minutesF = ([coordinateNumber floatValue] - [coordinateNumber intValue]) * 60;
				NSNumber * minutesNumber = [[NSNumber alloc] initWithFloat:minutesF];
				int minutes = [minutesNumber intValue];
				float secondsF = ([minutesNumber floatValue] - [minutesNumber intValue])*60;
				NSNumber * secondsNumber = [[NSNumber alloc] initWithFloat:secondsF];
				int seconds = [secondsNumber intValue];
				NSString * northOrSouth;
				if (latitude >= 0) {
					northOrSouth = NSLocalizedString(@"locN", @"");
				}
				else {
					northOrSouth = NSLocalizedString(@"locS", @"");
					degrees = -degrees;
					minutes = -minutes;
					seconds = -seconds;
				}
				
				Texture2D* texture = [[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i°%i\"%i' %@",degrees,minutes,seconds,northOrSouth] dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
				glColor4f(0.294f, 0.513f, 0.93f, alphaValue);
				[texture drawInRect:[mElement bounds]];
				glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
				[texture release];
																
				[coordinateNumber release];
				[minutesNumber release];
				[secondsNumber release];
				degrees = 0;
				minutesF = 0;
				minutes = 0;
				secondsF = 0;
				seconds = 0;
			}
			
		}
		else if([mElement identifier] == @"long") {
			if(longVisible == YES) {
				NSNumber * coordinateNumber = [[NSNumber alloc] initWithFloat:longitude];
				int degrees = [coordinateNumber intValue];
				float minutesF = ([coordinateNumber floatValue] - [coordinateNumber intValue]) * 60;
				NSNumber * minutesNumber = [[NSNumber alloc] initWithFloat:minutesF];
				int minutes = [minutesNumber intValue];
				float secondsF = ([minutesNumber floatValue] - [minutesNumber intValue])*60;
				NSNumber * secondsNumber = [[NSNumber alloc] initWithFloat:secondsF];
				int seconds = [secondsNumber intValue];
				NSString * westOrEast;
				if (longitude >= 0) {
					westOrEast = NSLocalizedString(@"locW", @"");
				}
				else {
					westOrEast = NSLocalizedString(@"locE", @"");
					degrees = -degrees;
					minutes = -minutes;
					seconds = -seconds;
				}
				
			
															
				Texture2D* texture = [[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i°%i\"%i' %@",degrees,minutes,seconds,westOrEast] dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
				glColor4f(0.294f, 0.513f, 0.93f, alphaValue);
				[texture drawInRect:[mElement bounds]];
				glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
				[texture release];
															
				[coordinateNumber release];
				[minutesNumber release];
				[secondsNumber release];
				degrees = 0;
				minutesF = 0;
				minutes = 0;
				secondsF = 0;
				seconds = 0;
			}
			/*else {
				Texture2D* texture = [[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@""] dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
				[texture drawInRect:[mElement bounds]];
				[texture release];
			}*/
		}
		else if([mElement identifier] == @"icon") {
			if(hiding) {
				glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
			}
			[[elements objectAtIndex:0] setBounds:CGRectMake(xValueIcon,-55, 31, 31)];
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else {
			glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
	}
}

-(void)updateDisplayedLocationData {
	
	longitude	=	[locationManager longitude];
	latitude	=	[locationManager latitude];
	
	// NSLog(@"SRLocationModule meldt de locatie lo:%f la:%f",longitude,latitude);
}

-(void)toggleGPS {
	if(GPS) {
		[locationManager useStaticValues];
		[[elements objectAtIndex:6] setTexture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"location_off.png"]]];
		GPS = FALSE;
	}
	else {
		[locationManager useGPSValues];
		[[elements objectAtIndex:6] setTexture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"location_on.png"]]];
		GPS = TRUE;
	}
}

@end

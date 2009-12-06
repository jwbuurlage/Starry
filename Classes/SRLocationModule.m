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
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(104,-48, 80,32) 
															   texture:[[Texture2D alloc] initWithString:@"BREEDTEGRAAD" dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent"
															 clickable:NO]];
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(224,-48, 80,32) 
															   texture:[[Texture2D alloc] initWithString:@"LENGTEGRAAD" dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(104,-59, 80,32) 
															   texture:nil 
															identifier:@"lat" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(70,-42, 28,28) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"latitude.png"]] 
															identifier:@"lat-edit" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(224,-59, 80,32) 
															   texture:nil 
															identifier:@"long" 
															 clickable:YES]];
				 
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(190,-42, 28,28) 
																texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"longitude.png"]]
																							  identifier:@"long-edit" 
																							   clickable:YES]];
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(380,-40, 28,28) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:locationString]]
																							   identifier:@"gps-toggle" 
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
			glColor4f(1.0f, 1.0f, 1.0f, 0.5f);
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
					northOrSouth = @"NB";
				}
				else {
					northOrSouth = @"ZB";
					degrees = -degrees;
					minutes = -minutes;
					seconds = -seconds;
				}
				
				Texture2D* texture = [[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i°%i\"%i' %@",degrees,minutes,seconds,northOrSouth] dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
				[texture drawInRect:[mElement bounds]];
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
					westOrEast = @"WL";
				}
				else {
					westOrEast = @"OL";
					degrees = -degrees;
					minutes = -minutes;
					seconds = -seconds;
				}
				
			
															
				Texture2D* texture = [[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i°%i\"%i' %@",degrees,minutes,seconds,westOrEast] dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
				[texture drawInRect:[mElement bounds]];
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
		else {
			[[mElement texture] drawInRect:[mElement bounds]];
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

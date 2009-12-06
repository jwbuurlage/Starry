//
//  SRSettingsModule.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 01-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.

#import "SRSettingsModule.h"
#import "SterrenAppDelegate.h"
#import "SRSettingsManager.h"


@implementation SRSettingsModule

-(id)init {
	if(self = [super init]) {
		elements = [[NSMutableArray alloc] init];
		
		//laad elements in - sla op in textures
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(70,-45, 32,32) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"brightness_plus.png"]] 
															identifier:@"brightness_plus" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(110,-45, 32,32) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"brightness_minus.png"]] 
															identifier:@"brightness_minus" 
															 clickable:YES]];		
		
		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(150,-48, 80,32) 
															   texture:[[Texture2D alloc] initWithString:@"HELDERHEID" dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(150,-59, 80,32) 
															   texture:nil 
															identifier:@"brightness_value" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(336, -44, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"red.png"]] 
															identifier:@"red" 
															 clickable:YES]];		
		//laad elements in - sla op in textures
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(376, -44, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"constellation.png"]] 
															identifier:@"constellations" 
															 clickable:YES]];
		
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
		else if([mElement identifier] == @"brightness_value") {
			float brightnessTmp = [[[[UIApplication sharedApplication] delegate] settingsManager] brightnessFactor];
			int brightnessInt = brightnessTmp*100;
			//NSNumber* brigtnessValue = [NSNumber numberWithFloat:brightnessTmp];
			
			Texture2D* texture = [[Texture2D alloc] initWithString:[NSString stringWithFormat:@"%i%%",brightnessInt] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			[texture drawInRect:[mElement bounds]];
			[texture release];
			//[brigtnessValue release];
		}
		else {
			[[mElement texture] drawInRect:[mElement bounds]];
		}
	}	
	
}

@end

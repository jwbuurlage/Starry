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
		
		initialXValueIcon = 168;
		
		//laad elements in - sla op in textures
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(70,-55, 32,32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"brightness_plus.png"]] 
															identifier:@"brightness_plus" 
															 clickable:NO]];		

		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(10, -57, 41, 31)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"gears.png"]] 
															identifier:@"icon" 
															 clickable:YES]];
		
		/*[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(70,-55, 32,32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"brightness_minus.png"]] 
															identifier:@"brightness_minus" 
															 clickable:NO]];		
		*/	
		
		/*[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(150,-58, 80,32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Brightness", @"") dimensions:CGSizeMake(80,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(150,-69, 80,32) 
															   texture:nil 
															identifier:@"brightness_value" 
															 clickable:NO]];*/
		
		
		
		//laad elements in - sla op in textures
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(376, -60, 45, 40)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"redmode.png"]] 
															identifier:@"red" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(336, -60, 45, 40)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"constellations.png"]] 
															identifier:@"constellations" 
															 clickable:YES]];		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(296, -55, 45, 40)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"planetLabel.png"]] 
															identifier:@"planet_labels" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(256, -55, 45, 40)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"positionOverlayIcon.png"]] 
															identifier:@"position_overlay" 
															 clickable:YES]];
		
		[self reloadElements];
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
		else if([mElement identifier] == @"brightness_value") {
			float brightnessTmp = [[[[UIApplication sharedApplication] delegate] settingsManager] brightnessFactor];
			int brightnessInt = brightnessTmp*100;
			//NSNumber* brigtnessValue = [NSNumber numberWithFloat:brightnessTmp];
			
			Texture2D* texture = [[Texture2D alloc] initWithString:[NSString stringWithFormat:@"%i%%",brightnessInt] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
			[texture drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			[texture release];
			//[brigtnessValue release];
		}
		else if([mElement identifier] == @"icon") {			
			if(hiding) {
				glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
			}
			else {
				[[elements objectAtIndex:1] setBounds:CGRectMake(xValueIcon, -57, 41, 31)];
			}

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

-(void)hide {
	[super hide];
	//[[[[UIApplication sharedApplication] delegate] settingsManager]
}

-(void)reloadElements {
	//red mode
	if([[[[UIApplication sharedApplication] delegate] settingsManager] showRedOverlay]) {
		[elements replaceObjectAtIndex:2 withObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(376, -60, 45, 40)
																					   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"redmode_on.png"]] 
																					identifier:@"red" 
																					 clickable:YES]];
	}
	else {
		[elements replaceObjectAtIndex:2 withObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(376, -60, 45, 40)
																					   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"redmode.png"]] 
																					identifier:@"red" 
																					 clickable:YES]];
	}
	
	//constellations
	if([[[[UIApplication sharedApplication] delegate] settingsManager] showConstellations]) {
		[elements replaceObjectAtIndex:3 withObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(336, -60, 45, 40)
																					   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"constellation_on.png"]] 
																					identifier:@"constellations" 
																					 clickable:YES]];
	}
	else {
		[elements replaceObjectAtIndex:3 withObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(336, -60, 45, 40)
																					   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"constellation.png"]] 
																					identifier:@"constellations" 
																					 clickable:YES]];
	}
	
	//planeten
	if([[[[UIApplication sharedApplication] delegate] settingsManager] showPlanetLabels]) {
		[elements replaceObjectAtIndex:4 withObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(296, -60, 45, 40)
																					   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"planetLabel_on.png"]] 
																					identifier:@"planet_labels" 
																					 clickable:YES]];
	}
	else {
		[elements replaceObjectAtIndex:4 withObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(296, -60, 45, 40)
																					   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"planetLabel.png"]] 
																					identifier:@"planet_labels" 
																					 clickable:YES]];
	}
	
	//positionoverlay
	if([[[[UIApplication sharedApplication] delegate] settingsManager] showPositionOverlay]) {
		[elements replaceObjectAtIndex:5 withObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(256, -60, 45, 40)
																					   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"positionOverlayIcon_on.png"]] 
																					identifier:@"position_overlay" 
																					 clickable:YES]];
	}
	else {
		[elements replaceObjectAtIndex:5 withObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(256, -60, 45, 40)
																					   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"positionOverlayIcon.png"]] 
																					identifier:@"position_overlay" 
																					 clickable:YES]];
	}
}

@end

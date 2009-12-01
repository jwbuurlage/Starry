//
//  SRSettingsModule.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 01-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.

#import "SRSettingsModule.h"


@implementation SRSettingsModule

-(id)init {
	if(self = [super init]) {
		elements = [[NSMutableArray alloc] init];
		
		//laad elements in - sla op in textures
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(75,-45, 64,32) 
															   texture:[[Texture2D alloc] initWithString:@"HELDERHEID" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent"
															 clickable:NO]];

		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(200, -44, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"red.png"]] 
															identifier:@"red" 
															 clickable:YES]];		
		//laad elements in - sla op in textures
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(240, -44, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"constellation.png"]] 
															identifier:@"constellation" 
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
		else {
			[[mElement texture] drawInRect:[mElement bounds]];
		}
	}	
}

@end

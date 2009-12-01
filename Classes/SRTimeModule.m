//
//  SRTimeModule.m
//
//  A part of Sterren.app, planetarium iPhone application.
//	Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//	Use without premission by Mote of Life is not authorised.
//
//	Mote of Life is a registred company at the Dutch Chamber of Commerce.
//	Chamber of Commerce registration number: 37126951
//

#import "SRTimeModule.h"


@implementation SRTimeModule

@synthesize manager;

-(id)init {
	if(self = [super init]) {
		
		manager = [[SRTimeManager alloc] initWithOwner:self];
		
		elements = [[NSMutableArray alloc] init];
		
		//laad elements in - sla op in textures
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(74, -44, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"rew.png"]] 
															identifier:@"rew" 
															   clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(110, -44, 32, 32)  
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"play.png"]] 
															identifier:@"play" 
															   clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(146,-44, 32,32) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"fwd.png"]] 
															identifier:@"fwd" 
															   clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(206,-48, 64,32) 
															   texture:[[Texture2D alloc] initWithString:@"TIJD" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent"
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(261,-48, 64,32) 
															   texture:[[Texture2D alloc] initWithString:@"DATUM" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(336,-48, 64,32) 
															   texture:[[Texture2D alloc] initWithString:@"SNELHEID" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(206,-59, 64,32) 
															   texture:nil
															identifier:@"time"
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(261,-59, 64,32) 
															   texture:nil
															identifier:@"date" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(336,-59, 64,32) 
															   texture:nil 
															identifier:@"speed" 
															 clickable:NO]];
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
		else if([mElement identifier] == @"time") {
			Texture2D* texture = [[Texture2D alloc] initWithString:[manager theTime] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			[texture drawInRect:[mElement bounds]];
			[texture release];
		}
		else if([mElement identifier] == @"date") {
			Texture2D* texture = [[Texture2D alloc] initWithString:[manager theDate] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			[texture drawInRect:[mElement bounds]];
			[texture release];
			
		}
		else if([mElement identifier] == @"speed") {
			Texture2D* texture = [[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%ix",[manager speed]] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			[texture drawInRect:[mElement bounds]];
			[texture release];
		}
		else {
			[[mElement texture] drawInRect:[mElement bounds]];
		}
	}
}


@end

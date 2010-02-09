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
		
		initialXValueIcon = 58;
		
		manager = [[[UIApplication sharedApplication] delegate] timeManager];
		[manager setModuleInstance:self];
		
		elements = [[NSMutableArray alloc] init];
		
		//laad elements in - sla op in textures
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(178, -62, 137, 40)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"controls_bg.png"]] 
															identifier:@"controls_bg" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(62, -57, 41, 31)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"calendar.png"]] 
															identifier:@"icon" 
															 clickable:YES]];
						
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(185, -57, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"stop.png"]] 
															identifier:@"stop" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(215, -57, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"rew.png"]] 
															identifier:@"rew" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(245, -57, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"pause.png"]] 
															identifier:@"playpause" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(275, -57, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"fwd.png"]] 
															identifier:@"fwd" 
															 clickable:YES]];
				
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(65, -60, 64,32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Time", @"") dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent"
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(105,-58, 64,32) 
															   texture:nil
															identifier:@"time"
															 clickable:NO]];		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(65, -75, 64,32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Date", @"") dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(105,-73, 64,32) 
															   texture:nil
															identifier:@"date" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(336,-68, 64,32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Speed", @"") dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(390,-66, 64,32) 
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
			glColor4f(0.4f, 0.4f, 0.4f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"time") {
			Texture2D* texture = [[Texture2D alloc] initWithString:[manager theTime] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			glColor4f(0.294f, 0.513f, 0.93f, 1.0f * alphaValue);
			[texture drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			[texture release];
		}
		else if([mElement identifier] == @"date") {
			Texture2D* texture = [[Texture2D alloc] initWithString:[manager theDate] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			glColor4f(0.294f, 0.513f, 0.93f, alphaValue);
			[texture drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			[texture release];
			
		}
		else if([mElement identifier] == @"speed") {
			Texture2D* texture;
			if([manager speed] != 0) {
				texture = [[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%ix",[manager speed]] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			}
			else {
				texture = [[Texture2D alloc] initWithString:@"-" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11];
			}
			glColor4f(0.56f, 0.831f, 0.0f, alphaValue);
			[texture drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			[texture release];
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

-(void)switchPlay:(BOOL)aFlag {
	if(aFlag) {
		[[elements objectAtIndex:5] setTexture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"pause.png"]]];	
	}
	else {
		[[elements objectAtIndex:5] setTexture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"play.png"]]];	
	}
}

@end

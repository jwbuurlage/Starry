//
//  SRNamePlate.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 01-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRNamePlate.h"


@implementation SRNamePlate

@synthesize yTranslate, visible, hiding, info, elements;

-(id)init {
	if(self = [super self]) {
		elements = [[NSMutableArray alloc] init];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(150, 288, 256, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"nameplatebg.png"]] 
															identifier:@"nameplate" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(290, 289, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"info.png"]] 
															identifier:@"info" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(160,281, 128,32) 
															   texture:nil
															identifier:@"text" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(205,279, 128,32) 
															   texture:nil
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		yTranslate = 32;
		visible = NO;
		info = NO;
	}
	return self;	
}

-(void)draw {
	glTranslatef(0, yTranslate, 0);
	for (SRInterfaceElement* mElement in elements) {
		if([mElement identifier] == @"text-transparent") {
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			glColor4f(1.0f, 1.0f, 1.0f, 0.5f);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"text") {
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			[[mElement texture] drawInRect:[mElement bounds]];
		}
		else if([mElement identifier] == @"info") {
			if(info) {
			glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
			[[mElement texture] drawInRect:[mElement bounds]];
			}
		}
		else {
			glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
			[[mElement texture] drawInRect:[mElement bounds]];
		}
	}
	glTranslatef(0, -yTranslate, 0);

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void)show {
	visible = YES;
	hiding = FALSE;
}

-(void)hide {
	hiding = TRUE;
}

-(void)setName:(NSString*)name inConstellation:(NSString*)constellation showInfo:(BOOL)theInfo {
	[[[elements objectAtIndex:2] texture] release];
	[[[elements objectAtIndex:3] texture] release];
	[[elements objectAtIndex:2] setTexture:[[Texture2D alloc] initWithString:name dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12]];
	[[elements objectAtIndex:3] setTexture:[[Texture2D alloc] initWithString:constellation dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9]];
	[[elements objectAtIndex:3] setBounds:CGRectMake([name sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]].width + 165, 278, 128,32)];
	info = theInfo;
	if (![self visible]) {
		[self show];
	}
}

@end

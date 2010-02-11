//
//  SRNamePlate.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 01-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRNamePlate.h"


@implementation SRNamePlate

@synthesize yTranslate, visible, hiding, info, elements, selectedType;

-(id)init {
	if(self = [super self]) {
		selectedType = 0;
		
		elements = [[NSMutableArray alloc] init];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(112, 269, 235, 51)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"nameplatebg.png"]] 
															identifier:@"nameplate" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(300, 285, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"info.png"]] 
															identifier:@"info" 
															 clickable:YES]];
		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(165,279, 128,32) 
															   texture:nil
															identifier:@"text-black" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(165,266, 128,32) 
															   texture:nil
															identifier:@"text-black" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(165,280, 128,32) 
															   texture:nil
															identifier:@"text" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(165,267, 128,32) 
															   texture:nil
															identifier:@"text-transparent" 
															 clickable:NO]];
				
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(130, 285, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"close.png"]] 
															identifier:@"close_nameplate" 
															 clickable:YES]];
		
		yTranslate = 50;
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
			glColor4f(0.294f, 0.513f, 0.93f, 1.0f);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"text") {
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"text-black") {
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
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
	if(name == nil || [name isEqualToString:@""] || [name isEqualToString:@" "]) {
		name = NSLocalizedString(@"Nameless",@"");
	}
	
	[[[elements objectAtIndex:2] texture] release];
	[[[elements objectAtIndex:3] texture] release];
	[[[elements objectAtIndex:4] texture] release];
	[[[elements objectAtIndex:5] texture] release];
	[[elements objectAtIndex:4] setTexture:[[Texture2D alloc] initWithString:name dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12]];
	[[elements objectAtIndex:2] setTexture:[[Texture2D alloc] initWithString:name dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12]];
	[[elements objectAtIndex:3] setTexture:[[Texture2D alloc] initWithString:constellation dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9]];
	[[elements objectAtIndex:5] setTexture:[[Texture2D alloc] initWithString:constellation dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9]];
	info = theInfo;
	if (![self visible]) {
		[self show];
	}
}

@end

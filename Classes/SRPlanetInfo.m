//
//  SRPlanetInfo.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 27-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRPlanetInfo.h"


@implementation SRPlanetInfo

-(id)init {
	if(self = [super init]) {
		elements = [[NSMutableArray alloc] init];
		
		


		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 202, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Planeet Info" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															identifier:@"text" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Sterrenbeeld:" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 160, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Type:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 145, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Afstand:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 130, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"RA:" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 115, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Declinatie:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 100, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Magnitude:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(110, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"UMa" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(70, 160, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Diffuse Nebula" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(85, 145, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"7 kly" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-green" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(60, 130, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"12 52' 12''" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(95, 115, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"90" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(98, 100, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"12.0" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-green" 
															 clickable:NO]]; 
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(260, 25, 102, 34) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"messierNameBg.png"]] //102x34
															identifier:@"nameplate" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(300, 18, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"M1" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															identifier:@"nameplate" 
															 clickable:NO]];
		
		interfaceBackground = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"planetInfoBg.png"]]; //139x320

	}
	return self;
}

@synthesize hiding, alphaValue, alphaValueName;

/* + (SRMessierInfo*)shared {
 if(!sharedMessier) {
 sharedMessier = [[SRMessierInfo alloc] init];
 }
 return sharedMessier;
 } */

-(void)show {
	alphaValue = 0.0f;
	alphaValueName = -1.0f;
	hiding = FALSE;
}

-(void)hide {
	hiding = TRUE;
}

- (void)planetClicked:(SRPlanetaryObject*)thePlanet {
	//[messierImage release];
	//messierImage = ;
	planetImage = [[Texture2D alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [thePlanet name]]]]; 
	[[elements objectAtIndex:[elements count] - 1] setTexture:[[Texture2D alloc] initWithString:thePlanet.name dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12]]; 
	[[elements objectAtIndex:[elements count] - 1] setBounds:CGRectMake(311 - [thePlanet.name sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]].width / 2, 18,64,32)];
}

- (void)draw {	
	glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
	[planetImage drawInRect:CGRectMake(0, 0, 480, 320)]; 
	[interfaceBackground drawInRect:CGRectMake(20, 0, 200, 320)];
	for (SRInterfaceElement* mElement in elements) {
		if([mElement identifier] == @"text-transparent") {
			glColor4f(0.4f, 0.4f, 0.4f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
 		}
		else if([mElement identifier] == @"text-blue") {
			glColor4f(0.294f, 0.513f, 0.93f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
		}
		else if([mElement identifier] == @"text-green") {
			glColor4f(0.56f, 0.831f, 0.0f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
		}
		else if([mElement identifier] == @"nameplate" || [mElement identifier] == @"picture") {
			glColor4f(1.0f, 1.0f, 1.0f, alphaValueName);
			[[mElement texture] drawInRect:[mElement bounds]];
		}
		else {
			glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
		}
	}
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}


@end

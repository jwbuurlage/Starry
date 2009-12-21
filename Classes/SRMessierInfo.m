//
//  SRMessierInfo.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 09-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRMessierInfo.h"

@implementation SRMessierInfo

-(id)init {
	if(self = [super init]) {
		elements = [[NSMutableArray alloc] init];
		
		interfaceBackground = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"messierInfoBg.png"]]; //139x320
		pictureBackground = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"messierPictureBg.png"]]; //341x320
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(20, 214, 64, 32) 
																 texture:[[Texture2D alloc] initWithString:@"Info" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															  identifier:@"text" 
															   clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(10, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Sterrenbeeld:" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(10, 160, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Type:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(10, 145, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Afstand:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(10, 130, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"RA:" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(10, 115, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Declinatie:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(10, 100, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Magnitude:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(90, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"UMa" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(45, 160, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Diffuse Nebula" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(60, 145, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"7 kly" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-green" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(35, 130, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"12 52' 12''" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(70, 115, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"90" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(73, 100, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"5.3" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-green" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(158, 46, 301, 232)  //301 x 232
															   texture:nil
															identifier:@"picture" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(260, 25, 102, 34) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"messierNameBg.png"]] //102x34
															identifier:@"nameplate" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(300, 18, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"M1" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															identifier:@"nameplate" 
															 clickable:NO]];
		
	}
	return self;
}

//@synthesize visible;

/* + (SRMessierInfo*)shared {
	if(!sharedMessier) {
		sharedMessier = [[SRMessierInfo alloc] init];
	}
	return sharedMessier;
} */

-(void)show {
	alphaValue = 0.0f;
	alphaValueName = -1.0f;
	showTimer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(alpha:) userInfo:nil repeats:YES] retain];
	hiding = FALSE;
}

-(void)hide {
	showTimer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(alpha:) userInfo:nil repeats:YES] retain];
	hiding = TRUE;
}


-(void)alpha:(NSTimer*)theTimer {
	if(hiding) {
		alphaValue -= 0.1f;
		alphaValueName -= 0.1f;
		if(alphaValue <= 0.0f) {
			[showTimer invalidate];
			[showTimer release];
			hiding = FALSE;
		}
	}
	else {
		alphaValue += 0.1f;
		alphaValueName += 0.1f;
		if(alphaValueName >= 1.0f) {
			[showTimer invalidate];
			[showTimer release];
			alphaValue = 1.0f;
			alphaValueName = 1.0f;
		}
	}
	
}

- (void)messierClicked:(SRMessier*)theMessier {
	//[messierImage release];
	//messierImage = ;
	[[elements objectAtIndex:[elements count] - 3] setTexture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", @"M1"]]]]; 
	[[elements objectAtIndex:[elements count] - 1] setTexture:[[Texture2D alloc] initWithString:[theMessier name] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12]]; 
}

- (void)draw {
	glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
	[interfaceBackground drawInRect:CGRectMake(0, 0, 139, 320)];
	[pictureBackground drawInRect:CGRectMake(139, 0, 341, 320)];
	
	for (SRInterfaceElement* mElement in elements) {
		if([mElement identifier] == @"text-transparent") {
			glColor4f(0.4f, 0.4f, 0.4f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"text-blue") {
			glColor4f(0.294f, 0.513f, 0.93f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"text-green") {
			glColor4f(0.56f, 0.831f, 0.0f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"nameplate" || [mElement identifier] == @"picture") {
			glColor4f(1.0f, 1.0f, 1.0f, alphaValueName);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else {
			glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
	}
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	
}

@end

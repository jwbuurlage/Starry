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
															   texture:[[Texture2D alloc] initWithString:@"Planeet Informatie" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															identifier:@"text" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"RA:" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 160, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Declinatie:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(60, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(95, 160, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(260, 25, 102, 34) 
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"messierNameBg.png"]] //102x34
															identifier:@"nameplate" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(300, 18, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
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
	Vertex3D posForCam = [thePlanet myCurrentPosition];
	float azTmp = (180/M_PI)*atan2(posForCam.y,posForCam.x);
	float alTmp = 90-(180/M_PI)*acos(-posForCam.z); 
	//NSLog(@"test %f",azTmp);
	
	NSNumber * coordinateNumber = [[NSNumber alloc] initWithFloat:azTmp];
	int degrees = [coordinateNumber intValue];
	float minutesF = ([coordinateNumber floatValue] - [coordinateNumber intValue]) * 60;
	NSNumber * minutesNumber = [[NSNumber alloc] initWithFloat:minutesF];
	int minutes = [minutesNumber intValue];
	float secondsF = ([minutesNumber floatValue] - [minutesNumber intValue])*60;
	NSNumber * secondsNumber = [[NSNumber alloc] initWithFloat:secondsF];
	int seconds = [secondsNumber intValue];
	
	if (azTmp < 0) {
		degrees = 360+degrees;
		minutes = 60+minutes;
		seconds = 60+seconds;
	}
	
	degrees = degrees * 60 / 360; // Uuren er van maken
	
	[[elements objectAtIndex:[elements count] - 4] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%ih %i\' %i\"",degrees,minutes,seconds] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber release];
	[minutesNumber release];
	[secondsNumber release];
	
	NSNumber * coordinateNumber2 = [[NSNumber alloc] initWithFloat:alTmp];
	int degrees2 = [coordinateNumber2 intValue];
	float minutesF2 = ([coordinateNumber2 floatValue] - [coordinateNumber2 intValue]) * 60;
	NSNumber * minutesNumber2 = [[NSNumber alloc] initWithFloat:minutesF2];
	int minutes2 = [minutesNumber2 intValue];
	float secondsF2 = ([minutesNumber2 floatValue] - [minutesNumber2 intValue])*60;
	NSNumber * secondsNumber2 = [[NSNumber alloc] initWithFloat:secondsF2];
	int seconds2 = [secondsNumber2 intValue];
	
	if (alTmp < 0) {
		minutes2 = -minutes2;
		seconds2 = -seconds2;
	}
	[[elements objectAtIndex:[elements count] - 3] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees2,minutes2,seconds2] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber2 release];
	[minutesNumber2 release];
	[secondsNumber2 release];
	UIImage* planetImageTmp = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [thePlanet name]]];
	planetImage = [[Texture2D alloc] initWithImage:planetImageTmp]; 
	NSLog(@"%@,", [NSString stringWithFormat:@"%@.png", [thePlanet name]]);
	[[elements objectAtIndex:[elements count] - 1] setTexture:[[Texture2D alloc] initWithString:thePlanet.name dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12]]; 
	[[elements objectAtIndex:[elements count] - 1] setBounds:CGRectMake(311 - [thePlanet.name sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]].width / 2, 18,64,32)];
	[planetImageTmp release];
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

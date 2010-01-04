//
//  SRPlanetInfo.m
//  Sterren
//
//  Created by Thijs Scheepers on 27-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRStarInfo.h"
#import "OpenGLCommon.h"


@implementation SRStarInfo

-(id)init {
	if(self = [super init]) {
		elements = [[NSMutableArray alloc] init];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 222, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Ster Informatie" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															identifier:@"text" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 195, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Sterrenbeeld:" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 180, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"RA:" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 165, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Declinatie:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 150, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Magnitude:" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(110, 195, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(60, 180, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(95, 165, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(98, 150, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-green" 
															 clickable:NO]]; 
		interfaceBackground = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"starInfoBg.png"]];
		
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

- (void)starClicked:(SRStar*)theStar {
	Vertex3D posForCam = [theStar myCurrentPosition];
	float azTmp = (180/M_PI)*atan2(posForCam.y,posForCam.x);
	float alTmp = 90-(180/M_PI)*acos(-posForCam.z); 
	//NSLog(@"test %f",azTmp);
	

	NSString* constellation = [[theStar bayer] substringWithRange:NSMakeRange([[theStar bayer] length]-3, 3)];
	[[elements objectAtIndex:[elements count] - 4] setTexture:[[Texture2D alloc] initWithString:NSLocalizedString(constellation,@"") dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]];
	
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
	[[elements objectAtIndex:[elements count] - 3] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i°%i\"%i'",degrees,minutes,seconds] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
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
	[[elements objectAtIndex:[elements count] - 2] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i°%i\"%i'",degrees2,minutes2,seconds2] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber2 release];
	[minutesNumber2 release];
	[secondsNumber2 release];
	
	[[elements objectAtIndex:[elements count] - 1] setTexture:[[Texture2D alloc] initWithString:[theStar mag] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	
	
}

- (void)draw {	
	glTranslatef(245,-18,0);
	glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
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
		else {
			glColor4f(1.0f, 1.0f, 1.0f, alphaValue);
			[[mElement texture] drawInRect:[mElement bounds]];
		}
	}
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	glTranslatef(-245,18,0);
}


@end

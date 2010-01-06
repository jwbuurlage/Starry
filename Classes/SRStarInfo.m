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
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 228, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Star Details", @"") dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															identifier:@"text" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 205, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Const.", @"") dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 190, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Hip" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Gli." dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 160, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"RA" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 145, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Dec" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 130, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Azi" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 115, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Alt" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(38, 100, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Mag" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(80, 205, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(80, 190, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(80, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(80, 160, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-green" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(80, 145, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(80, 130, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-green" 
															 clickable:NO]]; 
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(80, 115, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]]; 
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(80, 100, 64, 32) 
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
	float azTmp = (180/M_PI)*atan2f(posForCam.y,posForCam.x);
	float alTmp = 90-(180/M_PI)*acosf(-posForCam.z); 
	
	float raTmp = (180/M_PI)*atan2f([theStar.y floatValue]/20,[theStar.x floatValue]/20);
	//NSLog(@"test raTmp %f",raTmp);
	float decTmp = 90-(180/M_PI)*acosf(-[theStar.z floatValue]/20); 
	//NSLog(@"test decTmp %f",decTmp);
	

	NSString* constellation = [[theStar bayer] substringWithRange:NSMakeRange([[theStar bayer] length]-3, 3)];
	[[[elements objectAtIndex:[elements count] - 8] texture] release];
	[[elements objectAtIndex:[elements count] - 8] setTexture:[[Texture2D alloc] initWithString:NSLocalizedString(constellation,@"") dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]];
	
	[[[elements objectAtIndex:[elements count] - 7] texture] release];
	//NSString* hip = [[theStar bayer] substringWithRange:NSMakeRange( length]-3, 3)];
	[[elements objectAtIndex:[elements count] - 7] setTexture:[[Texture2D alloc] initWithString:[theStar hip] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]];
	
	[[[elements objectAtIndex:[elements count] - 6] texture] release];
	//NSString* constellation = [[theStar bayer] substringWithRange:NSMakeRange([[theStar bayer] length]-3, 3)];
	[[elements objectAtIndex:[elements count] - 6] setTexture:[[Texture2D alloc] initWithString:[theStar gliese] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]];
	
	
	NSNumber * coordinateNumber3 = [[NSNumber alloc] initWithFloat:(raTmp*24/360)];
	int degrees3 = [coordinateNumber3 intValue];
	float minutesF3 = ([coordinateNumber3 floatValue] - [coordinateNumber3 intValue]) * 60;
	NSNumber * minutesNumber3 = [[NSNumber alloc] initWithFloat:minutesF3];
	int minutes3 = [minutesNumber3 intValue];
	float secondsF3 = ([minutesNumber3 floatValue] - [minutesNumber3 intValue])*60;
	NSNumber * secondsNumber3 = [[NSNumber alloc] initWithFloat:secondsF3];
	int seconds3 = [secondsNumber3 intValue];
	
	if (raTmp < 0) {
		degrees3 = 24+degrees3;
		minutes3 = 60+minutes3;
		seconds3 = 60+seconds3;
	}
	//degrees = degrees ; // Uuren er van maken
	[[[elements objectAtIndex:[elements count] - 5] texture] release];
	[[elements objectAtIndex:[elements count] - 5] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%ih %im %is",degrees3,minutes3,seconds3] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber3 release];
	[minutesNumber3 release];
	[secondsNumber3 release];
	
	NSNumber * coordinateNumber4 = [[NSNumber alloc] initWithFloat:decTmp];
	int degrees4 = [coordinateNumber4 intValue];
	float minutesF4 = ([coordinateNumber4 floatValue] - [coordinateNumber4 intValue]) * 60;
	NSNumber * minutesNumber4 = [[NSNumber alloc] initWithFloat:minutesF4];
	int minutes4 = [minutesNumber4 intValue];
	float secondsF4 = ([minutesNumber4 floatValue] - [minutesNumber4 intValue])*60;
	NSNumber * secondsNumber4 = [[NSNumber alloc] initWithFloat:secondsF4];
	int seconds4 = [secondsNumber4 intValue];
	
	if (decTmp < 0) {
		minutes4 = -minutes4;
		seconds4 = -seconds4;
	}
	
	[[[elements objectAtIndex:[elements count] - 4] texture] release];
	[[elements objectAtIndex:[elements count] - 4] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees4,minutes4,seconds4] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber4 release];
	[minutesNumber4 release];
	[secondsNumber4 release];
	
	NSNumber * coordinateNumber = [[NSNumber alloc] initWithFloat:(azTmp)];
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
	//degrees = degrees ; // Uuren er van maken
	[[[elements objectAtIndex:[elements count] - 3] texture] release];
	[[elements objectAtIndex:[elements count] - 3] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees,minutes,seconds] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
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
	[[[elements objectAtIndex:[elements count] - 2] texture] release];
	[[elements objectAtIndex:[elements count] - 2] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees2,minutes2,seconds2] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber2 release];
	[minutesNumber2 release];
	[secondsNumber2 release];
	
	[[[elements objectAtIndex:[elements count] - 1] texture] release];
	[[elements objectAtIndex:[elements count] - 1] setTexture:[[Texture2D alloc] initWithString:[theStar mag] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	
	
}

- (void)starUpdate:(SRStar*)theStar {
	Vertex3D posForCam = [theStar myCurrentPosition];
	float azTmp = (180/M_PI)*atan2f(posForCam.y,posForCam.x);
	float alTmp = 90-(180/M_PI)*acosf(-posForCam.z); 
	
	NSNumber * coordinateNumber = [[NSNumber alloc] initWithFloat:(azTmp)];
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
	//degrees = degrees ; // Uuren er van maken
	[[[elements objectAtIndex:[elements count] - 3] texture] release];
	[[elements objectAtIndex:[elements count] - 3] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees,minutes,seconds] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
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
	[[[elements objectAtIndex:[elements count] - 2] texture] release];
	[[elements objectAtIndex:[elements count] - 2] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees2,minutes2,seconds2] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber2 release];
	[minutesNumber2 release];
	[secondsNumber2 release];
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

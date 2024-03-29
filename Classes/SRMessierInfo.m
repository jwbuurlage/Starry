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
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 214, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Messier Details",@"") dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															identifier:@"text" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 190, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Const.",@"") dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 175, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Type" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 160, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:NSLocalizedString(@"Dist",@"") dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 145, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"RA" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 130, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Dec" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 115, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Azi" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 100, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Alt" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(17, 85, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"Mag" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(55, 190, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(55, 175, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(55, 160, 64, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-green" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(55, 145, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(55, 130, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(55, 115, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(55, 100, 128, 32) 
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11] 
															identifier:@"text-blue" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(55, 85, 64, 32) 
															   texture:nil
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
															   texture:[[Texture2D alloc] initWithString:@"err" dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12] 
															identifier:@"nameplate" 
															 clickable:NO]];
		
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

- (void)messierClicked:(SRMessier*)theMessier {
	//[messierImage release];
	//messierImage = ;
	NSString* name = NSLocalizedString([theMessier constellation],@"");
	if([name length] > 10) {
		name = [[name substringToIndex:10] stringByAppendingFormat:@".."];
	}
	
	[[[elements objectAtIndex:[elements count] - 11] texture] release];
	[[elements objectAtIndex:[elements count] - 11] setTexture:[[Texture2D alloc] initWithString:name dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[[[elements objectAtIndex:[elements count] - 10] texture] release];
	[[elements objectAtIndex:[elements count] - 10] setTexture:[[Texture2D alloc] initWithString:NSLocalizedString([theMessier type],@"") dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[[[elements objectAtIndex:[elements count] - 9] texture] release];
	[[elements objectAtIndex:[elements count] - 9] setTexture:[[Texture2D alloc] initWithString:[NSString stringWithFormat:@"%.1f kly",[theMessier distance]] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	
	float raTmp = (180/M_PI)*atan2f(theMessier.position.y/20,theMessier.position.x/20);
	float decTmp = 90-(180/M_PI)*acosf(theMessier.position.z/20);
	
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
	[[[elements objectAtIndex:[elements count] - 8] texture] release];
	[[elements objectAtIndex:[elements count] - 8] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%ih %im %is",degrees3,minutes3,seconds3] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
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
	
	[[[elements objectAtIndex:[elements count] - 7] texture] release];
	[[elements objectAtIndex:[elements count] - 7] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees4,minutes4,seconds4] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber4 release];
	[minutesNumber4 release];
	[secondsNumber4 release];
	
	Vertex3D posForCam = [theMessier myCurrentPosition];
	float azTmp = (180/M_PI)*atan2(posForCam.y,posForCam.x);
	float alTmp = 90-(180/M_PI)*acos(-posForCam.z); 
	//NSLog(@"test %f",azTmp);
	
	NSNumber * coordinateNumber = [[NSNumber alloc] initWithFloat:360-azTmp];
	int degrees = [coordinateNumber intValue];
	float minutesF = ([coordinateNumber floatValue] - [coordinateNumber intValue]) * 60;
	NSNumber * minutesNumber = [[NSNumber alloc] initWithFloat:minutesF];
	int minutes = [minutesNumber intValue];
	float secondsF = ([minutesNumber floatValue] - [minutesNumber intValue])*60;
	NSNumber * secondsNumber = [[NSNumber alloc] initWithFloat:secondsF];
	int seconds = [secondsNumber intValue];
	
	if (degrees > 360) {
		degrees -= 360;
	}
	
	
	[[[elements objectAtIndex:[elements count] - 6] texture] release];
	[[elements objectAtIndex:[elements count] - 6] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees,minutes,seconds] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
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
	[[[elements objectAtIndex:[elements count] - 5] texture] release];
	[[elements objectAtIndex:[elements count] - 5] setTexture:[[Texture2D alloc] initWithString:[[NSString alloc] initWithFormat:@"%i° %i' %i\"",degrees2,minutes2,seconds2] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[coordinateNumber2 release];
	[minutesNumber2 release];
	[secondsNumber2 release];
	
	/*[[elements objectAtIndex:[elements count] - 6] setTexture:[[Texture2D alloc] initWithString:[theMessier RA] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	 [[elements objectAtIndex:[elements count] - 5] setTexture:[[Texture2D alloc] initWithString:[theMessier declination] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	 */
	[[[elements objectAtIndex:[elements count] - 4] texture] release];
	[[elements objectAtIndex:[elements count] - 4] setTexture:[[Texture2D alloc] initWithString:[NSString stringWithFormat:@"%.1f",[theMessier mag]] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:11]]; 
	[[[elements objectAtIndex:[elements count] - 3] texture] release];
	[[elements objectAtIndex:[elements count] - 3] setTexture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [theMessier name]]]]]; 
	[[[elements objectAtIndex:[elements count] - 1] texture] release];
	[[elements objectAtIndex:[elements count] - 1] setTexture:[[Texture2D alloc] initWithString:[theMessier name] dimensions:CGSizeMake(64,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12]]; 
	[[elements objectAtIndex:[elements count] - 1] setBounds:CGRectMake(311 - [theMessier.name sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]].width / 2, 18,64,32)];
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
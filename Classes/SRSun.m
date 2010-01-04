//
//  SRSun.m
//
//  A part of Sterren.app, planetarium iPhone application.
//  Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//  Use without premission by Mote of Life is not authorised.
//
//  Mote of Life is a registred company at the Dutch Chamber of Commerce.
//  Chamber of Commerce registration number: 37126951
//


#import "SRSun.h"


@implementation SRSun
-(id)init {
	if(self = [super init]) {
		name = [NSString stringWithString:NSLocalizedString(@"Sun",@"")];
		nameTexture = [[Texture2D alloc] initWithString:name dimensions:CGSizeMake(64, 64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:1.0];
	}
	return self;
}

-(void)recalculatePosition:(NSDate *)theDate {
	//http://www.astro.uu.nl/~strous/AA/en/reken/zonpositie.html
	//tijd in dagen berekenen sinds referentie datum
	//we berekenen de Julian day:
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:theDate];
	NSInteger year = [weekdayComponents year];
	NSInteger month = [weekdayComponents month];
	NSInteger day = [weekdayComponents day];
	
	float d = 367*year - (7*(year + ((month+9)/12)))/4 + (275*month)/9 + day - 730530;
	//d = 1552;
	//NSLog(@"day: %f", d + 2451545);
	
	float meanAnomaly = fmod(357.5291 + (0.98560028 * d), 360);
	//NSLog(@"meanAnomaly: %f", meanAnomaly);
	float equationOfCenter = ( 1.9148 * sin((M_PI / 180) * meanAnomaly) ) + ( 0.0200 * sin(2 * (M_PI / 180) * meanAnomaly) ) + ( 0.0003 * sin(3 * (M_PI / 180) * meanAnomaly) ); 
	//NSLog(@"equationOfCenter: %f", equationOfCenter);
	float trueAnomaly = meanAnomaly + equationOfCenter;
	//NSLog(@"trueAnomaly: %f", trueAnomaly);
	float longitudePerihelion = 102.9372;
	//NSLog(@"longitudePerihelion: %f", longitudePerihelion);
	float obliquity = 23.45;
	//NSLog(@"obliquity: %f", obliquity);
	//float eclipticLongitude = trueAnomaly + longitudePerihelion;
	//NSLog(@"eclipticLongitude: %f", eclipticLongitude);
	float eclipticLongitudeSun = fmod(trueAnomaly + longitudePerihelion + 180, 360);
	//NSLog(@"eclipticLongitudeSun: %f", eclipticLongitudeSun);
	float RASun = atan2(sin((M_PI / 180) * eclipticLongitudeSun) * cos((M_PI / 180) * obliquity), cos((M_PI / 180) * eclipticLongitudeSun));
	//NSLog(@"RASun: %f", fmod(RASun * (180 / M_PI) + 360, 360));
	float DecSun = asin(sin((M_PI / 180) * eclipticLongitudeSun) * sin((M_PI / 180) * obliquity));
	//NSLog(@"DecSun: %f", fmod(DecSun * (180 / M_PI), 360));
	
	float X = 16.0f * cos(RASun) * sin((M_PI / 2) - DecSun);
	float Y = 16.0f * sin(RASun) * sin((M_PI / 2) - DecSun);
	float Z = 16.0f * cos((M_PI / 2) - DecSun);
	
	//NSLog(@"X: %f, Y: %f, Z: %F", X,Y,Z);
	
	position = Vertex3DMake(X, Y, Z);
	
	[gregorian release];	
}

-(Vertex3D)positionHelio { 
	return Vertex3DMake(0,0,0);
}


@end

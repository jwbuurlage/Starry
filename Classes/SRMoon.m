//
//  SRMoon.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 07-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRMoon.h"


@implementation SRMoon

@synthesize position;

//http://www.astro.uu.nl/~strous/AA/en/reken/hemelpositie.html#2

-(void)recalculatePosition:(NSDate*)theDate { 
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:theDate];
	float year = [weekdayComponents year];
	float month = [weekdayComponents month];
	float day = [weekdayComponents day];
	float hour = [weekdayComponents hour];
	float minute = [weekdayComponents minute];
	float second = [weekdayComponents second];
	
	//dagen sinds tabel geldig is http://www.astro.uu.nl/~strous/AA/en/reken/hemelpositie.html
	float d = 367*year - (7*(year + ((month+9)/12)))/4 + (275*month)/9 + day - 730530 + ((hour / 24) + (minute / 1440) + (second / 86400));
	//d = 1460.5;
	NSLog(@"d: %f",d);
	
	//positie uitrekenen:
	float geoEclipticLongitude = 218.316 + (13.176396 * d);
	float meanAnomaly = 134.963 + (13.064993 * d);
	float distanceAscNode = 93.272 + (13.229350 * d);
	
	//NSLog(@"geoEclipticLongitude: %f", fmod(geoEclipticLongitude * (180 / M_PI), 360));
	//NSLog(@"meanAnomaly: %f", fmod(meanAnomaly * (180 / M_PI), 360));
	//NSLog(@"distanceAscNode: %f", fmod(distanceAscNode * (180 / M_PI), 360));

	
	float eclipticLongitude = (M_PI / 180) * ( geoEclipticLongitude + (6.289 * sin(meanAnomaly * (M_PI / 180))) );
	float eclipticLatitude = (M_PI / 180) * ( 5.128 * sin(distanceAscNode * (M_PI / 180)) );
	float distance = 385001 - (20905*cos(meanAnomaly * (M_PI / 180)));
	
	//NSLog(@"eclipticLongitude: %f", fmod(eclipticLongitude * (180 / M_PI), 360));
	//NSLog(@"eclipticLatitude: %f", fmod(eclipticLatitude * (180 / M_PI), 360));
	//NSLog(@"distance: %f", distance);

	
	float obliquity = 23.4397 * (M_PI / 180);
	
	float rightAscension = atan2(sin(eclipticLongitude)*cos(obliquity)-tan(eclipticLatitude)*sin(obliquity), cos(eclipticLongitude));
	float declination = asin(sin(eclipticLatitude)*cos(obliquity)+cos(eclipticLatitude)*sin(obliquity)*sin(eclipticLongitude));
	
	declination = (M_PI / 2) - declination;
	
	float x,y,z;
	
	x = 15.0f * cos(rightAscension) * sin(declination);	
	y = 15.0f * sin(rightAscension) * sin(declination);
	z = 15.0f * cos(declination);
	
	position = Vertex3DMake(x, y, z);
	
	[gregorian release];
}

@end

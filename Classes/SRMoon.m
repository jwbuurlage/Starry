//
//  SRMoon.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 07-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRMoon.h"
#import "SterrenAppDelegate.h"


@implementation SRMoon

@synthesize position, phase;

//http://www.astro.uu.nl/~strous/AA/en/reken/hemelpositie.html#2

-(id)init {
	if(self = [super init]) {
		nameTexture = [[Texture2D alloc] initWithString:NSLocalizedString(@"Moon",@"") dimensions:CGSizeMake(64, 64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:1.0];
	}
	return self;
}

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
//<<<<<<< HEAD
//	float d = 367*year - (7*(year + ((month+9)/12)))/4 + (275*month)/9 + day - 730530;
//=======
	float d = 367*year - (7*(year + ((month+9)/12)))/4 + (275*month)/9 + day - 730532 + ((hour / 24) + (minute / 1440) + (second / 86400));
//>>>>>>> 9f88745b713c4df9884b1eded5b2a7473893ea77
	//d = 1460.5;
	NSLog(@"day: %f", d);
	d = 367*year - (7*(year + ((month+9)/12)))/4 + (275*month)/9 + day - 730530 + ((hour / 24) + minute / 1440 + second / 86400);
	NSLog(@"day: %f", d);
	NSLog(@"hour: %f", hour);
	
	//positie uitrekenen:
	float geoEclipticLongitude = 218.316 + (13.176396 * d);
	float meanAnomaly = 134.963 + (13.064993 * d);
	float distanceAscNode = 93.272 + (13.229350 * d);
	
	//NSLog(@"geoEclipticLongitude: %f", fmod(geoEclipticLongitude * (180 / M_PI), 360));
	//NSLog(@"meanAnomaly: %f", fmod(meanAnomaly * (180 / M_PI), 360));
	//NSLog(@"distanceAscNode: %f", fmod(distanceAscNode * (180 / M_PI), 360));

	
	float eclipticLongitude = (M_PI / 180) * ( geoEclipticLongitude + (6.289 * sin(meanAnomaly * (M_PI / 180))) );
	float eclipticLatitude = (M_PI / 180) * ( 5.128 * sin(distanceAscNode * (M_PI / 180)) );
	//float distance = 385001 - (20905*cos(meanAnomaly * (M_PI / 180)));
	
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
		
	//recalculate phase
	//FIXME: phases moeten nog goed.
	
	int c,e;
    double jd;
    int b;
	
    if (month < 3) {
        year--;
        month += 12;
    }
    ++month;
    c = 365.25*year;
    e = 30.6*month;
    jd = c+e+day-694039.09;  /* jd is total days elapsed */
    jd /= 29.53;           /* divide by the moon cycle (29.53 days) */
    b = jd;		   /* int(jd) -> b, take integer part of jd */
    jd -= b;		   /* subtract integer part to leave fractional part of original jd */
    b = jd*8 + 0.5;	   /* scale fraction from 0-8 and round by adding 0.5 */
    b = b & 7;		   /* 0 and 8 are the same so turn 8 into 0 */
	phase = b;
		
	[gregorian release];

}

-(void)draw {
	[nameTexture drawAtVertex:position];
}

-(Vertex3D)myCurrentPosition {
	
	float brX = position.x;
	float brY = position.y;
	float brZ = position.z;
	
	SterrenAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	float latitude = [[appDelegate location] latitude];
	float longitude = [[appDelegate location] longitude];
	float time = [[appDelegate timeManager] elapsed];
	
	float rotationY = -(90-latitude)*(M_PI/180);
	float rotationZ1 = -longitude*(M_PI/180);
	float rotationZ2 = -time*(M_PI/180);
	
	float maX,maY,maZ;
	
	// Matrix vermenigvuldiging met draai om de  z-as (tijd)
	maX = (cos(rotationZ2)*brX+(-sin(rotationZ2)*brY)+0*brZ);
	maY = (sin(rotationZ2)*brX+cos(rotationZ2)*brY+0*brZ);
	maZ = (0*brX+0*brY+1*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	// Matrix vermenigvuldiging met draai om de  z-as (locatie)
	maX = (cos(rotationZ1)*brX+(-sin(rotationZ1)*brY)+0*brZ);
	maY = (sin(rotationZ1)*brX+cos(rotationZ1)*brY+0*brZ);
	maZ = (0*brX+0*brY+1*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	// Matrix vermenigvuldiging met draai om de y-as (locatie)
	maX = (cos(rotationY)*brX+0*brY+sin(rotationY)*brZ);
	maY = (0*brX+1*brY+0*brZ);
	maZ = ((-sin(rotationY)*brX)+0*brY+cos(rotationY)*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	Vertex3D result = Vertex3DMake(-brX/15, -brY/15, -brZ/15);
	
	NSLog(@"Geroteerde locatie planeet berekend x:%f y:%f z:%f",brX/15,brY/15,brZ/15);
	
	return result;
}

@end

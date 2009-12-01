//
//  SRPlanetaryObject.m
//
//  A part of Sterren.app, planitarium iPhone application.
//  Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//  Use without premission by Mote of Life is not authorised.
//
//  Mote of Life is a registred company at the Dutch Chamber of Commerce.
//  Chamber of Commerce registration number: 37126951
//

#import "SRPlanetaryObject.h"


@implementation SRPlanetaryObject

-(id)init {
	if(self = [super init]) {
	
	}
	return self;
}

-(id)initWitha:(float)ia		
			 e:(float)ie		
			 i:(float)ii
			 w:(float)iw
			 o:(float)iO
			Mo:(float)iMo
		  name:(NSString*)iName
{
    
    if(self = [super init]) {
        a = ia;		
        e = ie;		
        i = (ii * (M_PI / 180));
        w = (iw * (M_PI / 180));
        o = (iO * (M_PI / 180));
        Mo = iMo;  
		name = iName;
		
		//!!Texture2D texture* = ..;
    }
    return self;
}

-(void)recalculatePosition:(NSDate*)theDate { 
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:theDate];
	NSInteger year = [weekdayComponents year];
	NSInteger month = [weekdayComponents month];
	NSInteger day = [weekdayComponents day];
	
	//dagen sinds tabel geldig is http://www.astro.uu.nl/~strous/AA/en/reken/hemelpositie.html
	float d = 367*year - (7*(year + ((month+9)/12)))/4 + (275*month)/9 + day - 730530;
	d = d - 2451545;
	//test
	//d = 1460.6;
	
	float n = (M_PI / 180) * (0.9856076686/(a*sqrt(a)));
	//NSLog(@"n: %f",n * (180 / M_PI));
	float meanAnomaly = ((M_PI / 180) * Mo) + n*(d);
	//NSLog(@"meanAnomaly: %f", fmod(meanAnomaly * (180 / M_PI), 360));

	//we lossen Keplers' vergelijking op
	//iteratie tot di te klein is
	float Ea = meanAnomaly; 
	float E;
	float di = 1;
	
	while(di < 10) {
		E = Ea;
		Ea = meanAnomaly + (e*sin(E));
		++di;
	}
	float trueAnomaly = Ea;
	//NSLog(@"trueAnomaly: %f", fmod(trueAnomaly * (180 / M_PI), 360));
	
	float distance = a*(1 - pow(e,2))/(1 + e*cos(trueAnomaly));
	//NSLog(@"Distance: %f",distance);
	
	//graden --> Rad
	float X,Y,Z;
	X = distance * (cos(o)*cos(w + trueAnomaly) - sin(o)*cos(i)*sin(w + trueAnomaly));
	Y = distance * (sin(o)*cos(w + trueAnomaly) + cos(o)*cos(i)*sin(w + trueAnomaly));
	Z = distance * (sin(i) * sin(w + trueAnomaly));
	
	//NSLog(@"(X,Y,Z): (%f,%f,%f)",X,Y,Z);
	
	position = Vertex3DMake(X,Y,Z);
	
	[gregorian release];
}

-(void)setViewOrigin:(Vertex3D)origin {
	float x,y,z; 
	x = position.x - origin.x;
	y = position.y - origin.y;
	z = position.z - origin.z;
	
	//NSLog(@"(x,y,z): (%f,%f,%f)",x,y,z);
	
	float obliquity = 23.4397 * (M_PI / 180);
	
	float distance = (sqrt(pow(x,2)+pow(y,2)+pow(z,2)));
	//NSLog(@"distance: %f", distance);
	
	float eclipticLongitude = atan2(y,x);
	float eclipticLatitude = asin(z/distance);
	//NSLog(@"eclipticLongitude: %f", fmod(eclipticLongitude * (180 / M_PI), 360));
	//NSLog(@"eclipticLatitude: %f", fmod(eclipticLatitude * (180 / M_PI), 360));

	
	float rightAscension = atan2(sin(eclipticLongitude)*cos(obliquity)-tan(eclipticLatitude)*sin(obliquity), cos(eclipticLongitude));
	float declination = asin(sin(eclipticLatitude)*cos(obliquity)+cos(eclipticLatitude)*sin(obliquity)*sin(eclipticLongitude));
	//NSLog(@"rightAscension: %f", fmod(rightAscension * (180 / M_PI) + 360, 360));
	//NSLog(@"declination: %f", fmod(declination * (180 / M_PI), 360));

	declination = (M_PI / 2) - declination;
	
	x = 15.0f * cos(rightAscension) * sin(declination);	
	y = 15.0f * sin(rightAscension) * sin(declination);
	z = 15.0f * cos(declination);
	
	position = Vertex3DMake(x, y, z);
	//NSLog(@"(x,y,z): (%f,%f,%f)",x,y,z);
}

-(Vertex3D)position { 
	return position;
}
						
/* -(float)azimuth {
	return azi;
}

-(float)altitude {
    return alt;
}

-(float)sprite {
	
} */

@end

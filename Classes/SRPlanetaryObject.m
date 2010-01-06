//
//  SRPlanetaryObject.m
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

#import "SRPlanetaryObject.h"
#import "SterrenAppDelegate.h"


@implementation SRPlanetaryObject

@synthesize position, positionHelio, a, name, selected;


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
		
		nameTexture = [[Texture2D alloc] initWithString:NSLocalizedString(name, @"") dimensions:CGSizeMake(64, 64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:1.0];
		
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
	//d = d - 2451545;
	//test
	
	float n = (M_PI / 180) * (0.9856076686/(a*sqrt(a)));
	float meanAnomaly = ((M_PI / 180) * Mo) + n*(d);
	//NSLog(@"meanAnomaly: %f", fmod(meanAnomaly * (180 / M_PI), 360));
	//we lossen Keplers' vergelijking op
	//iteratie tot di te klein is
	float Ea = meanAnomaly; 
	//float Ea = 1.047197551; 
	float E;
	float di = 0;
	
	while(di <= 15) {
		E = Ea;
		Ea = E + ((meanAnomaly + (e*sin(E)) - E)/(1-(e*cos(E))));
		//NSLog(@"Ea: %f",Ea);
		++di;
	}
	
	float eccentricAnomaly = Ea;
	float trueAnomaly = 2*atan(sqrt((1+e)/(1-e))*tan(eccentricAnomaly / 2));
	//NSLog(@"trueAnomaly: %f", fmod(trueAnomaly * (180 / M_PI), 360));

	float distance = a*(1 - pow(e,2))/(1 + e*cos(trueAnomaly));
	
	//graden --> Rad
	float X,Y,Z;
	X = distance * (cos(o)*cos(w + trueAnomaly) - sin(o)*cos(i)*sin(w + trueAnomaly));
	Y = distance * (sin(o)*cos(w + trueAnomaly) + cos(o)*cos(i)*sin(w + trueAnomaly));
	Z = distance * (sin(i) * sin(w + trueAnomaly));
	
	
	positionHelio = Vertex3DMake(X,Y,Z);
	
	[gregorian release];
}

-(void)drawHelio:(BOOL)helio {
	if(helio) { [nameTexture drawAtVertex:Vertex3DMake(positionHelio.x, positionHelio.y, positionHelio.z)]; }
	else { [nameTexture drawAtVertex:Vertex3DMake(position.x, position.y, position.z)]; }
}

-(void)setViewOrigin:(Vertex3D)origin {
	float x,y,z; 
	x = positionHelio.x - origin.x;
	y = positionHelio.y - origin.y;
	z = positionHelio.z - origin.z;
	
	
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

/*-(Vertex3D)position { 
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

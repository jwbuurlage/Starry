//
//  SRLocation.m
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


#import "SRLocation.h"

@implementation SRLocation

@synthesize locationManager,latitude,longitude,staticValues;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
		myLocation = [[CLLocation alloc] init];
		
		// Locatie opvragen van vorige keer
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		staticValues = [prefs boolForKey:@"SRstaticCoordinates"];
		
		if (staticValues) {
			longitude = [prefs floatForKey:@"SRlong"];
			latitude = [prefs floatForKey:@"SRlat"];
		}
		else {
			[self useGPSValues];
		}
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Ik ben nu hier: %@", [newLocation description]);
	
	myLocation = newLocation;
	longitude = myLocation.coordinate.longitude;
	latitude = myLocation.coordinate.latitude;
	
	
	//NSLog(@"Longitude van GPS: %f",longitude);
	//NSLog(@"Latitude van GPS: %f",latitude);
	
	/* Debug values */
	//longitude = 4.874036;
	//latitude = 52.741535;
	//NSLog(@"Debug, setting longitude and latitude naar die van Schagen");
	
	if(interfaceDelegate) {
		[interfaceDelegate updateDisplayedLocationData];
	}
	
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	//NSLog(@"SRLocation Error: %@", [error description]);
}

- (void)makeAwareOfInterface:(id)aInterface {
	interfaceDelegate = aInterface;
	/* Misschien in de toekomst een array maken voor medere interfaces, bijvoorbeeld voor een lijst met plaatsten */
}

/*// Getter's met log het debuggen

- (float)longitude {
	NSLog(@"LocationManager is giving longitude:%f",longitude);
	return longitude;
}

- (float)latitude {
	NSLog(@"LocationManager is giving latitude:%f",latitude);
	return latitude;
}*/

// Dealloc

-(void)useStaticValues {
	// Als er geen locatie service is kan deze ook niet worden uitgezet
	//if ([locationManager locationServicesEnabled]) {
		[locationManager stopUpdatingLocation];
		staticValues = YES;
	//}
}

-(void)useGPSValues {
	if ([locationManager locationServicesEnabled]) {
		[locationManager startUpdatingLocation];
		staticValues = NO;
	}
	else {
		NSLog(@"No location data allowed");
		staticValues = YES;
	}
}

- (void)dealloc {
    [locationManager release];
	[myLocation release];
    [super dealloc];
}

-(void)setLatitude:(float)latValue {
	
	if (staticValues) {
		NSLog(@"Latitude is set to the static value of:%f",latValue);
		latitude = latValue;
		[interfaceDelegate updateDisplayedLocationData];
	}
}

-(void)setLongitude:(float)longValue {
	if (staticValues) {
		NSLog(@"Longitude is set to the static value of:%f",longValue);
		longitude = longValue;
		[interfaceDelegate updateDisplayedLocationData];
	}
}

@end

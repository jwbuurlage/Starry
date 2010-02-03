//
//  SRLocation.h
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


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GLView.h"
#import "OpenGLCommon.h"
//#import "SRLocationModule.h"

@interface SRLocation : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *	locationManager;
	CLLocation *		myLocation;
	
	id interfaceDelegate;
	float longitude;
	float latitude;
	BOOL staticValues;
	
	float heading;
}

@property (nonatomic, retain) CLLocationManager *locationManager; 
@property (readwrite, assign) float longitude;
@property (readwrite, assign) float latitude;
@property (readonly) BOOL staticValues;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


- (void)makeAwareOfInterface:(id)aInterface;
- (void)useStaticValues;
- (void)useGPSValues;


@end

//
//  SRLocationModule.h
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
#import "SRModule.h"
#import "SRInterfaceElement.h"
#import "SRLocation.h"
#import "Texture2D.h"

@interface SRLocationModule : SRModule {
	SRLocation* locationManager;
	
	float longitude;
	float latitude;
	
	BOOL latVisible;
	BOOL longVisible;
	
	BOOL GPS;
}

@property (readonly) float latitude;
@property (readonly) float longitude;
@property (readonly) SRLocation* locationManager;
@property (readwrite) BOOL latVisible;
@property (readwrite) BOOL longVisible;
@property (readonly) BOOL GPS;

-(id)initWithSRLocation:(SRLocation*)aLocation;
-(void)updateDisplayedLocationData;

-(void)toggleGPS;

/*-(void)hideLongitude;
-(void)showLongitude;
-(void)hideLatitude;
-(void)showLatitude;*/

@end

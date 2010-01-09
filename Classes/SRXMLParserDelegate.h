//
//  SRXMLParserDelegate.h
//  Sterren
//
//  Created by Thijs Scheepers on 09-01-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import "AQXMLParserDelegate.h"
#import "SRObjectManager.h";


@interface SRXMLParserDelegate : AQXMLParserDelegate {
	NSMutableString *currentElementValue;
	
	//SterrenAppDelegate *appDelegate;
	SRObjectManager *objectManager;
	SRStar *aStar;
	SRMessier*aMessier;
	SRConstellation *aConstellation;
	SRConstellationLine *aLine;
	Vector3D aPoint;
	
	BOOL stars; //1 = sterren, 0 = sterrenbeelden
	BOOL constellations;
	BOOL messier;
	BOOL start; //1 = start, 0 = end
}

-(void)startStarsWithAttributes: (NSDictionary *) attrs;
-(void)startStarWithAttributes: (NSDictionary *) attrs;
-(void)endStar;
-(void)endX;
-(void)endY;
-(void)endZ;
-(void)endMag;
-(void)endCi;

@end

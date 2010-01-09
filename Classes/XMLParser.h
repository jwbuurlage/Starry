//
//	XMLParser.h
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



#import <UIKit/UIKit.h>
#import "SRObjectManager.h";
#import "AQXMLParserDelegate.h";

@class SterrenAppDelegate, SRStar;

@interface XMLParser : AQXMLParserDelegate {
	
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

- (XMLParser *) initXMLParser;

@end

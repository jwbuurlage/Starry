//
//	XMLParser.m
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


#import "XMLParser.h"
//#import "SterrenAppDelegate.h"
#import "SRStar.h"
#import "SRConstellation.h"

@implementation XMLParser

- (XMLParser *) initXMLParser {
	
	[super init];
	
	//NSLog(@"test parser0");
	stars = FALSE;
	constellations = FALSE;
	messier = FALSE;
	start = TRUE;
	objectManager = [[[UIApplication sharedApplication] delegate] objectManager];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	
	if([elementName isEqualToString:@"stars"]) { // Hoofd tag gevonden, Array initializen
		stars = TRUE;
		NSLog(@"Init stars");
		//objectManager.stars = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"constellations"]) {
		constellations = TRUE;
		NSLog(@"Init const");
		//objectManager.constellations = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"messier"]) {
		messier = TRUE;
		NSLog(@"Init mess");
		//objectManager.constellations = [[NSMutableArray alloc] init];
	}
	
	if(stars) {
		if([elementName isEqualToString:@"star"]) {
			aStar = [[SRStar alloc] init];
			aStar.starID = [[attributeDict objectForKey:@"id"] integerValue];
		
			//NSLog(@"Reading id value :%i", aStar.starID);
		}
	}
	else if(constellations) {
		if([elementName isEqualToString:@"constellation"]) {
			aConstellation = [[SRConstellation alloc] init];
			aConstellation.lines = [[NSMutableArray alloc] init];
		}
		if([elementName isEqualToString:@"line"]) {
			aLine = [[SRConstellationLine alloc] init];
		}
		if([elementName isEqualToString:@"point"]) {
			aPoint = Vector3DMake(0,0,0);
		}
		//NSLog(@"Reading id value :%i", aStar.starID);
	}
	else if(messier) {
		if([elementName isEqualToString:@"object"]) {
			aMessier = [[SRMessier alloc] init];
		}
		if([elementName isEqualToString:@"point"]) {
			aPoint = Vector3DMake(0,0,0);
		}
	}
	
	//NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	//NSLog(@"test parser2");
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	//NSLog(@"Processing Value: %@", currentElementValue);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	//NSLog(@"test parser3");
	if(stars) {
		if([elementName isEqualToString:@"stars"])
			return;
	
		else if([elementName isEqualToString:@"star"]) {
			[objectManager.stars addObject:aStar];
		
			[aStar release];
			aStar = nil;
		}
		else if([elementName isEqualToString:@"x"]) {
			aPoint.x = [currentElementValue floatValue];
		}
		else if([elementName isEqualToString:@"y"]) {
			aPoint.y = [currentElementValue floatValue];
		}		
		else if([elementName isEqualToString:@"z"]) {
			aPoint.z = [currentElementValue floatValue];
			[aStar setPosition:aPoint];
		}	
		else if([elementName isEqualToString:@"mag"]) {
			[aStar setMag:[currentElementValue floatValue]];
		}			
		else if([elementName isEqualToString:@"ci"]) {
			[aStar setCi:[currentElementValue floatValue]];
		}	
		else {
			[aStar setValue:currentElementValue forKey:elementName];
		}
		
	}
	else if (constellations) {
		if([elementName isEqualToString:@"constellations"])
			return;
		
		else if([elementName isEqualToString:@"constellation"]) {
			[aConstellation calculateRADec];
			[aConstellation makeArray];
			[objectManager.constellations addObject:aConstellation];
			
			[aConstellation release];
			aConstellation = nil;
		}
		else if([elementName isEqualToString:@"line"]) {
			[aConstellation.lines addObject:aLine];
			
			[aLine release];
			aLine = nil;
		}
		else if([elementName isEqualToString:@"point"]) {
			if(start) {
				aLine.start = aPoint;
				start = FALSE;
			}
			else {
				aLine.end = aPoint;
				start = TRUE;
			}
		}
		else if([elementName isEqualToString:@"name"]) {
			aConstellation.name = currentElementValue;
		}
		else if([elementName isEqualToString:@"ra"]) {
			aConstellation.ra = [currentElementValue floatValue];
		}
		else if([elementName isEqualToString:@"dec"]) {
			aConstellation.dec = [currentElementValue floatValue];
		}
		else if([elementName isEqualToString:@"x"]) {
			aPoint.x = [currentElementValue floatValue];
		}
		else if([elementName isEqualToString:@"y"]) {
			aPoint.y = [currentElementValue floatValue];
		}		
		else if([elementName isEqualToString:@"z"]) {
			aPoint.z = [currentElementValue floatValue];
		}
	}
	else if (messier) {
		if([elementName isEqualToString:@"messier"])
			return;
		
		else if([elementName isEqualToString:@"object"]) {
			[objectManager.messier addObject:aMessier];
			
			[aMessier release];
			aMessier = nil;
		}
		else if([elementName isEqualToString:@"point"]) {
			aMessier.position = aPoint;
		}
		else if([elementName isEqualToString:@"name"]) {
			[aMessier setName:currentElementValue];
		}
		else if([elementName isEqualToString:@"mag"]) {
			[aMessier setMag:[currentElementValue floatValue]];
		}
		else if([elementName isEqualToString:@"constellation"]) {
			[aMessier setConstellation:currentElementValue];
		}		
		else if([elementName isEqualToString:@"type"]) {
			if([currentElementValue isEqualToString:@"1"]) { [aMessier setType:@"MT_1"]; }
			if([currentElementValue isEqualToString:@"2"]) { [aMessier setType:@"MT_2"]; }
			if([currentElementValue isEqualToString:@"3"]) { [aMessier setType:@"MT_3"]; }
			if([currentElementValue isEqualToString:@"4"]) { [aMessier setType:@"MT_4"]; }
			if([currentElementValue isEqualToString:@"5"]) { [aMessier setType:@"MT_5"]; }
			if([currentElementValue isEqualToString:@"6"]) { [aMessier setType:@"MT_6"]; }
			if([currentElementValue isEqualToString:@"7"]) { [aMessier setType:@"MT_7"]; }
			if([currentElementValue isEqualToString:@"8"]) { [aMessier setType:@"MT_8"]; }
			if([currentElementValue isEqualToString:@"9"]) { [aMessier setType:@"MT_9"]; }
			if([currentElementValue isEqualToString:@"A"]) { [aMessier setType:@"MT_A"]; }
			if([currentElementValue isEqualToString:@"B"]) { [aMessier setType:@"MT_B"]; }
			if([currentElementValue isEqualToString:@"C"]) { [aMessier setType:@"MT_C"]; }
		}
		else if([elementName isEqualToString:@"ra"]) {
			[aMessier setRA:currentElementValue];
		}
		else if([elementName isEqualToString:@"dec"]) {
			[aMessier setDeclination:currentElementValue];
		}
		else if([elementName isEqualToString:@"distance"]) {
			[aMessier setDistance:[currentElementValue floatValue]];
		}
		else if([elementName isEqualToString:@"x"]) {
			aPoint.x = [currentElementValue floatValue];
		}
		else if([elementName isEqualToString:@"y"]) {
			aPoint.y = [currentElementValue floatValue];
		}		
		else if([elementName isEqualToString:@"z"]) {
			aPoint.z = [currentElementValue floatValue];
		}
	}
	
	[currentElementValue release];
	currentElementValue = nil;
}

- (void) dealloc {
	[aConstellation release];
	[aLine release];
	[aStar release];
	[currentElementValue release];
	[super dealloc];
}

@end
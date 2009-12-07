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
		else {
			[aStar setValue:currentElementValue forKey:elementName];
		}
	}
	else if (constellations) {
		if([elementName isEqualToString:@"constellations"])
			return;
		
		else if([elementName isEqualToString:@"constellation"]) {
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
//
//	XMLParser.m
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


#import "XMLParser.h"
#import "SterrenAppDelegate.h"
#import "SRStar.h"

@implementation XMLParser

- (XMLParser *) initXMLParser {
	
	[super init];
	
	//NSLog(@"test parser0");
	
	appDelegate = [[UIApplication sharedApplication] delegate];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	//NSLog(@"test parser1");
	
	if([elementName isEqualToString:@"stars"]) { // Hoofd tag gevonden, Array initializen
		
		//NSLog(@"Init stars");
		appDelegate.stars = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"star"]) {
		aStar = [[SRStar alloc] init];
		aStar.starID = [[attributeDict objectForKey:@"id"] integerValue];
		
		//NSLog(@"Reading id value :%i", aStar.starID);
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
	
	if([elementName isEqualToString:@"stars"])
		return;
	
	if([elementName isEqualToString:@"star"]) {
		[appDelegate.stars addObject:aStar];
		
		[aStar release];
		aStar = nil;
	}
	else
		[aStar setValue:currentElementValue forKey:elementName];
	
	[currentElementValue release];
	currentElementValue = nil;
}

- (void) dealloc {
	
	[aStar release];
	[currentElementValue release];
	[super dealloc];
}

@end
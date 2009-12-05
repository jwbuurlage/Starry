//
//  SRObjectManager.m
//  Sterren
//
//  Created by Thijs Scheepers on 05-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRObjectManager.h"
#import "XMLParser.h"


@implementation SRObjectManager

@synthesize stars,constellations;

-(id)init {
    
    if(self = [super init]) {
		stars = [[NSMutableArray alloc] init];
		constellations = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseData {
	NSData * data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"stars" ofType: @"xml"]];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
	XMLParser *parser = [[XMLParser alloc] initXMLParser];
	[xmlParser setDelegate:parser];
	BOOL success = [xmlParser parse];
	
	if(success) {
		NSLog(@"Sterren Parse completed");
	}
	else {
		NSLog(@"Sterren Parse error");
	}
	
	NSData * dataConstellations = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"constellations" ofType: @"xml"]];
	NSXMLParser *xmlParserConstellations = [[NSXMLParser alloc] initWithData:dataConstellations];
	XMLParser *parserConstellations = [[XMLParser alloc] initXMLParser];
	[xmlParserConstellations setDelegate:parserConstellations];
	success = [xmlParserConstellations parse];
	
	if(success) {
		NSLog(@"Constellations Parse completed");
	}
	else {
		NSLog(@"Constellations Parse error"); 
	}
	
}

@end

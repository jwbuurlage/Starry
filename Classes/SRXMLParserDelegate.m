//
//  SRXMLParserDelegate.m
//  Sterren
//
//  Created by Thijs Scheepers on 09-01-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

#import "SRXMLParserDelegate.h"


@implementation SRXMLParserDelegate

- (id) init {
	
	[super init];
	
	//NSLog(@"test parser0");
	stars = FALSE;
	constellations = FALSE;
	messier = FALSE;
	start = TRUE;
	objectManager = [[[UIApplication sharedApplication] delegate] objectManager];
	
	return self;
}

-(void)startStarsWithAttributes: (NSDictionary *) attrs {
	stars = TRUE;
	NSLog(@"[NIEUW] Start sterren-pars");
}

-(void)startStarWithAttributes: (NSDictionary *) attrs {
	aStar = [[SRStar alloc] init];
	aStar.starID = [[attrs objectForKey:@"id"] integerValue];
}

-(void)endStar {
	//NSLog(@"name: %i",aStar.starID);
	[objectManager.stars addObject:aStar];
	
	[aStar release];
	aStar = nil;
}

-(void)endX {
	if(stars) {
		aPoint.x = [self.characters floatValue];
	}
}

-(void)endY {
	if(stars) {
		aPoint.y = [self.characters floatValue];
	}
}

-(void)endZ {
	if(stars) {
		aPoint.z = [self.characters floatValue];
		[aStar setPosition:aPoint];
	}
}

-(void)endMag {
	[aStar setMag:[self.characters floatValue]];
}

-(void)endCi {
	[aStar setCi:[self.characters floatValue]];
}

-(void)endName {
	[aStar setName:self.characters];
}

-(void)endBayer {
	[aStar setBayer:self.characters];
}

-(void)endGliese {
	[aStar setGliese:self.characters];
}

-(void)endHip {
	[aStar setHip:self.characters];
}


/*-(void)startConstellationsWithAttributes: (NSDictionary *) attrs {
	constellations = TRUE;
	NSLog(@"Start constellations-pars");
}

-(void)startConstellationsWithAttributes: (NSDictionary *) attrs {
	messier = TRUE;
	NSLog(@"Start messier-pars");
}*/


@end

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

@synthesize constellations,constellationNum,constellationPoints,
			planets,planetNum,planetPoints,
			stars,starNum,starPoints,
			sun;

-(id)init {
    
    if(self = [super init]) {
		stars = [[NSMutableArray alloc] init];
		constellations = [[NSMutableArray alloc] init];
		planets = [[NSMutableArray alloc] init];
		
		//appDelegate = [[UIApplication sharedApplication] delegate];
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

-(void)buildPlanetData {
	if ([planets count] < 1) {
		
		sun = [[SRSun alloc] init];
		//[planets addObject:sun];
		//[sun release];
		
		SRPlanetaryObject *earth = [[SRPlanetaryObject alloc] initWitha:1.00000	
											   e:0.01671	
											   i:0.000
											   w:288.064
											   o:174.873
											  Mo:357.529
											name:@"Aarde"];
		[planets addObject:earth];
		[earth release];
	
		SRPlanetaryObject *jupiter = [[SRPlanetaryObject alloc] initWitha:5.20260		
												 e:0.04849		
												 i:1.303
												 w:273.867
												 o:100.464
												Mo:20.020
											  name:@"Jupiter"];
		[planets addObject:jupiter];
		[jupiter release];
		
		SRPlanetaryObject *mercury = [[SRPlanetaryObject alloc] initWitha:0.38710		
												 e:0.20563		
												 i:7.005
												 w:29.125
												 o:48.331
												Mo:174.795
											  name:@"Mercurius"];
		[planets addObject:mercury];
		[mercury release];
	
		SRPlanetaryObject *venus = [[SRPlanetaryObject alloc] initWitha:0.72333		
											   e:0.00677		
											   i:3.395
											   w:54.884
											   o:76.680
											  Mo:50.416
											name:@"Venus"];
		[planets addObject:venus];
		[venus release];
	
		SRPlanetaryObject *mars = [[SRPlanetaryObject alloc] initWitha:1.52368		
											  e:0.09340		
											  i:1.850
											  w:286.502
											  o:49.558
											 Mo:19.373
										   name:@"Mars"];
		[planets addObject:mars];
		[mars release];
	
		SRPlanetaryObject *saturn = [[SRPlanetaryObject alloc] initWitha:9.55491		
												e:0.05551		
												i:2.489
												w:339.391
												o:113.666
											   Mo:317.021
											 name:@"Saturnus"];
		[planets addObject:saturn];
		[saturn release];
	
		SRPlanetaryObject *uranus = [[SRPlanetaryObject alloc] initWitha:19.21845		
												e:0.04630		
												i:0.773
												w:98.999
												o:74.006
											   Mo:141.050
											 name:@"Uranus"];
		[planets addObject:uranus];
		[uranus release];
	
		SRPlanetaryObject *neptune = [[SRPlanetaryObject alloc] initWitha:30.11039		
												 e:0.00899		
												 i:1.770
												 w:276.340
												 o:131.784
												Mo:256.225
											  name:@"Neptunus"];
	
		[planets addObject:neptune];
		[neptune release];
	
		//
	}
	
	[sun recalculatePosition:[[[[UIApplication sharedApplication] delegate] timeManager] simulatedDate]];
	
	SRPlanetaryObject *planet;
	
	for (planet in planets) {
		[planet recalculatePosition:[[[[UIApplication sharedApplication] delegate] timeManager] simulatedDate]];
		if (planet.a != 1) {
			[planet setViewOrigin:[[planets objectAtIndex:0] position]];
		}
	}
	
	const GLfloat planetPointsTmp[] = {
		// de Zon
		[sun position].x, [sun position].y, [sun position].z,																	1.0, 1.0, 0.0, 1.0, 70.0,
		// Jupiter
		[[planets objectAtIndex:1] position].x, [[planets objectAtIndex:1] position].y, [[planets objectAtIndex:1] position].z,	1.0, 1.0, 1.0, 1.0, 30.0,
		// Mars
		[[planets objectAtIndex:4] position].x, [[planets objectAtIndex:4] position].y, [[planets objectAtIndex:4] position].z,	1.0, 1.0, 1.0, 1.0, 25.0,
		// Mercurius
		[[planets objectAtIndex:2] position].x, [[planets objectAtIndex:2] position].y, [[planets objectAtIndex:2] position].z,	1.0, 1.0, 1.0, 1.0, 20.0,
		// Venus
		[[planets objectAtIndex:3] position].x, [[planets objectAtIndex:3] position].y, [[planets objectAtIndex:3] position].z,	1.0, 1.0, 1.0, 1.0, 30.0,
		//Saturnus
		[[planets objectAtIndex:5] position].x, [[planets objectAtIndex:5] position].y, [[planets objectAtIndex:5] position].z,	1.0, 1.0, 1.0, 1.0, 17.0,
		// Uranus
		[[planets objectAtIndex:6] position].x, [[planets objectAtIndex:6] position].y, [[planets objectAtIndex:6] position].z,	1.0, 1.0, 1.0, 1.0, 10.0,
		// Neptunus
		[[planets objectAtIndex:7] position].x, [[planets objectAtIndex:7] position].y, [[planets objectAtIndex:7] position].z,	1.0, 1.0, 1.0, 1.0, 10.0
	};
	
	planetNum = 8;
	
	if (planetPoints) {
		[planetPoints release];
	}
	planetPoints = [[NSMutableArray alloc] init];
	
	for (int i=0; i < planetNum*8; i++) {
		[planetPoints addObject:[NSNumber numberWithFloat:planetPointsTmp[i]]];
		//NSLog(@"%i", i);
	}
}

-(void)buildStarData {
	starNum = 0;
	GLfloat starPointsTmp[[stars count]*8];
	int matrixStartPos;
	float size;
	float alpha;
	SRStar * star;
	
	for(star in stars) {
		//NSLog(@"Loading star %@",star.name);
		if(star.name != @"Sol") {
			
			size = [star size];
			alpha = [star alpha];
			
			//starColor color = ;
			
			matrixStartPos = starNum * 8;
			starPointsTmp[matrixStartPos] = [star.x floatValue];
			starPointsTmp[matrixStartPos+1] = [star.y floatValue];
			starPointsTmp[matrixStartPos+2] = [star.z floatValue];
			starPointsTmp[matrixStartPos+3] = [star color].red;
			starPointsTmp[matrixStartPos+4] = [star color].green;
			starPointsTmp[matrixStartPos+5] = [star color].blue;
			starPointsTmp[matrixStartPos+6] = [star alpha];
			starPointsTmp[matrixStartPos+7] = size;
			starNum++;
		}
	}
	
	if (starPoints) {
		[starPoints release];
	}
	starPoints = [[NSMutableArray alloc] init];
	
	for (int i=0; i < starNum*8; i++) {
		[starPoints addObject:[NSNumber numberWithFloat:starPointsTmp[i]]];
		//NSLog(@"%i", i);
	}
}

-(void)buildConstellationData {
	
	constellationNum = 0;
	GLfloat constellationPointsTmp[5000];
	int lineCount = 0;
	SRConstellation * constellation;
	SRConstellationLine * line;
	
	for(constellation in constellations) {
		for(line in constellation.lines) {
			constellationPointsTmp[lineCount] = line.start.x;
			constellationPointsTmp[lineCount+1] = line.start.y;
			constellationPointsTmp[lineCount+2] = line.start.z;
			constellationPointsTmp[lineCount+3] = line.end.x;
			constellationPointsTmp[lineCount+4] = line.end.y;
			constellationPointsTmp[lineCount+5] = line.end.z;
			lineCount += 6;
		}
		++constellationNum;
	}
	
	constellationNum = lineCount;
	
	if (constellationPoints) {
		[constellationPoints release];
	}
	constellationPoints = [[NSMutableArray alloc] init];
	
	for (int i=0; i <= lineCount; i++) {
		[constellationPoints addObject:[NSNumber numberWithFloat:constellationPointsTmp[i]]];
		//NSLog(@"%i", i);
	}
}

@end

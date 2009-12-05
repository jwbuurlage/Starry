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

@synthesize stars,constellations,planetNum,planetPoints;

-(id)init {
    
    if(self = [super init]) {
		stars = [[NSMutableArray alloc] init];
		constellations = [[NSMutableArray alloc] init];
		planets = [[NSMutableArray alloc] init];
		planetPoints = [[NSMutableArray alloc] init];
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
	
	Vertex3D earthPosition = [[planets objectAtIndex:0] position];
	SRPlanetaryObject *planet;
	
	for (planet in planets) {
		[planet recalculatePosition:[[[[UIApplication sharedApplication] delegate] timeManager] simulatedDate]];
		if (planet.a != 1) {
			[planet setViewOrigin:earthPosition];
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
	
	for (int i=0; i < planetNum*8; i++) {
		[planetPoints addObject:[NSNumber numberWithFloat:planetPointsTmp[i]]];
		//NSLog(@"%i", i);
	}
}

/*-(NSMutableArray*)planetPoints{
	NSMutableArray *array;
	array = [[NSMutableArray alloc] init];
	float point;
	for(point in planetPoints) {
		[array addObject:[NSNumber numberWithFloat:point]];
	}
	//[array release];
	//GLfloat* pointer = (GLfloat *)malloc(sizeof(GLfloat)*56);
	//pointer = planetPoints;
	return array;
}*/

@end

//
//  SRRenderer.m
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


#import "SRRenderer.h"
#import "GLViewController.h"

@implementation SRRenderer

@synthesize interface,location,myOwner;

-(id)setupWithOwner:(GLViewController*)theOwner {
	if(self = [super init]) {
		//setup renderer.. 		
		myOwner = theOwner;
		camera = [theOwner camera];
			/* Location moet voor interface zodat interface weet van location */
		location = [[SRLocation alloc] init];
			//Zorg dat de appDelegate weet van location zodat deze hem later kan opslaan
		[[[UIApplication sharedApplication] delegate] setLocation:location];
		//[location useGPSValues]; // dit moet gebeuren in de init van location vanwege static locations
		interface = [[SRInterface alloc] initWithRenderer:self];
		
		glGenTextures(20, &textures[0]);
		[interface loadTexture:@"horizon_bg.png" intoLocation:textures[0]];
		[interface loadTextureWithString:@"Z" intoLocation:textures[1]];
		[interface loadTextureWithString:@"W" intoLocation:textures[2]];		
		[interface loadTextureWithString:@"N" intoLocation:textures[3]];
		[interface loadTextureWithString:@"O" intoLocation:textures[4]];
		
		[interface loadTexture:@"sun.png" intoLocation:textures[5]];
		[interface loadTexture:@"planet.png" intoLocation:textures[6]];
		[interface loadTexture:@"planet.png" intoLocation:textures[7]];
		[interface loadTexture:@"planet.png" intoLocation:textures[8]];
		[interface loadTexture:@"planet.png" intoLocation:textures[9]];
		[interface loadTexture:@"planet.png" intoLocation:textures[10]];
		[interface loadTexture:@"planet.png" intoLocation:textures[11]];
		[interface loadTexture:@"planet.png" intoLocation:textures[12]];
		
		textTest = [[NSMutableArray alloc] init];
		[textTest addObject:[[Texture2D alloc] initWithString:@"Zon" dimensions:CGSizeMake(64,64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:10]];
		[textTest addObject:[[Texture2D alloc] initWithString:@"Jupiter" dimensions:CGSizeMake(64,64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:10]];
		[textTest addObject:[[Texture2D alloc] initWithString:@"Mars" dimensions:CGSizeMake(64,64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:10]];
		[textTest addObject:[[Texture2D alloc] initWithString:@"Mercurius" dimensions:CGSizeMake(64,64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:10]];
		[textTest addObject:[[Texture2D alloc] initWithString:@"Venus" dimensions:CGSizeMake(64,64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:10]];
		[textTest addObject:[[Texture2D alloc] initWithString:@"Saturnus" dimensions:CGSizeMake(64,64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:10]];
		[textTest addObject:[[Texture2D alloc] initWithString:@"Uranus" dimensions:CGSizeMake(64,64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:10]];
		[textTest addObject:[[Texture2D alloc] initWithString:@"Neptunus" dimensions:CGSizeMake(64,64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:10]];

				
		NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
		
		brightnessFactor = [prefs floatForKey:@"brightness"];
		if(brightnessFactor <= 0) {
			brightnessFactor = 1.0;
			[prefs setFloat:brightnessFactor forKey:@"brightness"];
		}
		constellations = [prefs boolForKey:@"constellations"];
		
		// set de appdelegate
		appDelegate = [[UIApplication sharedApplication] delegate];
		
		earth = [[SRPlanetaryObject alloc] initWitha:1.00000	
												   e:0.01671	
												   i:0.000
												   w:288.064
												   o:174.873
												  Mo:357.529
												name:@"Aarde"];
		
		//jupiter test
		jupiter = [[SRPlanetaryObject alloc] initWitha:5.20260		
													 e:0.04849		
													 i:1.303
													 w:273.867
													 o:100.464
													Mo:20.020
												  name:@"Jupiter"];
		
		mercury = [[SRPlanetaryObject alloc] initWitha:0.38710		
													 e:0.20563		
													 i:7.005
													 w:29.125
													 o:48.331
													Mo:174.795
												  name:@"Mercurius"];
		
		venus = [[SRPlanetaryObject alloc] initWitha:0.72333		
													 e:0.00677		
													 i:3.395
													 w:54.884
													 o:76.680
													Mo:50.416
												  name:@"Venus"];
		
		mars = [[SRPlanetaryObject alloc] initWitha:1.52368		
													 e:0.09340		
													 i:1.850
													 w:286.502
													 o:49.558
													Mo:19.373
												  name:@"Mars"];
		
		saturn = [[SRPlanetaryObject alloc] initWitha:9.55491		
													 e:0.05551		
													 i:2.489
													 w:339.391
													 o:113.666
													Mo:317.021
												  name:@"Saturnus"];
		
		uranus = [[SRPlanetaryObject alloc] initWitha:19.21845		
													 e:0.04630		
													 i:0.773
													 w:98.999
													 o:74.006
													Mo:141.050
												  name:@"Uranus"];
		
		neptune = [[SRPlanetaryObject alloc] initWitha:30.11039		
													e:0.00899		
													i:1.770
													w:276.340
													o:131.784
												   Mo:256.225
												 name:@"Neptunus"];
		
		
		sun = [[SRSun alloc] init];
		
		[self recalculatePlanetaryPositions];
		
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity(); 
		glEnable(GL_DEPTH_TEST);

		starNum = 0;
		GLfloat starPointsTmp[[appDelegate.stars count]*8];
		int matrixStartPos;
		float size;
		float alpha;
		SRStar * star;
		
		for(star in appDelegate.stars) {
			//NSLog(@"Loading star %@",star.name);
			if(star.name != @"Sol") {
			if([star.mag floatValue] < 1) {
				size = 4.0;
				alpha = 1.0;
			}
			else if([star.mag floatValue] < 2) {
				size = 3.5;
				alpha = 0.7;
			}
			else if([star.mag floatValue] < 3) {
				size = 2.5;
				alpha = 0.6;
			}
			else if([star.mag floatValue] < 4) {
				size = 2.0;
				alpha = 0.5;
			}
			else {
				size = 0.8;
				alpha = 0.4;
			}
			
			matrixStartPos = starNum * 8;
			starPointsTmp[matrixStartPos] = [star.x floatValue];
			starPointsTmp[matrixStartPos+1] = [star.y floatValue];
			starPointsTmp[matrixStartPos+2] = [star.z floatValue];
			starPointsTmp[matrixStartPos+3] = 0.9;
			starPointsTmp[matrixStartPos+4] = 0.9;
			starPointsTmp[matrixStartPos+5] = 0.9;
			starPointsTmp[matrixStartPos+6] = alpha;
			starPointsTmp[matrixStartPos+7] = size;
			starNum++;
			}
		}
		
		for (int i=0; i <= starNum*8; i++) {
			starPoints[i] = starPointsTmp[i];
		}
		
		constellationNum = 0;
		GLfloat constellationPointsTmp[5000];
		int i = 0;
		SRConstellation * constellation;
		SRConstellationLine * line;
		
		for(constellation in appDelegate.constellations) {
			for(line in constellation.lines) {
				constellationPointsTmp[i] = line.start.x;
				constellationPointsTmp[i+1] = line.start.y;
				constellationPointsTmp[i+2] = line.start.z;
				constellationPointsTmp[i+3] = line.end.x;
				constellationPointsTmp[i+4] = line.end.y;
				constellationPointsTmp[i+5] = line.end.z;
				i += 6;
			}
			++constellationNum;
		}
				
		
		constellationNum = i;
		
		for (int a=0; a <= i; a++) {
			constellationPoints[a] = constellationPointsTmp[a];
		}
	}
	return self;
}

-(void)render {
	glEnable(GL_POINT_SMOOTH);
	glEnable (GL_LINE_SMOOTH);

	zoomFactor = [camera zoomingValue];
	
	//view resetten
    glLoadIdentity();
		
	//omzetten van opengl assenstelsel, naar een RH normaal assenstelsel
	glRotatef(-90.0, 1.0, 0.0, 0.0); //RH coordinaten systeem 
	glRotatef(-90.0, 0.0, 0.0, 1.0); //daarom is hij min -> z staat nu naar boven toe ( - --> + )
	glRotatef(180.0, 1.0, 0.0, 0.0); //daarom is hij min -> z staat nu naar boven toe ( - --> + )
	
	//landscape mode - roteren zodat y weer verticaal is en x horizontaal
	glRotatef(90.0, 1.0, 0.0, 0.0);
	
	//camera positie callen
	[camera adjustView];
	
	glEnable(GL_ALPHA_TEST);
	glAlphaFunc(GL_GREATER, 0.0f);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
    glClearColor(0.0, 0.10, 0.16, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_VERTEX_ARRAY);
	
	[self adjustViewToLocationAndTime:YES];

	if(constellations) {
		[self drawConstellations]; }
	[self drawStars];
	[self drawEcliptic];
	[self drawPlanets];
	
	[self adjustViewToLocationAndTime:NO];
	
	[self drawHorizon];
	[self drawCompass];
	

	glDisable(GL_ALPHA_TEST);
	glDisable(GL_BLEND);

	if([[[interface timeModule] manager] totalInterval] > 10000 || [[[interface timeModule] manager] totalInterval] < -10000) {
		[self recalculatePlanetaryPositions];
		[[[interface timeModule] manager] setTotalInterval:0];
	}
	
	[interface renderInterface];
	
	glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
	
	[camera reenable];

}

-(void)adjustViewToLocationAndTime:(BOOL)status {
	if (status == YES) {
		glRotatef([location latitude] - 90, 0.0f, 1.0f, 0.0f);
		glRotatef(-[location longitude], 0.0f, 0.0f, 1.0f);
		glRotatef(-[[[interface timeModule] manager] elapsed], 0.0f, 0.0f, 1.0f);
	}
	else {
		glRotatef([[[interface timeModule] manager] elapsed], 0.0f, 0.0f, 1.0f);
		glRotatef([location longitude], 0.0f, 0.0f, 1.0f);
		glRotatef(90 - [location latitude], 0.0f, 1.0f, 0.0f);
	}
}

-(void)drawStars {
	glVertexPointer(3, GL_FLOAT, 32, starPoints);
    glColorPointer(4, GL_FLOAT, 32, &starPoints[3]);
	
	int i = 0;
	GLfloat size = 0;
	while(i <= starNum) {
		if(starPoints[(i*8)+7] != 0) {
			if((starPoints[(i*8)+7] * zoomFactor * brightnessFactor) > 1.0) {
				size = starPoints[(i*8)+7] * zoomFactor * brightnessFactor;
				glPointSize(size);
			glDrawArrays(GL_POINTS, i, 1);
			}
		}
		++i;
	}
}

-(void)drawConstellations {
	glDisableClientState(GL_COLOR_ARRAY);
	
	glLineWidth(1.5f);
	glColor4f(0.4f, 0.4f, 0.4f, 0.1f);
	glVertexPointer(3, GL_FLOAT, 12, constellationPoints);
    glDrawArrays(GL_LINES, 0, constellationNum);
		
	glEnableClientState(GL_COLOR_ARRAY);
}

-(void)drawPlanets {
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvi(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);	
	glEnable(GL_TEXTURE_2D);
	
	glVertexPointer(3, GL_FLOAT, 32, planetPoints);
	glColorPointer(4, GL_FLOAT, 32, &planetPoints[3]);

	//glPointSizePointerOES(GL_FLOAT, 0, &planetPoints[7]);
		
	int i = 0;
	GLfloat size = 0;
	while(i < planetNum) {
			//NSLog(@"wel");
			size = planetPoints[(i*8)+7] * zoomFactor;
			glPointSize(size);
			glBindTexture(GL_TEXTURE_2D, textures[i + 5]);
			glDrawArrays(GL_POINTS,i, 1);
		++i;
	}	
	
	
	i = 0;
	while(i < planetNum) {
		[[textTest objectAtIndex:i] drawAtPoint:CGPointMake(planetPoints[i*8], planetPoints[(i*8)+1]) withZ:planetPoints[(i*8)+2] - 0.5f];
		++i;
	}
		
	glDisable(GL_POINT_SPRITE_OES);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
	
	glEnable(GL_DEPTH_TEST);
}

-(void)drawCompass {	
	//SPRITES! ??
	const GLfloat points[] = {
		1.0, 0.0, -0.00,		1.0, 1.0f, 1.0f, 0.8f,
		0.0, -1.0, -0.00,		1.0, 1.0f, 1.0f, 0.8f,
		-1.0, 0.0, -0.00,		1.0, 1.0f, 1.0f, 0.8f,
		0.0, 1.0, -0.00,		1.0, 1.0f, 1.0f, 0.8f
	};
	
	const GLfloat sizes[] = {
		20, 20, 20, 20
	};
	glDisable(GL_DEPTH_TEST);
	
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
	
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvi(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);	
	
	glEnable(GL_TEXTURE_2D);
	
	glVertexPointer(3, GL_FLOAT, 28, points);
	glColorPointer(4, GL_FLOAT, 28, &points[3]);
	glPointSizePointerOES(GL_FLOAT, 0, sizes);
	
	glBindTexture(GL_TEXTURE_2D, textures[1]);
    glDrawArrays(GL_POINTS, 0, 1);
	glBindTexture(GL_TEXTURE_2D, textures[2]);
	glDrawArrays(GL_POINTS, 1, 1);
	glBindTexture(GL_TEXTURE_2D, textures[3]);
    glDrawArrays(GL_POINTS, 2, 1);
	glBindTexture(GL_TEXTURE_2D, textures[4]);
    glDrawArrays(GL_POINTS, 3, 1);

	glDisable(GL_TEXTURE_2D);
	glDisable(GL_POINT_SPRITE_OES);
	glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
	
	glEnable(GL_DEPTH_TEST);
}

-(void)drawHorizon {
	glLineWidth(2.0);
	
	//horizion ecliptica
	const GLfloat verticesHorizon[] = {
		-1.0, 0.0, 0.0,		0.0f, 0.2f, 0.3f, 0.8f,
		0.0, -1.0, 0.0,		0.0f, 0.2f, 0.3f, 0.8f,
		1.0, 0.0, 0.0,		0.0f, 0.2f, 0.3f, 0.8f,
		0.0, 1.0, 0.0,		0.0f, 0.2f, 0.3f, 0.8f,
	};
	
	const GLfloat verticesHorizonGlow[] = {
		-1.0, 0.0, 0.0,		1.0f, 1.0f, 1.0f, 0.8f,		0.0, 0.0,		//bottom-left
		-1.0, 0.0, 0.5,		1.0f, 1.0f, 1.0f, 0.8f,		0.0, 1.0,		//top-left
		0.0, 1.0, 0.0,		1.0f, 1.0f, 1.0f, 0.8f,		1.0, 0.0,		//bottom-right
		0.0, 1.0, 0.5,		1.0f, 1.0f, 1.0f, 0.8f,		1.0, 1.0,		//top-right
		1.0, 0.0, 0.0,		1.0f, 1.0f, 1.0f, 0.8f,		1.0, 0.0,		//bottom-left
		1.0, 0.0, 0.5,		1.0f, 1.0f, 1.0f, 0.8f,		1.0, 1.0,		//top-left
		0.0, -1.0, 0.0,		1.0f, 1.0f, 1.0f, 0.8f,		1.0, 0.0,		//top-left
		0.0, -1.0, 0.5,		1.0f, 1.0f, 1.0f, 0.8f,		1.0, 1.0,		//top-left
		-1.0, 0.0, 0.0,		1.0f, 1.0f, 1.0f, 0.8f,		1.0, 0.0,		//bottom-left
		-1.0, 0.0, 0.5,		1.0f, 1.0f, 1.0f, 0.8f,		1.0, 1.0,		//top-lef
	};
	
	//alpha horizon test
	const GLfloat verticesAlphaHorizon[] = {
		0.0, 0.0, -5.0,			0.0f, 0.0f, 0.0f, 0.5f,
		-5.0, 0.0, 0.0,			0.0f, 0.0f, 0.0f, 0.5f,
		0.0, -5.0, 0.0,			0.0f, 0.0f, 0.0f, 0.5f,
		0.0, 0.0, -5.0,			0.0f, 0.0f, 0.0f, 0.5f,
		0.0, -5.0, 0.0,			0.0f, 0.0f, 0.0f, 0.5f,
		5.0, 0.0, 0.0,			0.0f, 0.0f, 0.0f, 0.5f,
		0.0, 0.0, -5.0,			0.0f, 0.0f, 0.0f, 0.5f,
		5.0, 0.0, 0.0,			0.0f, 0.0f, 0.0f, 0.5f,
		0.0, 5.0, 0.0,			0.0f, 0.0f, 0.0f, 0.5f,
		0.0, 0.0, -5.0,			0.0f, 0.0f, 0.0f, 0.5f,
		0.0, 5.0, 0.0,			0.0f, 0.0f, 0.0f, 0.5f,
		-5.0, 0.0, 0.0,			0.0f, 0.0f, 0.0f, 0.5f
	};
	
	glVertexPointer(3, GL_FLOAT, 28, verticesAlphaHorizon);
    glColorPointer(4, GL_FLOAT, 28, &verticesAlphaHorizon[3]);
    glDrawArrays(GL_TRIANGLES, 0, 12);
	
	glVertexPointer(3, GL_FLOAT, 28, verticesHorizon);
    glColorPointer(4, GL_FLOAT, 28, &verticesHorizon[3]);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glColor4f(0.0, 1.0, 1.0, 0.1);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glTexCoordPointer(2, GL_FLOAT, 36, &verticesHorizonGlow[7]);
	glBindTexture(GL_TEXTURE_2D, textures[0]);
	
	glVertexPointer(3, GL_FLOAT, 36, verticesHorizonGlow);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 10);
	
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
}

-(void)drawEcliptic {
	glLineWidth(1.5);
	
	const GLfloat verticesEcliptic[] = {
		-25.0, 0.0, 0.0,													
		0.0, -25.0 * cos(23.44/180 * M_PI), -25.0 * sin(23.44/180 * M_PI),	
		25.0, 0.0, 0.0,														
		0.0, 25.0 * cos(23.44/180 * M_PI), 25.0 * sin(23.44/180 * M_PI),
	};
	glDisableClientState(GL_COLOR_ARRAY);
	glColor4f(1.0f, 1.0f, 0.0f, 0.075f);
	glVertexPointer(3, GL_FLOAT, 12, verticesEcliptic);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
	glEnableClientState(GL_COLOR_ARRAY);
}

-(SRCamera*)camera {
	return camera;
}

-(void)recalculatePlanetaryPositions {
	[sun recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[earth recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[jupiter recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[jupiter setViewOrigin:earth.position];
	[mercury recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[mercury setViewOrigin:earth.position];
	[venus recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[venus setViewOrigin:earth.position];
	[mars recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[mars setViewOrigin:earth.position];
	[saturn recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[saturn setViewOrigin:earth.position];
	[neptune recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[neptune setViewOrigin:earth.position];	
	[uranus recalculatePosition:[[[interface timeModule] manager] simulatedDate]];
	[uranus setViewOrigin:earth.position];
	
	const GLfloat planetPointsTmp[] = {
		[sun position].x, [sun position].y, [sun position].z,				1.0, 1.0, 0.0, 1.0, 70.0, // Sun point, yellow
		[jupiter position].x, [jupiter position].y, [jupiter position].z,	1.0, 1.0, 1.0, 1.0, 30.0,  // Sun point, red
		[mars position].x, [mars position].y, [mars position].z,			1.0, 1.0, 1.0, 1.0, 25.0,// Sun point, red
		[mercury position].x, [mercury position].y, [mercury position].z,	1.0, 1.0, 1.0, 1.0, 20.0,// Sun point, red
		[venus position].x, [venus position].y, [venus position].z,			1.0, 1.0, 1.0, 1.0, 30.0,// Sun point, red
		[saturn position].x, [saturn position].y, [saturn position].z,		1.0, 1.0, 1.0, 1.0, 17.0,// Sun point, red
		[uranus position].x, [uranus position].y, [uranus position].z,		1.0, 1.0, 1.0, 1.0, 10.0,// Sun point, red
		[neptune position].x, [neptune position].y, [neptune position].z,	1.0, 1.0, 1.0, 1.0, 10.0 // Sun point, red
	};
	
	planetNum = 8;
	
	for (int i=0; i < planetNum*8; i++) {
		planetPoints[i] = planetPointsTmp[i];
		//NSLog(@"%i", i);
	}
	
}

-(void)brightnessChanged {
	NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
	brightnessFactor = [prefs floatForKey:@"brightness"];	
}

-(void)constellationsChanged {
	NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
	constellations = [prefs floatForKey:@"constellations"];	
}

@end

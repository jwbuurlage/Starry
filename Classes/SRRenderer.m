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

@synthesize interface,location,myOwner,camera,highlight,planetView,
highlightPosition,highlightSize,selectedStar,selectedPlanet,planetHighlighted,objectInFocus;

-(id)setupWithOwner:(GLViewController*)theOwner {
	if(self = [super init]) {
		//setup renderer.. 		
		myOwner = theOwner;
		appDelegate = [[UIApplication sharedApplication] delegate];
		camera = [theOwner camera];
		location = [appDelegate location];
		objectManager = [appDelegate objectManager];
		
		//[objectManager setRenderer:self];
		interface = [[SRInterface alloc] initWithRenderer:self];
		
		glGenTextures(20, &textures[0]);
		[interface loadTexture:@"horizon_bg.png" intoLocation:textures[0]];
		[interface loadTextureWithString:NSLocalizedString(@"comS", @"") intoLocation:textures[1]];
		[interface loadTextureWithString:NSLocalizedString(@"comW", @"") intoLocation:textures[2]];		
		[interface loadTextureWithString:NSLocalizedString(@"comN", @"") intoLocation:textures[3]];
		[interface loadTextureWithString:NSLocalizedString(@"comE", @"") intoLocation:textures[4]];
		
		//Dit moet anders, via loadPlanetData misschien
		// Waarom laad je planet 6 keer in? :-S dat kan makkelijk 1 keer zijn
		[interface loadTexture:@"sun.png" intoLocation:textures[5]];
		[interface loadTexture:@"moon.png" intoLocation:textures[6]];
		[interface loadTexture:@"planet.png" intoLocation:textures[7]];
		[interface loadTexture:@"sun_planet.png" intoLocation:textures[8]];
		[interface loadTexture:@"highlight_small.png" intoLocation:textures[9]];
		[interface loadTexture:@"messier.png" intoLocation:textures[10]];
		
		//FIXME: phases moeten mooier
		[interface loadTexture:@"phase_0.png" intoLocation:textures[11]];
		[interface loadTexture:@"phase_1.png" intoLocation:textures[12]];
		[interface loadTexture:@"phase_2.png" intoLocation:textures[13]];
		[interface loadTexture:@"phase_3.png" intoLocation:textures[14]];
		[interface loadTexture:@"phase_4.png" intoLocation:textures[15]];
		[interface loadTexture:@"phase_5.png" intoLocation:textures[16]];
		[interface loadTexture:@"phase_6.png" intoLocation:textures[17]];
		[interface loadTexture:@"phase_7.png" intoLocation:textures[18]];

		//FIXME: verplaats naar app delegate		
		glClearColor(0.0, 0.08, 0.14, 1.0);

		
		glEnable(GL_POINT_SMOOTH);
		//glEnable (GL_LINE_SMOOTH);
		glEnable(GL_ALPHA_TEST);
		glAlphaFunc(GL_GREATER, 0.0f);
		glMatrixMode(GL_MODELVIEW);
		glEnable(GL_VERTEX_ARRAY);
		
		glLoadIdentity(); 
		

		[self performSelector:@selector(loadData:) withObject:self afterDelay:0.0];
	}
	return self;
}

-(void)loadData:(id)aSender {
	[self loadPlanetPoints];
	[objectManager parseData];
	[self loadStarPoints];
	[self loadMessier];
	[self loadOrbits];
}

-(void)loadOrbits {
	//laten we mercurius proberen
	float a, b, e;
	e = [[[objectManager planets] objectAtIndex:2] e];
	a = [[[objectManager planets] objectAtIndex:2] a];
	b = sqrt(pow(a,2) - pow(a,2)*pow(e,2));
	
	NSLog(@"%f, %f", a, b);
	
	[interface loadOrbitTextureWitha:a b:b intoLocation:textures[19]];

}

-(void)loadPlanetPoints {
	[objectManager buildPlanetData];
	NSMutableArray * planetPointsTmp = [objectManager planetPoints];
	planetNum = [objectManager planetNum];
	for (int i=0; i < planetNum*8; i++) {
		planetPoints[i] = [[planetPointsTmp objectAtIndex:i] floatValue];
		//NSLog(@"%i set to :%f", i,[[planetPointsTmp objectAtIndex:i] floatValue]);
	}	
}

-(void)loadMessier {
	[objectManager buildMessierData];
	NSMutableArray * messierPointsTmp = [objectManager messierPoints];
	messierNum = [objectManager messierNum];
	for (int i=0; i < messierNum*3; i++) {
		messierPoints[i] = [[messierPointsTmp objectAtIndex:i] floatValue];
		//NSLog(@"%i set to :%f", i,[[planetPointsTmp objectAtIndex:i] floatValue]);
	}	
}

-(void)loadStarPoints {
	[objectManager buildStarData];
	
	starNum = 0;
	int matrixStartPos;
	int starSizeNumTmp[6] = { 0, 0, 0, 0, 0, 0 };
	//float size;
	//float alpha;
	SRStar * star;
	
	//NSLog(@"Starcount: %i", [[objectManager stars] count]);
	
	for(star in [objectManager stars]) {
		if(![star.name isEqualToString:@"Sol"]) {
			matrixStartPos = starNum * 8;
			starPoints[matrixStartPos] = [star position].x;
			starPoints[matrixStartPos+1] = [star position].y;
			starPoints[matrixStartPos+2] = [star position].z;
			starPoints[matrixStartPos+3] = [star color].red;
			starPoints[matrixStartPos+4] = [star color].green;
			starPoints[matrixStartPos+5] = [star color].blue;
			starPoints[matrixStartPos+6] = [star alpha];
			//starPointsTmp[matrixStartPos+7] = [star size];
			starPoints[matrixStartPos+7] = 0;
			
			if([star mag] < 2) {
				++starSizeNumTmp[0];
			}
			else if ([star mag] < 3) {
				starSizeNumTmp[1] += 1;
			}
			else if ([star mag] < 4) {
				starSizeNumTmp[2] += 1;
			}
			else if ([star mag] < 4.5) {
				starSizeNumTmp[3] += 1;
			}
			else if ([star mag] < 5) {
				starSizeNumTmp[4] += 1;
			}
			else if ([star mag] < 7) {
				starSizeNumTmp[5] += 1;
			}
			starNum++;
		}
	}
		
	starSizeNum = [[NSMutableArray alloc] init];
	for (int i=0; i < 6; i++) {
		[starSizeNum addObject:[NSNumber numberWithInt:starSizeNumTmp[i]]];
	} 
	
	starNum = [[objectManager stars] count];
}

-(void)renderPlanetView {
	glRotatef(90.0f, 0.0, 1.0, 0.0);
	glTranslatef(0.0f, 0.0f, -20.0f);
	
	glDisableClientState(GL_COLOR_ARRAY);
	glDisable(GL_POINT_SPRITE_OES);
	
	glRotatef(90, 0, 0, 1.0f);
	
	const GLfloat pointer[] = {
		0, 0,
		0, 1,
		1, 0,
		1, 1
	};
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
	glColor4f(0.0f, 0.5f, 1.0f, 0.5f);
	glTexCoordPointer(2, GL_FLOAT, 8, pointer);
	glBindTexture(GL_TEXTURE_2D, textures[19]);
	
	
	for(int i = 0; i < [[objectManager planets] count]; ++i) {
		float a, b, e, c;
		e = [[[objectManager planets] objectAtIndex:i] e];
		a = [[[objectManager planets] objectAtIndex:i] a];
		b = sqrt(pow(a,2) - pow(a,2)*pow(e,2));
		c = sqrt(pow(a,2) - pow(b,2));
			
		const GLfloat planetOrbit[] = {
			-c - a, -b, 0,
			-c - a, b, 0,
			-c + a, -b, 0,
			-c + a, b, 0
		};
		
		glVertexPointer(3, GL_FLOAT, 12, planetOrbit);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
		
	glRotatef(-90, 0, 0, 1.0f);

	glDisableClientState(GL_TEXTURE_COORD_ARRAY);	

	glEnable(GL_TEXTURE_2D);
	glEnable(GL_POINT_SPRITE_OES);
	glEnableClientState(GL_COLOR_ARRAY);	
	
	const GLfloat planetViewPoints[] = {
		0, 0, 0,
		0, 0, 0,	
		[[[objectManager planets] objectAtIndex:1] positionHelio].x, [[[objectManager planets] objectAtIndex:1] positionHelio].y, [[[objectManager planets] objectAtIndex:1] positionHelio].z,
		[[[objectManager planets] objectAtIndex:2] positionHelio].x, 
		[[[objectManager planets] objectAtIndex:2] positionHelio].y, 
		[[[objectManager planets] objectAtIndex:2] positionHelio].z,
		[[[objectManager planets] objectAtIndex:3] positionHelio].x, 
		[[[objectManager planets] objectAtIndex:3] positionHelio].y, 
		[[[objectManager planets] objectAtIndex:3] positionHelio].z,
		[[[objectManager planets] objectAtIndex:4] positionHelio].x, 
		[[[objectManager planets] objectAtIndex:4] positionHelio].y, 
		[[[objectManager planets] objectAtIndex:4] positionHelio].z,
		[[[objectManager planets] objectAtIndex:5] positionHelio].x, 
		[[[objectManager planets] objectAtIndex:5] positionHelio].y, 
		[[[objectManager planets] objectAtIndex:5] positionHelio].z,
		[[[objectManager planets] objectAtIndex:6] positionHelio].x, 
		[[[objectManager planets] objectAtIndex:6] positionHelio].y, 
		[[[objectManager planets] objectAtIndex:6] positionHelio].z,
		[[[objectManager planets] objectAtIndex:7] positionHelio].x, 
		[[[objectManager planets] objectAtIndex:7] positionHelio].y, 
		[[[objectManager planets] objectAtIndex:7] positionHelio].z,
		[[[objectManager planets] objectAtIndex:8] positionHelio].x, 
		[[[objectManager planets] objectAtIndex:8] positionHelio].y, 
		[[[objectManager planets] objectAtIndex:8] positionHelio].z,
		[[[objectManager planets] objectAtIndex:0] positionHelio].x, 
		[[[objectManager planets] objectAtIndex:0] positionHelio].y, 
		[[[objectManager planets] objectAtIndex:0] positionHelio].z,
	};
	int i = 0;
	
	glVertexPointer(3, GL_FLOAT, 12, planetViewPoints);
    glColorPointer(4, GL_FLOAT, 32, &planetPoints[3]);
	
	GLfloat size = 0;
	while(i <= 10) {
		size = planetPoints[(i*8)+7];
		glPointSize(size);
		
		if (i == 1) { // maan
		
		}
		else {
			if (i == 0) { // Bij de zon laad de zon texture in
				glPointSize(16.0f);
				glBindTexture(GL_TEXTURE_2D, textures[8]);
			}
			else { // Bij planeten laad de planeet texture in
				if(i == 10) { 
					glPointSize(size * ([camera zoomingValue] / 3));
				}
				else {
					glPointSize(size * pow([[[objectManager planets] objectAtIndex:i - 1] a], 1/1.5) * ([camera zoomingValue] / 3));
				}

				glBindTexture(GL_TEXTURE_2D, textures[7]);
			}
			glDrawArrays(GL_POINTS,i, 1);
		}
		++i;
	}			
	glDisableClientState(GL_COLOR_ARRAY);
	
	
	i = 0;
	while(i < [[objectManager planets] count]) {
		float alpha = 2.5 * ([camera zoomingValue] - (1 / [[[objectManager planets] objectAtIndex:i] a]));

		glColor4f(1.0f, 1.0f, 1.0f, alpha);
		
		[[[objectManager planets] objectAtIndex:i] drawHelio:YES];
		++i;
	}
	
	[[objectManager sun] drawHelio:YES]; 
	
	glRotatef(30, 0, 1.0, 0);
	
}

-(void)render {
	if (lastDrawTime) { timeElapsed = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime; }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
	
	[camera doAnimations:timeElapsed];
	
	if(selectedStar && ![[interface starInfo] hiding])
		[[interface starInfo] starUpdate:selectedStar];
	
	//view resetten
    glLoadIdentity();
		
	//omzetten van opengl assenstelsel, naar een RH normaal assenstelsel
	glRotatef(-90.0, 1.0, 0.0, 0.0); //RH coordinaten systeem 
	glRotatef(-90.0, 0.0, 0.0, 1.0); //daarom is hij min -> z staat nu naar boven toe ( - --> + )
	glRotatef(-90.0, 1.0, 0.0, 0.0); //daarom is hij min -> z staat nu naar boven toe ( - --> + )
	
	//camera positie callen
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
	float bgConstant = ((M_PI / 180) * [[objectManager sun] height:[location latitude] lon:[location longitude] elapsed:[[[interface timeModule] manager] elapsed]]);
	//NSLog(@"%f",bgConstant);
	if(!planetView) {
		glClearColor(0.0, 0.08 + bgConstant * 0.12, 0.12 + bgConstant * 0.18, 1.0);
	}
	else {
		glClearColor(0.0, 0.12, 0.16, 1.0);
	}
	
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	glTexEnvi(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);	

	if(planetView) {
		//glEnable(GL_DEPTH_TEST);
		//[camera adjustView];
		[self renderPlanetView];
		glEnable(GL_TEXTURE_2D);
		glEnable(GL_POINT_SPRITE_OES);
		glDisable(GL_DEPTH_TEST);
		[interface renderInterface];
		
		[self loadPlanetPoints];
		
		[camera reenable]; 
		return;
	}
	if(highlight && [[[interface timeModule] manager] isGoingFast]) {
		[camera positionStayInFocus:objectInFocus];
	}
	
	[camera adjustView];
	[self adjustViewToLocationAndTime:YES];

	if([[appDelegate settingsManager] showConstellations]) {
		[self drawConstellations]; 
	}
	[self drawEcliptic];
	
	glEnableClientState(GL_COLOR_ARRAY);
	[self drawStars];
		
	glEnable(GL_POINT_SPRITE_OES);
	glEnable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	if(highlight) {
		[self drawHighlight];
	}
	[self drawMessier];
	[self drawPlanets];
	
	
	[self adjustViewToLocationAndTime:NO];
	
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
		
	[self drawHorizon];	
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);

	[self drawCompass];

	if([[[interface timeModule] manager] totalInterval] > 1000 || [[[interface timeModule] manager] totalInterval] < -1000) {
		[self loadPlanetPoints];
		[[[interface timeModule] manager] setTotalInterval:0];
		// FIXME: recalculate highlight for planet moved
		if(planetHighlighted) {
			[self setHighlightPosition:selectedPlanet.position];
		}
	}
		
	
	[interface renderInterface];
	
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
	//NSMutableArray * starSizeNum = [objectManager starSizeNum];
	GLfloat size;
	
	size = 4 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	if(size > 5) { size = 5; }
	glPointSize(size);
	glDrawArrays(GL_POINTS, 0, [[starSizeNum objectAtIndex:0] intValue]);
	
	size = 3 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	if(size > 4) { size = 4; }
	glPointSize(size);
	glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue], [[starSizeNum objectAtIndex:1] intValue]);
	
	size = 2 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	if(size > 3) { size = 3; }
	glPointSize(size);
	glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue] + [[starSizeNum objectAtIndex:1] intValue], [[starSizeNum objectAtIndex:2] intValue]);

	size = 0.8 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	if(size > 3) { size = 3; }
	if(size < 1) { return; }
	glPointSize(size);
	glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue] + [[starSizeNum objectAtIndex:1] intValue] + [[starSizeNum objectAtIndex:2] intValue], [[starSizeNum objectAtIndex:3] intValue]);

	size = 0.5 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	if(size > 3) { size = 3; }
	if(size < 1) { return; }
	glPointSize(size);
	glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue] + [[starSizeNum objectAtIndex:1] intValue] + [[starSizeNum objectAtIndex:2] intValue] + [[starSizeNum objectAtIndex:3] intValue], [[starSizeNum objectAtIndex:4] intValue]);

	size = 0.4 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	if(size > 3) { size = 3; }
	if(size < 1) { return; }
	glPointSize(size);
	glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue] + [[starSizeNum objectAtIndex:1] intValue] + [[starSizeNum objectAtIndex:2] intValue] + [[starSizeNum objectAtIndex:3] intValue] + [[starSizeNum objectAtIndex:4] intValue], [[starSizeNum objectAtIndex:5] intValue]);	
}

-(void)drawConstellations {
	glLineWidth(1.0f);
	
	float constAlpha = 0.2f * pow([camera zoomingValue],-2);
	
	float readDECDeg = fmod(90+[camera altitude],180);
	float readRADeg = fmod([camera azimuth],360);
	
	if (readRADeg < 0) {
		readRADeg = readRADeg + 360;
	}
	
	float readRARad = readRADeg * (M_PI/180);
	float readDECRad = (readDECDeg * (M_PI/180));
	
	float rotationY = (90-[location latitude])*(M_PI/180);
	float rotationZ1 = [location longitude]*(M_PI/180);
	float rotationZ2 = [[[interface timeModule] manager] elapsed]*(M_PI/180);
	
	// voor goed voorbeeld: http://www.math.umn.edu/~nykamp/m2374/readings/matvecmultex/
	// wikipedia rotatie matrix: http://en.wikipedia.org/wiki/Rotation_matrix
	
	float maX,maY,maZ, brX, brY, brZ;
	
	maX = (cos(rotationZ1)*(cos(rotationY)*sin(readDECRad)*cos(readRARad)+0*sin(readDECRad)*sin(readRARad)+sin(rotationY)*cos(readDECRad))+(-sin(rotationZ1)*(0*sin(readDECRad)*cos(readRARad)+1*sin(readDECRad)*sin(readRARad)+0*cos(readDECRad)))+0*((-sin(rotationY)*sin(readDECRad)*cos(readRARad))+0*sin(readDECRad)*sin(readRARad)+cos(rotationY)*cos(readDECRad)));
	maY = (sin(rotationZ1)*(cos(rotationY)*sin(readDECRad)*cos(readRARad)+0*sin(readDECRad)*sin(readRARad)+sin(rotationY)*cos(readDECRad))+cos(rotationZ1)*(0*sin(readDECRad)*cos(readRARad)+1*sin(readDECRad)*sin(readRARad)+0*cos(readDECRad))+0*((-sin(rotationY)*sin(readDECRad)*cos(readRARad))+0*sin(readDECRad)*sin(readRARad)+cos(rotationY)*cos(readDECRad)));
	maZ = (0*(cos(rotationY)*sin(readDECRad)*cos(readRARad)+0*sin(readDECRad)*sin(readRARad)+sin(rotationY)*cos(readDECRad))+0*(0*sin(readDECRad)*cos(readRARad)+1*sin(readDECRad)*sin(readRARad)+0*cos(readDECRad))+1*((-sin(rotationY)*sin(readDECRad)*cos(readRARad))+0*sin(readDECRad)*sin(readRARad)+cos(rotationY)*cos(readDECRad)));

	brX = maX;
	brY = maY;
	brZ = maZ;
	
	// Matrix vermenigvuldiging met draai om de  z-as (tijd)
	maX = (cos(rotationZ2)*brX+(-sin(rotationZ2)*brY));
	maY = (sin(rotationZ2)*brX+cos(rotationZ2)*brY);
	maZ = brZ;
		
	float stX,stY,stZ;
	stX = -20*maX;
	stY = -20*maY;
	stZ = -20*maZ;
	
	float apparentAzimuth = ((180/M_PI) * atan2(stY, stX)) + 180;
	float apparentAltitude = 90 - ((180/M_PI) * (acos((stZ)/sqrt(pow(stX,2)+pow(stY,2)+pow(stZ,2))))); 


	if(apparentAzimuth < 180) {
		apparentAzimuth += 360;
	}

		
	for(SRConstellation* aConstellation in [objectManager constellations]) {
		float dAzi = fabs(apparentAzimuth - [aConstellation ra]);
		if(dAzi > 300) { dAzi = 360 - dAzi; }
		
		float distance = (dAzi + fabs(apparentAltitude - [aConstellation dec])) / 2;

		if(distance < 30) { 
			if(distance <= 11.0) { 
				glColor4f(0.6f, 0.6f, 0.6f, constAlpha);
				[aConstellation draw];
				
				glColor4f(1.0f, 1.0f, 1.0f, constAlpha * 2);
				[aConstellation drawText];
			}
			else { 
				float factor = (distance - 10) / 4;
				if(factor < 1) { factor = 1; }
				glColor4f(0.4f, 0.6f, 0.6f, constAlpha / factor); 
				
				[aConstellation draw];
				
				glColor4f(0.6f, 0.6f, 0.6f, (constAlpha / factor) * 4);
				[aConstellation drawText];
			} 
		}
	}
}

-(void)drawEcliptic {
	glLineWidth(1.0);
	
	const GLfloat verticesEcliptic[] = {
		-25.0, 0.0, 0.0,													
		0.0, -25.0 * cos(23.44/180 * M_PI), -25.0 * sin(23.44/180 * M_PI),	
		25.0, 0.0, 0.0,														
		0.0, 25.0 * cos(23.44/180 * M_PI), 25.0 * sin(23.44/180 * M_PI),
	};
	
	glColor4f(0.4f, 0.40f, 0.40f, 0.4f);
	glVertexPointer(3, GL_FLOAT, 12, verticesEcliptic);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
}

-(void)drawHighlight {	
	if(highlight) {		
		const GLfloat points[] = {
			highlightPosition.x, highlightPosition.y, highlightPosition.z
		};
		
		glPointSize(32.0f);
		glBindTexture(GL_TEXTURE_2D, textures[9]);
		
		glColor4f(0.5f,0.5f,0.5f,0.75f);
		glVertexPointer(3, GL_FLOAT, 12, points);
		
		glDrawArrays(GL_POINTS, 0, 1);
	}
}

-(void)drawMessier {
	glPointSize(8.0);
	glColor4f(0.2f, 0.2f, 0.2f, 0.6f);
	glVertexPointer(3, GL_FLOAT, 12, messierPoints);
	glBindTexture(GL_TEXTURE_2D, textures[10]);
    glDrawArrays(GL_POINTS, 0, messierNum);
}


-(void)drawPlanets {
	glVertexPointer(3, GL_FLOAT, 32, planetPoints);
	glEnableClientState(GL_COLOR_ARRAY);
    glColorPointer(4, GL_FLOAT, 32, &planetPoints[3]);
	int i = 0;
	GLfloat size = 0;
	while(i <= 10) {
		size = planetPoints[(i*8)+7];
		glPointSize(size);
		
		if (i == 1) { // maan
			
			size = [camera zoomingValue] * size;
			if(size < 48) {
				glPointSize(size);
			}
			else {
				glPointSize(48.0f);	
			}

			glBindTexture(GL_TEXTURE_2D, textures[6]);
			glDrawArrays(GL_POINTS,i, 1);
						
			switch([[objectManager moon] phase]) {
				case 0:
					glBindTexture(GL_TEXTURE_2D, textures[11]);
					break;
				case 1: 
					glBindTexture(GL_TEXTURE_2D, textures[12]);
					break;
				case 2: 
					glBindTexture(GL_TEXTURE_2D, textures[13]);
					break;
				case 3: 
					glBindTexture(GL_TEXTURE_2D, textures[14]);
					break;
				case 4: 
					glBindTexture(GL_TEXTURE_2D, textures[15]);
					break;
				case 5: 
					glBindTexture(GL_TEXTURE_2D, textures[16]);
					break;
				case 6: 
					glBindTexture(GL_TEXTURE_2D, textures[17]);
					break;
				case 7: 
					glBindTexture(GL_TEXTURE_2D, textures[18]);
					break;
			}

			glDrawArrays(GL_POINTS,i, 1);
		}
		else {
			if (i == 0) { // Bij de zon laad de zon texture in
				glBindTexture(GL_TEXTURE_2D, textures[5]);
			}
			else { // Bij planeten laad de planeet texture in
				glBindTexture(GL_TEXTURE_2D, textures[7]);
			}
			glDrawArrays(GL_POINTS,i, 1);
		}
		++i;
	}			
	glDisableClientState(GL_COLOR_ARRAY);
	

	if([[appDelegate settingsManager] showPlanetLabels]) {
	i = 1;
	while(i < [[objectManager planets] count]) {
		glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		[[[objectManager planets] objectAtIndex:i] drawHelio:NO];
		++i;
	}
	
	[[objectManager sun] drawHelio:NO];
		[[objectManager moon] draw]; }
}



-(void)drawCompass {	
	//SPRITES! ??
	const GLfloat points[] = {
		1.0, 0.0, -0.0,		
		0.0, -1.0, -0.0,
		-1.0, 0.0, -0.0,
		0.0, 1.0, -0.0
	};
			
	glPointSize(20.0f);
	
	glVertexPointer(3, GL_FLOAT, 12, points);
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);	
	glBindTexture(GL_TEXTURE_2D, textures[1]);
    glDrawArrays(GL_POINTS, 0, 1);
	glBindTexture(GL_TEXTURE_2D, textures[2]);
	glDrawArrays(GL_POINTS, 1, 1);
	glBindTexture(GL_TEXTURE_2D, textures[3]);
    glDrawArrays(GL_POINTS, 2, 1);
	glBindTexture(GL_TEXTURE_2D, textures[4]);
    glDrawArrays(GL_POINTS, 3, 1);

	glDisable(GL_POINT_SPRITE_OES);
	
}

-(void)drawHorizon {
	glLineWidth(2.0);
	
	//horizion ecliptica
	const GLfloat verticesHorizon[] = {
		-2.0, 0.0, 0.0,	
		0.0, -2.0, 0.0,
		2.0, 0.0, 0.0,
		0.0, 2.0, 0.0
	};
	
	const GLfloat verticesHorizonGlow[] = {
		-1.0, 0.0, 0.0,		0.0, 0.0,		//bottom-left
		-1.0, 0.0, 0.75,	0.0, 1.0,		//top-left
		0.0, 1.0, 0.0,		1.0, 0.0,		//bottom-right
		0.0, 1.0, 0.75,		1.0, 1.0,		//top-right
		1.0, 0.0, 0.0,		1.0, 0.0,		//bottom-left
		1.0, 0.0, 0.75,		1.0, 1.0,		//top-left
		0.0, -1.0, 0.0,		1.0, 0.0,		//top-left
		0.0, -1.0, 0.75,	1.0, 1.0,		//top-left
		-1.0, 0.0, 0.0,		1.0, 0.0,		//bottom-left
		-1.0, 0.0, 0.75,	1.0, 1.0		//top-left
	};
	
	//alpha horizon test
	const GLfloat verticesAlphaHorizon[] = {
		0.0, 0.0, -5.0,
		-5.0, 0.0, 0.0,
		0.0, -5.0, 0.0,
		0.0, 0.0, -5.0,
		0.0, -5.0, 0.0,
		5.0, 0.0, 0.0,
		0.0, 0.0, -5.0,
		5.0, 0.0, 0.0,
		0.0, 5.0, 0.0,
		0.0, 0.0, -5.0,
		0.0, 5.0, 0.0,
		-5.0, 0.0, 0.0
	};	
	
	glVertexPointer(3, GL_FLOAT, 12, verticesAlphaHorizon);
	glColor4f(0.0, 0.0, 0.0, 0.5);
	glDrawArrays(GL_TRIANGLES, 0, 12);
	
	glVertexPointer(3, GL_FLOAT, 12, verticesHorizon);
	glColor4f(1.0f, 1.0f, 1.0f, 0.1f);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
}



@end

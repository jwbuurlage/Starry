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

@synthesize interface,location,myOwner,camera,highlight,highlightPosition,highlightSize;

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
		[interface loadTextureWithString:@"Z" intoLocation:textures[1]];
		[interface loadTextureWithString:@"W" intoLocation:textures[2]];		
		[interface loadTextureWithString:@"N" intoLocation:textures[3]];
		[interface loadTextureWithString:@"O" intoLocation:textures[4]];
		
		//Dit moet anders, via loadPlanetData misschien
		// Waarom laad je planet 6 keer in? :-S dat kan makkelijk 1 keer zijn
		[interface loadTexture:@"sun.png" intoLocation:textures[5]];
		[interface loadTexture:@"moon.png" intoLocation:textures[6]];
		[interface loadTexture:@"planet.png" intoLocation:textures[7]];
		[interface loadTexture:@"highlight.png" intoLocation:textures[8]];
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
		glClearColor(0.0, 0.05, 0.08, 1.0);

		[self loadPlanetPoints];
		
		glEnable(GL_POINT_SMOOTH);
		glEnable (GL_LINE_SMOOTH);
		glEnable(GL_ALPHA_TEST);
		glAlphaFunc(GL_GREATER, 0.0f);
		glMatrixMode(GL_MODELVIEW);
		glEnable(GL_VERTEX_ARRAY);
		
		glLoadIdentity(); 
		[self loadStarPoints];
		[self loadConstellations];
		[self loadMessier];
		
	}
	return self;
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
	NSMutableArray * starPointsTmp = [objectManager starPoints];
	starNum = [objectManager starNum];
	for (int i=0; i < starNum*8; i++) {
		starPoints[i] = [[starPointsTmp objectAtIndex:i] floatValue];
		//NSLog(@"%i set to :%f", i,[[planetPointsTmp objectAtIndex:i] floatValue]);
	}	
}

-(void)loadConstellations {
	[objectManager buildConstellationData];
	NSMutableArray * constellationPointsTmp = [objectManager constellationPoints];
	constellationNum = [objectManager constellationNum];
	for (int i=0; i < constellationNum; i++) {
		constellationPoints[i] = [[constellationPointsTmp objectAtIndex:i] floatValue];
		//NSLog(@"%i set to :%f", i,[[planetPointsTmp objectAtIndex:i] floatValue]);
	}
}

-(void)render {
	
	//view resetten
    glLoadIdentity();
		
	//omzetten van opengl assenstelsel, naar een RH normaal assenstelsel
	glRotatef(-90.0, 1.0, 0.0, 0.0); //RH coordinaten systeem 
	glRotatef(-90.0, 0.0, 0.0, 1.0); //daarom is hij min -> z staat nu naar boven toe ( - --> + )
	glRotatef(-90.0, 1.0, 0.0, 0.0); //daarom is hij min -> z staat nu naar boven toe ( - --> + )
	
	//camera positie callen
	[camera adjustView];
	
	if(![interface showingMessier]) {
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	
	[self adjustViewToLocationAndTime:YES];

	if([[appDelegate settingsManager] showConstellations]) {
		[self drawConstellations]; 
	}
	[self drawEcliptic];
	
	glEnableClientState(GL_COLOR_ARRAY);
	[self drawStars];
	glDisableClientState(GL_COLOR_ARRAY);
		
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvi(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);	
	glEnable(GL_TEXTURE_2D);
	if(highlight) {
		[self drawHighlight];
	}
	[self drawPlanets];
	[self drawMessier];

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
		//highlight = FALSE;
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
	
	int i = 0;
	GLfloat size = 0;
	while(i <= starNum) {
		if(starPoints[(i*8)+7] != 0) {
			if((starPoints[(i*8)+7] * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor]) > 1.0) {
				size = starPoints[(i*8)+7] * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
				glPointSize(size);
			glDrawArrays(GL_POINTS, i, 1);
			}
		}
		++i;
	}
}

-(void)drawConstellations {
	glLineWidth(1.0f);
	glColor4f(0.4f, 0.40f, 0.40f, 0.3f);
	glVertexPointer(3, GL_FLOAT, 12, constellationPoints);
    glDrawArrays(GL_LINES, 0, constellationNum);
}

-(void)drawEcliptic {
	glLineWidth(2.0);
	
	const GLfloat verticesEcliptic[] = {
		-25.0, 0.0, 0.0,													
		0.0, -25.0 * cos(23.44/180 * M_PI), -25.0 * sin(23.44/180 * M_PI),	
		25.0, 0.0, 0.0,														
		0.0, 25.0 * cos(23.44/180 * M_PI), 25.0 * sin(23.44/180 * M_PI),
	};
	
	glColor4f(0.4f, 0.40f, 0.40f, 0.1f);
	glVertexPointer(3, GL_FLOAT, 12, verticesEcliptic);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
}

-(void)drawHighlight {	
	if(highlight) {
		
		
		const GLfloat points[] = {
			highlightPosition.x, highlightPosition.y, highlightPosition.z
		};
		
		glPointSize(highlightSize * [camera zoomingValue]);
		if((highlightSize * [camera zoomingValue]) < 50) {
			glBindTexture(GL_TEXTURE_2D, textures[9]);
		}
		else {
			glBindTexture(GL_TEXTURE_2D, textures[8]);
		}
		
		glColor4f(0.5f,0.5f,0.5f,0.75f);
		glVertexPointer(3, GL_FLOAT, 12, points);
		
		glDrawArrays(GL_POINTS, 0, 1);
	}
}

-(void)drawMessier {
	glPointSize(8.0 * [camera zoomingValue]);
	glColor4f(0.5f, 0.5f, 0.5f, 0.15f);
	glVertexPointer(3, GL_FLOAT, 12, messierPoints);
	glBindTexture(GL_TEXTURE_2D, textures[10]);
    glDrawArrays(GL_POINTS, 0, messierNum);
}


-(void)drawPlanets {
	glVertexPointer(3, GL_FLOAT, 32, planetPoints);
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	int i = 0;
	GLfloat size = 0;
	while(i < planetNum) {
		size = planetPoints[(i*8)+7] * [camera zoomingValue];
		glPointSize(size);
		
		if (i == 1) { // maan
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
	glColor4f(0.0, 0.0, 0.0, 0.8);
	
	glDrawArrays(GL_TRIANGLES, 0, 12);
	
	glVertexPointer(3, GL_FLOAT, 12, verticesHorizon);
	glColor4f(1.0f, 1.0f, 1.0f, 0.1f);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

	glColor4f(0.0, 1.0, 1.0, 0.05);
	glTexCoordPointer(2, GL_FLOAT, 20, &verticesHorizonGlow[3]);
	glBindTexture(GL_TEXTURE_2D, textures[0]);
	glVertexPointer(3, GL_FLOAT, 20, verticesHorizonGlow);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 10);
	
}



@end

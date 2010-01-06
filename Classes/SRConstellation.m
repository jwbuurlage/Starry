//
//  SRConstellation.m
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


#import "SRConstellation.h"
#import "SterrenAppDelegate.h"


@implementation SRConstellation

@synthesize lines, name, ra, dec, nameTexture;

-(void)calculateRADec {
	float RATemp, totRA, totDec;
	BOOL stayHigh;
	int i = 0;
	
	for(SRConstellationLine* aLine in lines) {
		RATemp = atan2(aLine.start.y, aLine.start.x);
		
		if(i == 0) { if(RATemp > 0) { stayHigh = TRUE; } else { stayHigh = FALSE; } ++i; }
		
		
		if(stayHigh && RATemp < M_PI) {
			RATemp += 2*M_PI;
		}
		else if (!stayHigh && RATemp > 0) {
			RATemp -= 2*M_PI;
		}
		totRA += RATemp;
		
		RATemp = atan2(aLine.end.y, aLine.end.x);
		if(stayHigh && RATemp < M_PI) {
			RATemp += 2*M_PI;
		}
		else if (!stayHigh && RATemp > 0) {
			RATemp -= 2*M_PI;
		}
		totRA += RATemp;
				
		totDec += acos((aLine.start.z)/sqrt(pow(aLine.start.x,2)+pow(aLine.start.y,2)+pow(aLine.start.z,2))) + acos((aLine.end.z)/sqrt(pow(aLine.end.x,2)+pow(aLine.end.y,2)+pow(aLine.end.z,2)));
	}
	
	ra = ((180/M_PI) * ((totRA/([lines count] * 2))));
	if(ra > 360) { ra -= 360; }
	if(ra < 0) { ra += 360; }	
	dec = 90 - ((180/M_PI) * (totDec/([lines count] * 2)));
	
	//NSLog(@"%@: .. RA: %f Dec: %f", name, ra, dec); 
	
	ra += 180;
	
	texturePosition = Vertex3DMake(20.0 * sin(totDec/([lines count] * 2)) * cos(totRA/([lines count] * 2)),
								   20.0 * sin(totDec/([lines count] * 2)) * sin(totRA/([lines count] * 2)),
								   20.0 * cos(totDec/([lines count] * 2)));
	
	float size;
	
	if ([[name stringByReplacingOccurrencesOfString:@"-" withString:@" "] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0]].width > 64 ) {
		size = 64;
	}
	else {
		size = 64;
	}
	//nameTexture = [[Texture2D alloc] initWithString:[name stringByReplacingOccurrencesOfString:@"-" withString:@" "] dimensions:CGSizeMake(size, size) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:1.0];
	[nameTexture release];
	nameTexture = [[Texture2D alloc] initWithString:NSLocalizedString(name,@"") dimensions:CGSizeMake(size, size) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:1.0];

}

-(void)draw {
	glVertexPointer(3, GL_FLOAT, 12, constellationPoints);
	glDrawArrays(GL_LINES, 0, [lines count] * 2);
}

-(void)drawText {
	glEnable(GL_POINT_SPRITE_OES);
	glEnable(GL_TEXTURE_2D);
	
	[nameTexture drawAtVertex:texturePosition];

	glDisable(GL_TEXTURE_2D);
	glDisable(GL_POINT_SPRITE_OES);
}

-(void)makeArray {
	int lineCount = 0;
	
	for(SRConstellationLine* line in lines) {
		constellationPoints[lineCount] = line.start.x;
		constellationPoints[lineCount+1] = line.start.y;
		constellationPoints[lineCount+2] = line.start.z;
		constellationPoints[lineCount+3] = line.end.x;
		constellationPoints[lineCount+4] = line.end.y;
		constellationPoints[lineCount+5] = line.end.z;
		lineCount += 6;
	}
	
	
}

-(Vertex3D)myCurrentPosition {
	
	float readRARad = fmod(ra,360) * (M_PI/180);
	float readDECRad = (90 + dec) * (M_PI/180);
	//NSLog(@"Sterrenbeeld positie, to transform = ra:%f dec:%f",fmod(ra,360),dec);
	
	float brX = sin(readDECRad)*cos(readRARad);
	float brY = sin(readDECRad)*sin(readRARad);
	float brZ = cos(readDECRad);
	
	//NSLog(@"vooraf x:%f y:%f z:%f",brX,brY,brZ);
	
	SterrenAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	float latitude = [[appDelegate location] latitude];
	float longitude = [[appDelegate location] longitude];
	float time = [[appDelegate timeManager] elapsed];
	
	float rotationY = -(90-latitude)*(M_PI/180);
	float rotationZ1 = -longitude*(M_PI/180);
	float rotationZ2 = -time*(M_PI/180);
	
	float maX,maY,maZ;
	
	// Matrix vermenigvuldiging met draai om de  z-as (tijd)
	maX = (cos(rotationZ2)*brX+(-sin(rotationZ2)*brY)+0*brZ);
	maY = (sin(rotationZ2)*brX+cos(rotationZ2)*brY+0*brZ);
	maZ = (0*brX+0*brY+1*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	// Matrix vermenigvuldiging met draai om de  z-as (locatie)
	maX = (cos(rotationZ1)*brX+(-sin(rotationZ1)*brY)+0*brZ);
	maY = (sin(rotationZ1)*brX+cos(rotationZ1)*brY+0*brZ);
	maZ = (0*brX+0*brY+1*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	// Matrix vermenigvuldiging met draai om de y-as (locatie)
	maX = (cos(rotationY)*brX+0*brY+sin(rotationY)*brZ);
	maY = (0*brX+1*brY+0*brZ);
	maZ = ((-sin(rotationY)*brX)+0*brY+cos(rotationY)*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	Vertex3D result = Vertex3DMake(brX, brY, brZ);
	
	//NSLog(@"Resultaat x:%f y:%f z:%f",-brX,-brY,-brZ);
	
	return result;
}

@end

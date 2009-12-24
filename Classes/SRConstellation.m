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


@implementation SRConstellation

@synthesize lines, name, ra, dec;

-(void)calculateRADec {
	float RATemp, totRA, totDec;
	
	for(SRConstellationLine* aLine in lines) {
		RATemp = 0;
		
		if(atan2(aLine.start.y, aLine.start.x) < 0) {
			totRA += atan2(aLine.start.y, aLine.start.x) + (2*M_PI);
		}
		else {
			totRA += atan2(aLine.start.y, aLine.start.x);
		}
		
		if(atan2(aLine.end.y, aLine.end.x) < 0) {
			totRA += atan2(aLine.end.y, aLine.end.x) + (2*M_PI);
		}
		else {
			totRA += atan2(aLine.end.y, aLine.end.x);
		}
		
		totDec += acos((aLine.start.z)/sqrt(pow(aLine.start.x,2)+pow(aLine.start.y,2)+pow(aLine.start.z,2))) + acos((aLine.end.z)/sqrt(pow(aLine.end.x,2)+pow(aLine.end.y,2)+pow(aLine.end.z,2)));
	}
	
	ra = ((180/M_PI) * ((totRA/([lines count] * 2)))) + 180;
	//if(ra < 0) { ra += 24; }
	dec = 90 - ((180/M_PI) * (totDec/([lines count] * 2)));
	
	NSLog(@"%@: .. RA: %f Dec: %f", name, ra, dec); 
}

-(void)draw {
	glVertexPointer(3, GL_FLOAT, 12, constellationPoints);
	glDrawArrays(GL_LINES, 0, [lines count] * 2);
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

@end

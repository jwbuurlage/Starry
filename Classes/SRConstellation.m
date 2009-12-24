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

@synthesize lines, name, ra, dec, nameTexture;

-(void)calculateRADec {
	float RATemp, totRA, totDec;
	BOOL stayHigh;
	int i = 0;
	
	for(SRConstellationLine* aLine in lines) {
		RATemp = atan2(aLine.start.y, aLine.start.x);
		
		if(i == 0) { if(RATemp > 0) { stayHigh = TRUE; } else { stayHigh = FALSE; } ++i; 		
			if([name isEqualToString:@"UMa"] || [name isEqualToString:@"Peg"]) {
				if(stayHigh) { NSLog(@"high");  } else { NSLog(@"low"); } 
			}
		}
		
		
		if(stayHigh && RATemp < M_PI) {
			RATemp += 2*M_PI;
		}
		else if (!stayHigh && RATemp > 0) {
			RATemp -= 2*M_PI;
		}
		totRA += RATemp;
		
		if([name isEqualToString:@"UMa"] || [name isEqualToString:@"Peg"]) {
			NSLog(@"%f",RATemp * (12/M_PI));
		}
		
		RATemp = atan2(aLine.end.y, aLine.end.x);
		if(stayHigh && RATemp < M_PI) {
			RATemp += 2*M_PI;
		}
		else if (!stayHigh && RATemp > 0) {
			RATemp -= 2*M_PI;
		}
		totRA += RATemp;
		
		if([name isEqualToString:@"UMa"] || [name isEqualToString:@"Peg"]) {
			NSLog(@"%f",RATemp * (12/M_PI));
		}
		
		totDec += acos((aLine.start.z)/sqrt(pow(aLine.start.x,2)+pow(aLine.start.y,2)+pow(aLine.start.z,2))) + acos((aLine.end.z)/sqrt(pow(aLine.end.x,2)+pow(aLine.end.y,2)+pow(aLine.end.z,2)));
	}
	
	ra = ((180/M_PI) * ((totRA/([lines count] * 2))));
	if(ra > 360) { ra -= 360; }
	if(ra < 0) { ra += 360; }	
	dec = 90 - ((180/M_PI) * (totDec/([lines count] * 2)));
	
	NSLog(@"%@: .. RA: %f Dec: %f", name, ra, dec); 
	
	ra += 180;
	
	texturePosition = Vertex3DMake(20.0 * sin(totDec/([lines count] * 2)) * cos(totRA/([lines count] * 2)),
								   20.0 * sin(totDec/([lines count] * 2)) * sin(totRA/([lines count] * 2)),
								   20.0 * cos(totDec/([lines count] * 2)));
	
	nameTexture = [[Texture2D alloc] initWithString:name dimensions:CGSizeMake(64, 64) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:1.0];
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

@end

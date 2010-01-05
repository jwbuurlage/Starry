//
//  SRSettingsManager.m
//  Sterren
//
//  Created by Thijs Scheepers on 06-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRSettingsManager.h"


@implementation SRSettingsManager

@synthesize brightnessFactor,showRedOverlay,showConstellations;

-(id)init {
	if([super init]) {
		NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
		
		brightnessFactor = [prefs floatForKey:@"SRbrightness"];
		if(brightnessFactor <= 0) {
			brightnessFactor = 1.0;
		}
		showConstellations = [prefs boolForKey:@"SRshowConstellations"];
		showRedOverlay = [prefs boolForKey:@"SRshowRedOverlay"];
		
	}
	return self;
}
-(void)setBrightnessFactor:(double)factor {
	if (factor > 3) {
		brightnessFactor = 3;
	}
	else if (factor < 0.5) {
		brightnessFactor = 0.5;
	}
	else {
		brightnessFactor = factor;
	}
}
@end

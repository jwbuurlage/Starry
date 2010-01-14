//
//  SRTimeManager.m
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


#import "SRTimeManager.h"

@implementation SRTimeManager

@synthesize simulatedDate, totalInterval, moduleInstance, speed, elapsed, playing;

-(id)init {
	if(self = [super init]) {
		//owner = theOwner;
		simulatedDate = [[NSDate alloc] init];
		speed = 1;
		playing = TRUE;
	}
	return self;
}

-(NSString*)theTime {
	NSString* returnString;
	if([[[NSLocale currentLocale] localeIdentifier] isEqualToString:@"en_US"]) {
		returnString = [simulatedDate descriptionWithCalendarFormat:@"%I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	}
	else {
		returnString = [simulatedDate descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	}
		return returnString;
}

-(NSString*)theDate {
	NSString* returnString;
	if([[[NSLocale currentLocale] localeIdentifier] isEqualToString:@"en_US"]) {
		returnString = [simulatedDate descriptionWithCalendarFormat:@"%m-%d-%Y" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	}
	else {
		returnString = [simulatedDate descriptionWithCalendarFormat:@"%d-%m-%Y" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	}
	return returnString;
}

-(int)speed {
	return speed;
}

-(void)fwd {
	if(playing) {
		if(speed == -1) {
			speed = 1;
			speed = speed * 2;
		}
		else if(speed < 0) {
			speed = speed / 2;
		}
		else if(speed >= 1) {
			speed = speed * 2;
		}
	}
	else {
		if(speedPause > 0) {
			speed = speedPause;
			playing = TRUE;
		}
		else {
			speed = 2;
			playing = TRUE;
		}
	}
}

-(void)rew {
	if(playing) {
		if(speed == 1) {
			speed = -1;
			speed = speed * 2;
		}
		else if(speed <= -1) {
			speed = speed * 2;
		}
		else if(speed > 1) {
			speed = speed / 2;
		}
	}
	else {
		if(speedPause < 0) {
			speed = speedPause;
			playing = TRUE;
		}
		else {
			speed = -2;
			playing = TRUE;
		}
	}
}

-(void)playPause {
	if(playing) {
		speedPause = speed;
		speed = 0;
		playing = FALSE;
	}
	else {
		speed = 1;
		playing = TRUE;
	}
}

-(void)tickOfTime:(NSTimeInterval)timeElapsed {
	NSTimeInterval interval = timeElapsed;
	NSTimeInterval simulatedInterval = [simulatedDate timeIntervalSinceNow];
	[simulatedDate release];
	simulatedDate = [[NSDate alloc] initWithTimeIntervalSinceNow:simulatedInterval + (interval * speed)];
	
	totalInterval += interval * speed;
	//time interval sinds laatste
	//NSTimeInterval dateByAddingTimeInterval:
}

-(float)elapsed {
	//sidereal time
	//http://www.astro.uu.nl/~strous/AA/en/reken/sterrentijd.html
	
	
	NSTimeInterval dJ = [simulatedDate timeIntervalSinceDate:[NSDate dateWithString:@"2000-01-01 00:00:00 +0000"]]; 
					
	//seconden --> dagen
	dJ = dJ / 86400;
	
	float La = 99.967794687;
	float Lb = 360.9856473662860;
	float Lc = 2.907879 * pow(10, -13);
	float Ld = -5.302 * pow(10,-22);
						 
	float sT = La + ( Lb * dJ ) + ( Lc * pow(dJ,2) ) + ( Ld * pow(dJ,3) );
	sT = fmod(sT, 360);
	elapsed = sT; // in graden
	
	//[dJ release];
	
	return elapsed;
}

-(void)reset {
	[simulatedDate release];
	simulatedDate = [[NSDate alloc] init];
	/*if(playing) {
		speed = 1;
	}*/
	playing = FALSE;
	speed = 0;
	totalInterval = 10001;
}

-(BOOL)isGoingFast {
	if(speed > 1) {
		return YES;
	}
	else if(speed < -1) {
		return YES;
	}
	else {
		return NO;
	}
}


@end

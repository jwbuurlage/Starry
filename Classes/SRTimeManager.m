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

@synthesize simulatedDate, totalInterval, elapsed;

-(id)initWithOwner:(SRTimeModule*)theOwner {
	if(self = [super init]) {
		owner = theOwner;
		simulatedDate = [[NSDate alloc] init];
		actualDate = [[NSDate alloc] init];
		timeTicker = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tickOfTime:) userInfo:nil repeats:YES] retain];
		speed = 1;
	}
	return self;
}

-(NSString*)theTime {
	NSString* returnString = [simulatedDate descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	return returnString;
}

-(NSString*)theDate {
	NSString* returnString = [simulatedDate descriptionWithCalendarFormat:@"%d-%m-%Y" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	return returnString;
}

-(int)speed {
	return speed;
}

-(void)fwd {
	if(speed == -1) {
		speed = 1;
		speed = speed * 5;
	}
	else if(speed < 0) {
		speed = speed / 5;
	}
	else if(speed >= 1) {
		speed = speed * 5;
	}

	timeTicker = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tickOfTime:) userInfo:nil repeats:YES] retain];
}

-(void)rew {
	if(speed == 1) {
		speed = -1;
		speed = speed * 5;
	}
	else if(speed <= -1) {
		speed = speed * 5;
	}
	else if(speed > 1) {
		speed = speed / 5;
	}
	timeTicker = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tickOfTime:) userInfo:nil repeats:YES] retain];
}

-(void)tickOfTime:(NSTimer*)theTimer {
	NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:actualDate];
	NSTimeInterval simulatedInterval = [simulatedDate timeIntervalSinceNow];
	[simulatedDate release];
	simulatedDate = [[NSDate alloc] initWithTimeIntervalSinceNow:simulatedInterval + (interval * speed)];
	[actualDate release];
	actualDate = [[NSDate alloc] init];
	
	totalInterval += interval * speed;
	//time interval sinds laatste
	//NSTimeInterval dateByAddingTimeInterval:
}

-(void)adjustView {
	//sidereal time
	//http://www.astro.uu.nl/~strous/AA/en/reken/sterrentijd.html
	
	
	NSTimeInterval dJ = [simulatedDate timeIntervalSinceDate:[NSDate dateWithString:@"2000-01-01 00:00:00 +0100"]]; 
					
	//seconden --> dagen
	dJ = dJ / 86400;
	
	float La = 99.967794687;
	float Lb = 360.9856473662860;
	float Lc = 2.907879 * pow(10, -13);
	float Ld = -5.302 * pow(10,-22);
						 
	float sT = La + ( Lb * dJ ) + ( Lc * pow(dJ,2) ) + ( Ld * pow(dJ,3) );
	sT = fmod(sT, 360);
	elapsed = sT;
	
	//NSLog(@"elapsed: %f",sT / 15);
	
	/* NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:simulatedDate];
	float hour = [dateComponents hour];
	float minute = [dateComponents minute];
	float second = [dateComponents second];
	
	elapsed = (hour + (minute / 60) + (second / 3600)) / 24; */
	
	glRotatef(-elapsed, 0.0f, 0.0f, 1.0f);
	
	//[gregorian release];
	//[referenceDate release];
}

-(void)adjustViewBack {
	glRotatef(elapsed, 0.0f, 0.0f, 1.0f);
}

-(void)reset {
	[simulatedDate release];
	simulatedDate = [[NSDate alloc] init];
	speed = 1;
	totalInterval = 10001;
}


@end

//
//  SRTimeManager.h
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

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class SRTimeModule;

@interface SRTimeManager : NSObject {
	NSDate* simulatedDate;
	NSDate* actualDate;
	
	NSTimer* timeTicker;
	
	int totalInterval;
	int speed;
	float elapsed;
	
	SRTimeModule* moduleInstance;
	
	NSCalendar* gregorian;
}

@property (readonly) NSDate* simulatedDate;
@property (assign) int totalInterval;
@property (assign) SRTimeModule *moduleInstance;
@property (readonly) float elapsed;

-(id)init;
-(NSString*)theTime;
-(NSString*)theDate;
-(int)speed;
-(void)tickOfTime:(NSTimer*)theTimer;
-(void)fwd;
-(void)rew;
-(void)reset;
-(void)playPause;

@end

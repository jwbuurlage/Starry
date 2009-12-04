//
//  SterrenAppDelegate.h
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


#import <UIKit/UIKit.h>
#import "SRLocation.h"

@class GLView;

@interface SterrenAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GLView *glView;
	UIView *uiElementsView;
	NSMutableArray * stars;
	NSMutableArray * constellations;
	SRLocation* location;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLView *glView;
@property (nonatomic, retain) IBOutlet UIView *uiElementsView;
@property (nonatomic, retain) NSMutableArray *stars;
@property (nonatomic, retain) NSMutableArray *constellations;
@property (assign) SRLocation* location;

@end


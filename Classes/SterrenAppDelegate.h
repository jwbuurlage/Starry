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
#import "SRObjectManager.h"

@class GLView;

@interface SterrenAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GLView *glView;
	UIView *uiElementsView;
	SRLocation* location;
	SRTimeManager* timeManager;
	
	/*NSMutableArray * stars;
	NSMutableArray * constellations;*/
	
	SRObjectManager * objectManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLView *glView;
@property (nonatomic, retain) IBOutlet UIView *uiElementsView;
@property (readonly) SRObjectManager * objectManager;
//@property (nonatomic, retain) NSMutableArray *stars;
//@property (nonatomic, retain) NSMutableArray *constellations;
@property (readonly) SRLocation* location;
@property (readonly) SRTimeManager* timeManager;

@end


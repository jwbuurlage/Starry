//
//  SRSettingsManager.h
//  Sterren
//
//  Created by Thijs Scheepers on 06-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SRSettingsManager : NSObject {
	float brightnessFactor;
	BOOL showConstellations;
	BOOL showRedOverlay;
}

@property (nonatomic,readwrite) float brightnessFactor;
@property (nonatomic,readwrite) BOOL showConstellations;
@property (nonatomic,readwrite) BOOL showRedOverlay;

@end

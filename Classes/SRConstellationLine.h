//
//  SRConstellationLine.h
//  Sterren
//
//  Created by Jan-Willem Buurlage on 02-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"

@interface SRConstellationLine : NSObject {
	Vector3D start;
	Vector3D end;
}

@property (assign) Vector3D start;
@property (assign) Vector3D end;

@end

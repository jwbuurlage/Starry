//
//  SRMessier.h
//  Sterren
//
//  Created by Jan-Willem Buurlage on 07-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"

@interface SRMessier : NSObject {
	Vertex3D position;
	float mag;
	NSString* name;
}
@property (nonatomic, readwrite) Vertex3D position;
@property (nonatomic, readwrite) float mag;
@property (nonatomic, retain) NSString* name;

@end

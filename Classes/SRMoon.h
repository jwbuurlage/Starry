//
//  SRMoon.h
//  Sterren
//
//  Created by Jan-Willem Buurlage on 07-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"
#import "Texture2D.h"

@interface SRMoon : NSObject {
	Vertex3D position;
	int phase;
	
	Texture2D* nameTexture;
}

-(void)recalculatePosition:(NSDate*)theDate;
-(void)draw;

@property (readonly) Vertex3D position;
@property (readonly) int phase;


@end

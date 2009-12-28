//
//  SRHUD.h
//  Sterren
//
//  Created by Jan-Willem Buurlage on 27-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <UIKit/UIKit.h>

@interface SRHUD : NSObject {
	NSMutableArray* elements;
	Texture2D* backgroundTexture;
	CGPoint arrowOrigin;
	CGRect frame;
}

@end

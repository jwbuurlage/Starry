//
//  SRNamePlate.h
//  Sterren
//
//  Created by Jan-Willem Buurlage on 01-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "SRInterfaceElement.h"

@interface SRNamePlate : NSObject {
	NSMutableArray* elements;
	int yTranslate;
	
	BOOL visible;
	BOOL info;
	
	NSTimer* posiTimer;
	NSTimer* negiTimer;

}

@property (readonly) int yTranslate;
@property (readonly) BOOL visible;

-(void)draw;
-(void)hide;
-(void)setName:(NSString*)name inConstellation:(NSString*)constellation showInfo:(BOOL)theInfo;

@end

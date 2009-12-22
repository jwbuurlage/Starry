//
//  SRMessierInfo.h
//  Sterren
//
//  Created by Jan-Willem Buurlage on 09-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Texture2D.h"
#import "SRMessier.h"
#import "SRInterfaceElement.h"


@interface SRMessierInfo : NSObject {	
	SRMessier* currentMessier;
	
	NSMutableArray* elements;
	
	Texture2D* messierImage;
	Texture2D* messierText;
	Texture2D* interfaceBackground;
	Texture2D* pictureBackground;
	//text...
	
	float alphaValue;
	float alphaValueName;
	
	BOOL hiding;
	NSTimer* showTimer;
	
	int pictureBgX;
	int navBgX;
	
	//BOOL visible;
}

@property (nonatomic, assign) BOOL hiding;
@property (nonatomic, assign) float alphaValue;
@property (nonatomic, assign) float alphaValueName;

//+ (SRMessierInfo*)shared;
- (void)messierClicked:(SRMessier*)theMessier;
- (void)draw;
- (void)show; 
- (void)hide; 

@end

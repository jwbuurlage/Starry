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


@interface SRMessierInfo : NSObject {	
	SRMessier* currentMessier;
	
	Texture2D* messierImage;
	Texture2D* messierText;
	Texture2D* interfaceBackground;
	//text...
	
	//BOOL visible;
}

//@property (nonatomic, assign) BOOL visible;

//+ (SRMessierInfo*)shared;
- (void)messierClicked:(SRMessier*)theMessier;
- (void)draw;


@end

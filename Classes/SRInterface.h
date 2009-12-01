//
//  SRInterface.h
//
//  A part of Sterren.app, planitarium iPhone application.
//  Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//  Use without premission by Mote of Life is not authorised.
//
//  Mote of Life is a registred company at the Dutch Chamber of Commerce.
//  Chamber of Commerce registration number: 37126951
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "SRInterfaceElement.h"
#import "SRTimeModule.h"
#import "SRLocation.h"
#import "SRLocationModule.h"
#import "Texture2D.h"

@class SRRenderer;
@class SRCamera;

@interface SRInterface : NSObject {
	SRRenderer* renderer;
	SRCamera* camera;
	
	SRTimeModule* timeModule;
	SRLocationModule* locationModule;
	
	SRLocation* locationData;
		/* We moeten de data van SRLocation naar SRLocationModule krijgen, dit is de volgens mij de kortste route */
	
	NSMutableArray* UIElements;
	NSMutableArray* modules;

	NSString* clicker;
	
	GLuint textures[9];
	GLfloat textureCorners[150];
	GLfloat textureCoords[100];
	
	//klik support
	BOOL isClicking;
	CGRect rectClicked;
	
	int xTranslate;
	int count;
	
	NSTimer *posiTimer;
	NSTimer *negiTimer;
	
	UITextField *fieldTmp;
	
	NSString* currentlyEditingIdentifier;
}

@property (readonly) SRTimeModule* timeModule;
@property (readonly) SRRenderer* renderer;

-(id)initWithRenderer:(SRRenderer*)theRenderer;
-(void)loadTextureWithString:(NSString *)text intoLocation:(GLuint)location;
-(void)loadTexture:(NSString *)name intoLocation:(GLuint)location;
-(void)loadMenu;
-(void)loadModules;
-(void)renderInterface;
-(void)drawModules;
-(void)touchEnded;
-(void)hideInterface;
-(void)showInterface;
-(void)hideAllModules;
-(void)translate:(NSTimer*)theTimer;
-(GLuint)textures;
-(BOOL)UIElementAtPoint:(CGPoint)point;
- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle;
-(void)bringUpTheKeyboardWithText:(NSString *)placeholder onLocation:(int)location andSendResultsTo:(id)delegate;

@end

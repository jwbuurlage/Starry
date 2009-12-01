//
//  SRInterfaceElement.h
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
#import "Texture2D.h"

@interface SRInterfaceElement : NSObject {
	CGRect bounds;
	Texture2D* texture;
	NSString* identifier;
	BOOL clickable;
}

@property (assign) CGRect bounds;
@property (assign) Texture2D* texture;
@property (assign) NSString* identifier;
@property (assign) BOOL clickable;


-(id)initWithBounds:(CGRect)theBounds texture:(Texture2D*)theTexture identifier:(NSString*)theIdentifier clickable:(BOOL)isClickable;

@end

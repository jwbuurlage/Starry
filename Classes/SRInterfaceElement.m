//
//  SRInterfaceElement.m
//
//  A part of Sterren.app, planetarium iPhone application.
//  Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//  Use without premission by Mote of Life is not authorised.
//
//  Mote of Life is a registred company at the Dutch Chamber of Commerce.
//  Chamber of Commerce registration number: 37126951
//

#import "SRInterfaceElement.h"


@implementation SRInterfaceElement

@synthesize bounds, texture, identifier, clickable;

-(id)initWithBounds:(CGRect)theBounds texture:(Texture2D*)theTexture identifier:(NSString*)theIdentifier clickable:(BOOL)isClickable {
	if(self = [super init]) {
		bounds = theBounds;
		texture = theTexture;
		identifier = theIdentifier;
		clickable = isClickable;
	}
	return self;
}

@end

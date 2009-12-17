//
//  SRMessierInfo.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 09-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRMessierInfo.h"

@implementation SRMessierInfo

-(id)init {
	if(self = [super init]) {
		interfaceBackground = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"messierInfoBg.png"]];
	}
	return self;
}

//@synthesize visible;

/* + (SRMessierInfo*)shared {
	if(!sharedMessier) {
		sharedMessier = [[SRMessierInfo alloc] init];
	}
	return sharedMessier;
} */

- (void)messierClicked:(SRMessier*)theMessier {
	[messierImage release];
	messierImage = [[Texture2D alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [theMessier name]]]];
	messierText = [[Texture2D alloc] initWithString:[theMessier name] dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12];
	NSLog(@"loading: %@", [NSString stringWithFormat:@"%@.png", [theMessier name]]);
}

- (void)draw {
	[messierImage drawInRect:CGRectMake(0, 0, 480, 320)];
	[interfaceBackground drawInRect:CGRectMake(0, 90, 160, 141)];
	[messierText drawInRect:CGRectMake(0, 150, 128, 32)];
}

@end

//
//  SRMessierInfo.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 09-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRMessierInfo.h"


@implementation SRMessierInfo

-(void)messierClicked:(SRMessier*)theMessier {
	messierImage = [[Texture2D alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [theMessier name]]]];
}

-(void)draw {
	[messierImage drawInRect:CGRectMake(0,0, 50, 50)];
}

@end

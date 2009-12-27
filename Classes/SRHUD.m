//
//  SRHUD.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 27-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRHUD.h"


@implementation SRHUD

-(id)init {
	if(self = [super init]) {
		
	}
	return self;
} 

/*-(void)rebuild {
    //de view maken.. 
    //float width = [self frame].size.width + 10; //5 padding, 10 arrow
    //float height = [self frame].size.height + 10; //5 padding
    float x = arrowOrigin.x - width / 2;
    float y = arrowOrigin.y - height - 20;
	
	float t = 0;
	
	if(x < 5) {
		t = x - 5;
		x = 5;
	}
	
	arrowOrigin = CGPointMake(width/2 + t, height + 20);
	
    [self setFrame:CGRectMake(x, y, width, height + 20)];
	[representedView setFrame:CGRectMake(5,5, [representedView frame].size.width, [representedView frame].size.height)];
	[self addSubview:representedView];
}

- (void)rebuildBackgroundTexture
{ 	
	float x,y,width,height;
	CGContextRef context;
	
	
	CGRect mainRect = CGRectMake(x, y, width, height); 
	
	CGContextSetLineWidth(context, 2);
	
	//CGContextSetFillColor(context, [CPColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]);
	//CGContextSetStrokeColor(context, [CPColor colorWithRed:0.2 green:0.2 blue:0.2 alpha: 0.8]);
	
	//rounded rect + een pijl
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, arrowOrigin.x, arrowOrigin.y);
	CGContextAddLineToPoint(context, arrowOrigin.x - 10, arrowOrigin.y - 20);
	CGContextAddLineToPoint(context, 11, arrowOrigin.y - 20);
	CGContextAddCurveToPoint(context, 11, arrowOrigin.y - 20, 1, arrowOrigin.y - 20, 1, arrowOrigin.y - 30);
	CGContextAddLineToPoint(context, 1, 11);
	CGContextAddCurveToPoint(context, 1, 11, 1, 1, 11, 1);
	CGContextAddLineToPoint(context, width - 11, 1);
	CGContextAddCurveToPoint(context, width - 11, 1, width - 1, 1, width - 1, 11);
	CGContextAddLineToPoint(context, width - 1, height - 11);
	CGContextAddCurveToPoint(context, width - 1, height - 11, width - 1, height, width - 11,height);
	CGContextAddLineToPoint(context, arrowOrigin.x + 10, arrowOrigin.y - 20);
	CGContextClosePath(context);
	CGContextStrokePath(context);
	CGContextFillPath(context); 
} */

@end

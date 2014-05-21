//
//  HudView.m
//  MyLocations
//
//  Created by Daniel Hopkins on 5/21/14.
//  Copyright (c) 2014 niestudio. All rights reserved.
//

#import "HudView.h"

@implementation HudView

+ (instancetype)hudInView:(UIView *)view animated:(BOOL)animated
{
	HudView *hudView = [[HudView alloc] initWithFrame:view.bounds];
	
	hudView.opaque = NO;
	
	[view addSubview:hudView];
	view.userInteractionEnabled = NO;
	
	hudView.backgroundColor = [UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.5f];

	return hudView;
}

@end

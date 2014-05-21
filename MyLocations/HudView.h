//
//  HudView.h
//  MyLocations
//
//  Created by Daniel Hopkins on 5/21/14.
//  Copyright (c) 2014 niestudio. All rights reserved.
//


@interface HudView : UIView

+ (instancetype)hudInView:(UIView *)view animated:(BOOL)animated;

@property (nonatomic, strong) NSString *text;

@end

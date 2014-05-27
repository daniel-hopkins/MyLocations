//
//  LocationCell.h
//  MyLocations
//
//  Created by Daniel Hopkins on 5/27/14.
//  Copyright (c) 2014 niestudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@end

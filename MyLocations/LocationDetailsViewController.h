//
//  LocationDetailsViewController.h
//  MyLocations
//
//  Created by Daniel Hopkins on 5/12/14.
//  Copyright (c) 2014 niestudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;

@interface LocationDetailsViewController : UITableViewController

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Location *locationToEdit;

@end

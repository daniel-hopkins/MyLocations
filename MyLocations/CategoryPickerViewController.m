//
//  CategoryPickerViewController.m
//  MyLocations
//
//  Created by Daniel Hopkins on 5/13/14.
//  Copyright (c) 2014 niestudio. All rights reserved.
//

#import "CategoryPickerViewController.h"

@interface CategoryPickerViewController ()

@end

@implementation CategoryPickerViewController
{
	NSArray *_categories;
	NSIndexPath *_selectedIndexPath;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _categories = @[
		@"No Category",
		@"Apple Store",
		@"Bar",
		@"Bookstore",
		@"Club",
		@"Grocery Store",
		@"Historic Building",
		@"House",
		@"Icecream Vendor",
		@"Landmark",
		@"Park"];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	NSString *categoryName = _categories[indexPath.row];
	cell.textLabel.text = categoryName;
	
	if ([categoryName isEqualToString:self.selectedCategoryName]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		_selectedIndexPath = indexPath;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row != _selectedIndexPath.row)
	{
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		
		_selectedIndexPath = indexPath;
	}
}

@end

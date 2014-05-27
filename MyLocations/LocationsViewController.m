//
//  LocationsViewController.m
//  MyLocations
//
//  Created by Daniel Hopkins on 5/27/14.
//  Copyright (c) 2014 niestudio. All rights reserved.
//

#import "LocationsViewController.h"
#import "Location.h"
#import "LocationCell.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController
{
	NSArray *_locations;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	//1
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	//2
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	//3
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
	[fetchRequest setSortDescriptors:@[sortDescriptor]];
	 
	//4
	 NSError *error;
	 NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	 
	 if(foundObjects == nil)
	 {
		 FATAL_CORE_DATA_ERROR(error);
		 return;
	 }
	 
	 //5
	 _locations = foundObjects;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location"];
	
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	LocationCell *locationCell = (LocationCell *)cell;
	Location *location = _locations[indexPath.row];
	
	if ([location.locationDescription length] > 0) {
		locationCell.descriptionLabel.text = location.locationDescription;
	} else {
		locationCell.descriptionLabel.text = @"(No Description)";
	}
	
	if (location.placemark != nil) {
		locationCell.addressLabel.text = [NSString stringWithFormat:@"%@ %@, %@",
										  location.placemark.subThoroughfare,
										  location.placemark.thoroughfare,
										  location.placemark.locality];
	} else {
		locationCell.addressLabel.text = [NSString stringWithFormat:@"Lat: %.8f, Long: %.8f", [location.latitude doubleValue],[location.longitude doubleValue]];
	}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

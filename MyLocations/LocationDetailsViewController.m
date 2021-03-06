//
//  LocationDetailsViewController.m
//  MyLocations
//
//  Created by Daniel Hopkins on 5/12/14.
//  Copyright (c) 2014 niestudio. All rights reserved.
//

#import "LocationDetailsViewController.h"
#import "CategoryPickerViewController.h"
#import "HudView.h"
#import "Location.h"

@interface LocationDetailsViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *longitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end

@implementation LocationDetailsViewController
{
	NSString *_descriptionText;
	NSString *_categoryName;
	NSDate *_date;
//	Location *_locationToEdit;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		_descriptionText = @"";
		_categoryName = @"No Category";
		_date = [NSDate date];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.locationToEdit != nil) {
		self.title = @"Edit Location";
	}
	
	self.descriptionTextView.text = _descriptionText;
	self.categoryLabel.text = _categoryName;
	
	self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", self.coordinate.latitude];
	self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", self.coordinate.longitude];
	
	if (self.placemark != nil) {
		self.addressLabel.text = [self stringFromPlacemark:self.placemark];
	} else {
		self.addressLabel.text = @"No Address Found";
	}
	
	self.dateLabel.text = [self formatDate:_date];
	
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)hideKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint point = [gestureRecognizer locationInView:self.tableView];
	
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
	
	if (indexPath != nil && indexPath.section == 0 && indexPath.row == 0) {
		return;
	} else {
		[self.descriptionTextView resignFirstResponder];
	}
}

- (NSString *)stringFromPlacemark:(CLPlacemark *)placemark
{
	return [NSString stringWithFormat:@"%@ %@, %@, %@ %@, %@",
			placemark.subThoroughfare, placemark.thoroughfare,
			placemark.locality, placemark.administrativeArea,
			placemark.postalCode, placemark.country];
}

- (NSString *)formatDate:(NSDate *)theDate
{
	static NSDateFormatter *formatter = nil;
	if (formatter == nil)
	{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
	}
	
	return [formatter stringFromDate:theDate];
}


- (IBAction)done:(id)sender
{
	HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
	
	Location *location = nil;
	
	if (self.locationToEdit != nil) {
		hudView.text = @"Updated";
		location = self.locationToEdit;
	} else {
		hudView.text = @"Tagged";
		location = [NSEntityDescription
					insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
	}
	
	location.locationDescription = _descriptionText;
	location.locationDescription = _descriptionText;
	location.category = _categoryName;
	location.latitude = @(self.coordinate.latitude);
	location.longitude = @(self.coordinate.longitude);
	location.date = _date;
	location.placemark = self.placemark;
	
	NSError *error;
	if (![self.managedObjectContext save:&error]) {
		NSLog(@"Error: %@", error);
		FATAL_CORE_DATA_ERROR(error);
		return;
	}

	[self performSelector:@selector(closeScreen) withObject:nil afterDelay:0.6];
}

- (IBAction)cancel:(id)sender
{
	[self closeScreen];
}
- (void)closeScreen
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PickCategory"]) {
		CategoryPickerViewController *controller = segue.destinationViewController;
		controller.selectedCategoryName = _categoryName;
	}
}

- (void)setLocationToEdit:(Location *)newLocationToEdit
{
	NSLog(@"inside setLocationToEdit %@", newLocationToEdit);
	if (_locationToEdit != newLocationToEdit) {
		_locationToEdit = newLocationToEdit;
		
		_descriptionText = _locationToEdit.locationDescription;
		_categoryName = _locationToEdit.category;
		_date = _locationToEdit.date;
		
		self.coordinate = CLLocationCoordinate2DMake(
						 [_locationToEdit.latitude doubleValue],
						 [_locationToEdit.longitude doubleValue]);
		self.placemark = _locationToEdit.placemark;
	}
}

#pragma mark - UITableViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	_descriptionText = [textView.text stringByReplacingCharactersInRange:range withString:text];
	
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	_descriptionText = textView.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 0) {
		return 88;
	} else if (indexPath.section == 2 && indexPath.row == 2) {
		CGRect rect = CGRectMake(100, 10, 205, 10000);
		self.addressLabel.frame = rect;
		[self.addressLabel sizeToFit];
		
		rect.size.height = self.addressLabel.frame.size.height;
		self.addressLabel.frame = rect;
		
		return self.addressLabel.frame.size.height + 20;
	} else {
		return 44;
	}
}

- (IBAction)categoryPickerDidPickCategory:(UIStoryboardSegue *)segue
{
	CategoryPickerViewController *viewController = segue.sourceViewController;
	
	_categoryName = viewController.selectedCategoryName;
	self.categoryLabel.text = _categoryName;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section ==0 || indexPath.section == 1) {
		return indexPath;
	} else {
		return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 0) {
		[self.descriptionTextView becomeFirstResponder];
	}
}

@end

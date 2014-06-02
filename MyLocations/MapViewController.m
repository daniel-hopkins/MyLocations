//
//  MapViewController.m
//  MyLocations
//
//  Created by Daniel Hopkins on 6/1/14.
//  Copyright (c) 2014 niestudio. All rights reserved.
//

#import "MapViewController.h"
#import "Location.h"

@interface MapViewController ()<MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController
{
	NSArray *_locations;
}

- (IBAction)showUser
{
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
	
	[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (IBAction)showLocations
{
	MKCoordinateRegion region = [self regionForAnnotations:_locations];
	[self.mapView setRegion:region animated:YES];
}

- (MKCoordinateRegion)regionForAnnotations: (NSArray *)annotations
{
	MKCoordinateRegion region;
	
	if ([annotations count] == 0) {
		region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
	} else if ([annotations count] == 1) {
		id <MKAnnotation> annotation = [annotations lastObject];
		region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
	} else {
		CLLocationCoordinate2D topLeftCoord;
		topLeftCoord.latitude = -90;
		topLeftCoord.longitude = 180;
		
		CLLocationCoordinate2D bottomRightCoord;
		bottomRightCoord.latitude = 90;
		bottomRightCoord.longitude = -180;
		
		for (id <MKAnnotation> annotation in annotations) {
			topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
			
			topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
			
			bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
			
			bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
		}
		
		const double extraSpace = 1.1;
		
		region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
		
		region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
		
		region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
		
		region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
	}
	return [self.mapView regionThatFits:region];
}

- (void)updateLocations
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	
	NSError *error;
	NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (foundObjects == nil) {
		FATAL_CORE_DATA_ERROR(error);
		return;
	}
	if (_locations != nil) {
		[self.mapView removeAnnotations:_locations];
	}
	_locations = foundObjects;
	[self.mapView addAnnotations:_locations];
	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self updateLocations];
	
	if ([_locations count] > 0) {
		[self showLocations];
	}
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	//1
	if ([annotation isKindOfClass:[Location class]]) {
		//2
		static NSString *identifier = @"Location";
		MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if (annotationView == nil) {
			annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
		
		
			//3
			annotationView.enabled = YES;
			annotationView.canShowCallout = YES;
			annotationView.animatesDrop = NO;
			annotationView.pinColor = MKPinAnnotationColorGreen;
			
			//4
			UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[rightButton addTarget:self action:@selector(showLocationDetails:) forControlEvents:UIControlEventTouchUpInside];
			annotationView.rightCalloutAccessoryView = rightButton;
		} else {
			annotationView.annotation = annotation;
		}
		//5
		UIButton *button = (UIButton *)annotationView.rightCalloutAccessoryView;
		button.tag = [_locations indexOfObject:(Location *)annotation];
		return annotationView;
		
	}
	return nil;
	
	
}

- (void)showLocationDetails:(UIButton *)button
{
	
}

@end












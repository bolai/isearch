//
//  SecondViewController.m
//  goout
//
//  Created by chen xin on 13-8-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSMapView.h>


@implementation SecondViewController{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    //
}
@synthesize viewForMap;
@synthesize distancelabel;
@synthesize mapView;
@synthesize camera;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)changesomething:(id)sender{
    NSLog(@"second view test....");

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSString * x = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString * y = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        // Reverse Geocoding
        NSLog(@"Resolving the Address");
        NSString static * address;
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                           placemark.subThoroughfare, placemark.thoroughfare,
                           placemark.postalCode, placemark.locality,
                           placemark.administrativeArea,
                           placemark.country];
                
                //NSLog(@"%@", address);
                
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
        
        
        NSLog(@"%@",x);
        NSLog(@"%@",y);
        NSLog(@"%@", address);
        
        [locationManager stopUpdatingLocation];
        
        
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude-1, currentLocation.coordinate.longitude-1);
        marker.title = address;
        marker.snippet = address;
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];  
        CLLocationDistance meters=[currentLocation distanceFromLocation:dist];
        
        NSLog(@"distance is:%f",meters);
        self.distancelabel.text = [NSString stringWithFormat:@"%.0f", meters];
        
        camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude zoom:6];
        self.mapView = [GMSMapView mapWithFrame:viewForMap.bounds camera:camera];
        //self.mapView.delegate = self;
        
        NSLog(@"width is:%f",viewForMap.bounds.size.width);
        NSLog(@"height is:%f",viewForMap.bounds.size.height);
        
        mapView_.myLocationEnabled = YES;
        
        //display marker on mapview
        marker.map = mapView_;

        //display mapview
        //self.mapview = mapView_;
        [self.viewForMap addSubview:mapView];
    }
}

- (void)viewDidUnload
{
    [self setDistancelabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

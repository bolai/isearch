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
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        NSLog(@"address is %@", address);
        
        [locationManager stopUpdatingLocation];
        
        
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        //test
        marker.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude - 0.1, currentLocation.coordinate.longitude - 0.1);
        
        marker.title = @"1888 Ice Cream";
        marker.snippet = address;
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];  
        CLLocationDistance meters=[currentLocation distanceFromLocation:dist];
        
        NSLog(@"distance is:%f",meters);
        self.distancelabel.text = [NSString stringWithFormat:@"distance %.0f meters", meters];
        
        camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude zoom:10];
        self.mapView = [GMSMapView mapWithFrame:self.viewForMap.bounds camera:camera];
        self.mapView.delegate = self;
        
        
        //NSLog(@"width is:%f",self.viewForMap.frame.size.width);
        //NSLog(@"height is:%f",self.viewForMap.frame.size.height);
        
        self.mapView.myLocationEnabled = YES;
        self.mapView.settings.myLocationButton = YES;
        
        //display marker on map
        marker.map = self.mapView;
        
        //circle
        CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        GMSCircle *circle = [GMSCircle circleWithPosition:circleCenter radius:10000]; //1000 meters
        circle.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.2];
        circle.strokeColor = [UIColor redColor];
        circle.strokeWidth = 5;
        //display circle on map
        circle.map = self.mapView;

        //display map
        if(self.mapView){
            [self.viewForMap addSubview:self.mapView];
        } 
        
        /*
        if(self.mapView){
            UISearchBar *searchBar = [[UISearchBar alloc] init];
            searchBar.backgroundColor = [UIColor yellowColor];
            [self.mapView addSubview:searchBar];
        }
         */
        
    }
}

- (void)viewDidUnload
{
    [self setViewForMap:nil];
    [self setDistancelabel:nil];
    [self setMapView:nil];
    [self setCamera:nil];
    locationManager = nil;
    geocoder = nil;
    placemark = nil;
    [self setViewForMap:nil];
    [super viewDidUnload];
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

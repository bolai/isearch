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
    CLLocation *tempCurrentLocation;
    UIImage *choosenImgs;
    //
}
@synthesize viewForMap;
@synthesize distancelabel;
@synthesize mapView;
@synthesize camera;

- (void)selectedAssets:(NSArray *)assets{
    
}

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
    tempCurrentLocation = newLocation;
    
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
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shareButton.frame = CGRectMake(viewForMap.bounds.size.width - 70, viewForMap.bounds.size.height - 100, 60, 40);
        shareButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [shareButton setTitle:@"雷锋" forState:UIControlStateNormal];
        [shareButton setTag:1];
        [shareButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [viewForMap addSubview:shareButton];
        
        UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        testButton.frame = CGRectMake(viewForMap.bounds.size.width - 70, viewForMap.bounds.size.height - 160, 60, 40);
        testButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [testButton setTitle:@"微信" forState:UIControlStateNormal];
        [testButton setTag:2];
        [testButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewForMap addSubview:testButton];
        
    }
}

- (void)buttonClicked:(UIButton*)button
{
    if ([button tag] == 1) {
        //做雷锋
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(tempCurrentLocation.coordinate.latitude, tempCurrentLocation.coordinate.longitude);
        
        marker.title = @"haha";
        marker.snippet = @"haha";
        marker.map = self.mapView;
        
        //alumpicker 
        ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] init];
        ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
        [albumController setParent:imagePicker];
        [imagePicker setDelegate:self];
        
        // Present modally
        [self presentViewController:imagePicker
                           animated:YES
                         completion:nil];
        
        
    } else if([button tag] == 2){
        //weixin
        
    }
    else{
        NSLog(@"Button %d clicked.", [button tag]);
    }
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"Button d clicked.");
    

    UIView *textAndImageView = [[UIView alloc] initWithFrame:CGRectMake(0, viewForMap.bounds.size.height - 220, viewForMap.bounds.size.width, 300)];
    textAndImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [textAndImageView setTag:4];
    textAndImageView.backgroundColor = [UIColor whiteColor];
    
    [viewForMap addSubview:textAndImageView];

    
    //想说点什么。。。
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, viewForMap.bounds.size.height - 320, viewForMap.bounds.size.width - 20, 30);
    textView.text = @"想说点什么。。。";
    textView.textColor = [UIColor lightGrayColor];
    textView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [textView setTag:3];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont fontWithName:@ "Arial" size:18.0];
    [textView.layer setBorderWidth:1.0];
    [textView setReturnKeyType:UIReturnKeyDone];
    [textView resignFirstResponder];

    
    [textAndImageView addSubview:textView];
    
    
    int i = 0;
    for (id obj in info) {
        if ([obj isKindOfClass:[NSDictionary class]]){
            //显示多个图片
            NSDictionary *dic = obj;
            UIImage *chosenImage = [dic objectForKey : UIImagePickerControllerOriginalImage];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i * 70, viewForMap.bounds.size.height - 280, 60, 60)];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.image = chosenImage;
            [imageView.layer setBorderWidth:1.0];
            [textAndImageView addSubview:imageView];
            i++;
        }
    }
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"long press...");
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    
    marker.title = @"address";
    marker.snippet = @"test";
    marker.animated = YES;
    marker.map = self.mapView;

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

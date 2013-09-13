//
//  SecondViewController.m
//  goout
//
//  Created by chen xin on 13-8-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "InterestViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSMapView.h>
#import "InterestPickerViewController.h"


@implementation InterestViewController{
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


}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad]; 
            
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"贡献"     
                                                                            style:UIBarButtonItemStyleDone     
                                                                           target:self     
                                                                           action:@selector(clickRightButton)];  
    //把按钮添加入导航栏集合中  
    [self.navigationItem setRightBarButtonItem:rightButton]; 
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

-(void)clickRightButton  
{  
    NSLog(@"点击了导航栏右边按钮");  
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                        otherButtonTitles: @"拍照", @"从手机相册选择",nil]; 
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}  

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
        //呼出的菜单按钮点击后的响应
      if (buttonIndex == actionSheet.cancelButtonIndex)
      {
         NSLog(@"取消");
         return;
      }
    	 
    switch (buttonIndex)
    {
       case 0:  //打开照相机拍照
       [self takePhoto];
        break;
        	 
        case 1:  //打开本地相册
        [self AlbumPicker];
         break;
    }
}

- (void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)AlbumPicker
{
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
    
    //Present modally
    [self presentViewController:imagePicker
                      animated:YES
                    completion:nil];
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
        //NSString * x = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //NSString * y = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        // Reverse Geocoding
        //Resolving the Address
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
        
        //NSLog(@"%@",x);
        //NSLog(@"%@",y);
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
        /*
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
        [testButton setTitle:@"test" forState:UIControlStateNormal];
        [testButton setTag:2];
        [testButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewForMap addSubview:testButton];
         */
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
        
    } else if([button tag] == 2){
        //weixin
    }
    else{
        NSLog(@"Button %d clicked.", [button tag]);
    }
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self pushPickerView:info];
 }

//after take photo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSArray *array = [NSArray arrayWithObject:info];
    [self pushPickerView:array];
}

- (void)pushPickerView:(NSArray *)info{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    InterestPickerViewController *ipc = [storyboard instantiateViewControllerWithIdentifier:@"InterestPickerViewController"];
    [self.navigationController pushViewController:ipc animated:YES];
    
    //handle image in InterestPickerViewController
    [ipc handleImage:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

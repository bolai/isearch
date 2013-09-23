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
#import "InterestMarkerViewController.h"


@implementation InterestViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *tempCurrentLocation;
    UIImage *choosenImgs;
    UIView *myInfoView;
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

        [locationManager stopUpdatingLocation];
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *comments = [defaults objectForKey:@"comments"];
        NSData *imagesInfo = [defaults dataForKey:@"imagesInfo"];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:imagesInfo];
        GMSMarker *marker;
        if ([array count] > 0) {
            NSString *sAddress = [defaults objectForKey:@"address"];
        
            double dLatitude = [defaults doubleForKey:@"latitude"];
            
            double dLongitude = [defaults doubleForKey:@"longitude"];
            
            marker = [[GMSMarker alloc] init];
            //
            marker.position = CLLocationCoordinate2DMake(dLatitude, dLongitude);
            NSLog(@"lat  %f", dLatitude);
            NSLog(@"long  %f", dLongitude);
            NSLog(@"comments  %@", comments);
            NSLog(@"adress  %@", sAddress);

            marker.title = comments;
            marker.snippet = sAddress;
            marker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
            //marker.icon = [UIImage imageNamed:@"users.png"];
            marker.userData = array;
        }
        
        
        /*
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];  
        CLLocationDistance meters=[currentLocation distanceFromLocation:dist];
        
        NSLog(@"distance is:%f",meters);
        self.distancelabel.text = [NSString stringWithFormat:@"distance %.0f meters", meters];
         */
        
        camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude zoom:10];
        self.mapView = [GMSMapView mapWithFrame:self.viewForMap.bounds camera:camera];
        self.mapView.delegate = self;
        
        
        self.mapView.myLocationEnabled = YES;
        self.mapView.settings.myLocationButton = YES;
                
        
        //display marker on map
        if(marker){
            marker.map = self.mapView;
        }
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

-(UIView *)mapView:(GMSMapView *) aMapView markerInfoWindow:(GMSMarker*) marker
{
    myInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 64)];
    myInfoView.backgroundColor = [UIColor whiteColor];
    myInfoView.layer.cornerRadius = 6;
    myInfoView.layer.borderWidth = 6;//设置边框的宽度
    myInfoView.layer.borderColor = [[UIColor whiteColor] CGColor];//设置边框的颜色,增加立体感
    myInfoView.layer.masksToBounds = YES;
    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 60, 60)];
    //myImageView.transform = CGAffineTransformMakeRotation(5.0);
    
    NSArray *imageInfos = marker.userData;

    for (id obj in imageInfos) {
        if ([obj isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *dic = obj;
            UIImage *image = [dic objectForKey : UIImagePickerControllerOriginalImage];
            //显示一个图片
            myImageView.image = image;

            break;
        }

    }

    [myInfoView addSubview:myImageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(62, 2, 100, 20)];
    title.textColor = [UIColor blueColor];
    title.text = marker.title;
    title.font = [UIFont systemFontOfSize:14];    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(62, 24, 100, 40)];
    desc.numberOfLines = 2; 
    desc.text = marker.snippet;
    desc.font = [UIFont systemFontOfSize:12];
    
    [myInfoView addSubview:myImageView];
    [myInfoView addSubview:title];
    [myInfoView addSubview:desc];
    
    UIImageView *linkToOtherView = [[UIImageView alloc] initWithFrame:CGRectMake(178, 40, 20, 20)];
    linkToOtherView.image = [UIImage imageNamed:@"next_icon.png"];
    
    [myInfoView addSubview:linkToOtherView];
    

    return myInfoView;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    InterestMarkerViewController *imc = [storyboard instantiateViewControllerWithIdentifier:@"InterestMarkerViewController"];
    
    [imc handelTitle:marker.title desc:marker.snippet address:[self currentAddress] imageInfos:marker.userData];
    
    [self.navigationController pushViewController:imc animated:YES];
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

    NSString *currentAddress = [self currentAddress];
    [ipc handleImage:info address:currentAddress latitude:tempCurrentLocation.coordinate.latitude longitude: tempCurrentLocation.coordinate.longitude];
    NSLog(@"55555 %f", tempCurrentLocation.coordinate.latitude);
    NSLog(@"%@", currentAddress);
    [self.navigationController pushViewController:ipc animated:YES];
}

- (NSString *)currentAddress{
    NSString static * address;
    [geocoder reverseGeocodeLocation:tempCurrentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSString * subThoroughfare = placemark.subThoroughfare;
            if (subThoroughfare == NULL) {
                subThoroughfare = @" ";
            }
            NSString * thoroughfare = placemark.thoroughfare;
            if (thoroughfare == NULL) {
                thoroughfare = @" ";
            }
            NSString * postalCode = placemark.postalCode;
            if (postalCode == NULL) {
                postalCode = @" ";
            }
            NSString * locality = placemark.locality;
            if (locality == NULL) {
                locality = @" ";
            }
            NSString * administrativeArea = placemark.administrativeArea;
            if (administrativeArea == NULL) {
                administrativeArea = @" ";
            }
            NSString * country = placemark.country;
            if (country == NULL) {
                country = @" ";
            }
            address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",
                       subThoroughfare, thoroughfare,
                       postalCode, locality,
                       administrativeArea,
                       country];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
    return address;
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

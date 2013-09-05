//
//  SecondViewController.h
//  goout
//
//  Created by chen xin on 13-8-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GMSMapView.h>

@interface SecondViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewForMap;
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) IBOutlet GMSCameraPosition *camera;

@property (weak, nonatomic) IBOutlet UILabel *distancelabel;

- (IBAction)changesomething:(id)sender;

@end

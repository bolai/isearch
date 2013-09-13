//
//  SecondViewController.h
//  goout
//
//  Created by chen xin on 13-8-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GMSMapView.h>
#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"

@interface InterestViewController : UIViewController<ELCAssetSelectionDelegate,ELCImagePickerControllerDelegate,CLLocationManagerDelegate,GMSMapViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewForMap;
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) IBOutlet GMSCameraPosition *camera;

@property (weak, nonatomic) IBOutlet UILabel *distancelabel;

- (IBAction)changesomething:(id)sender;
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;
- (void)AlbumPicker;
- (void)takePhoto;
- (void)pushPickerView:(NSArray *)info;

@end

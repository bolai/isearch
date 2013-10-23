//
//  InterestMarkerViewController.h
//  goout
//
//  Created by chen xin on 13-9-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"

@interface InterestMarkerViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,FGalleryViewControllerDelegate, UIActionSheetDelegate>{
    
	NSArray *localCaptions;
    NSArray *localImages;
    NSArray *networkCaptions;
    NSArray *networkImages;
	FGalleryViewController *localGallery;
    FGalleryViewController *networkGallery;
}
//@property (weak, nonatomic) IBOutlet UITableView *table;
//@property (weak, nonatomic) IBOutlet UITableViewCell *cellTitle;
//@property (weak, nonatomic) IBOutlet UITableViewCell *cellDesc;
//@property (weak, nonatomic) IBOutlet UITableViewCell *cellLocation;
//@property (weak, nonatomic) IBOutlet UITableViewCell *cellImage;
//@property (strong, nonatomic) NSArray *listData;


- (void)handelTitle:(NSString *)title desc:(NSString *)desc address:(NSString *)address imageInfos:(NSArray *)imageInfos;
- (void)addToMyFavority;
- (void)removeFromMyFavority;
@end

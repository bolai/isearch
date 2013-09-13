//
//  InterestPickerViewController.h
//  goout
//
//  Created by chen xin on 13-9-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestPickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UITextField *comments;

- (void)handleImage:(NSArray *)info;
@end

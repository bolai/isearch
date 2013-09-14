//
//  InterestPickerViewController.m
//  goout
//
//  Created by chen xin on 13-9-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "InterestPickerViewController.h"

@implementation InterestPickerViewController{
    NSArray *imagesInfo;
    NSString *myAddress;
    double myLatitude;
    double myLongitude;
}
@synthesize imageContainerView;
@synthesize comments;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)handleImage:(NSArray *)info address:(NSString *)address latitude:(double)latitude longitude:(double) longitude
{
    imagesInfo = info;
    myAddress = address;
    myLatitude = latitude;
    myLongitude = longitude;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建一个左边按钮  
    UIBarButtonItem *CancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"     
                                                                 style:UIBarButtonItemStylePlain     
                                                                target:self     
                                                                action:@selector(clickCancelButton)];  
    
    //创建一个右边按钮  
    UIBarButtonItem *OKButton = [[UIBarButtonItem alloc] initWithTitle:@"发送"     
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(clickOKButton)];  
    //把按钮添加入导航栏集合中  
    [self.navigationItem setLeftBarButtonItem:CancelButton];
    [self.navigationItem setRightBarButtonItem:OKButton]; 
    
    
    //想说点什么。。。
    comments.contentMode = UIViewContentModeScaleToFill;
    [comments setReturnKeyType:UIReturnKeyDone];    
    comments.delegate = self;
    
    //auto resize
    imageContainerView.contentMode = UIViewContentModeScaleToFill;
    
    //显示图片
    int i = 0; int j = 0;int z = 0;
    for (id obj in imagesInfo) {
        if ([obj isKindOfClass:[NSDictionary class]]){
            //显示多个图片
            NSDictionary *dic = obj;
            
            UIImage *chosenImage = [dic objectForKey : UIImagePickerControllerOriginalImage];
            if(i%4 == 0) {j = 0; z++;}
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageContainerView.bounds.origin.x + 10 + j * 69, imageContainerView.bounds.origin.y + 5 + (z - 1) * 69, 65, 65)];
            imageView.image = chosenImage;

            [imageContainerView addSubview:imageView];
            i++;j++;
        }
    }
}

-(void)clickCancelButton  
{  
    NSLog(@"点击了导航栏 cancel 按钮");  
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消发送图片?" message:@"" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alert show]; 
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Button 是 Pressed");
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 1:
            NSLog(@"Button 否 Pressed");
            break;
        default:
            break;
    }
}

-(void)clickOKButton  
{  
    NSLog(@"点击了导航栏 OK 按钮");  
    
    //保存数据：
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:comments.text forKey:@"comments"];
    
    NSData *imagesData = [NSKeyedArchiver archivedDataWithRootObject:imagesInfo];
    [defaults setObject:imagesData forKey:@"imagesInfo"];
    
    [defaults setObject:myAddress forKey:@"address"];
    [defaults setDouble:myLatitude forKey:@"latitude"];
    [defaults setDouble:myLongitude forKey:@"longitude"];
    
    //[defaults setObject:[NSString stringWithFormat: @"%f", myLatitude] forKey:@"latitude"];
    //[defaults setObject:[NSString stringWithFormat: @"%f", myLongitude] forKey:@"longitude"];

    
    [defaults synchronize];//用synchronize方法把数据持久化到standardUserDefaults数据库
    
     
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setImageContainerView:nil];
    [self setComments:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder]; 
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

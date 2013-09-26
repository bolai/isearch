//
//  InterestMarkerViewController.m
//  goout
//
//  Created by chen xin on 13-9-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "InterestMarkerViewController.h"

@implementation InterestMarkerViewController
{
    NSString *myTitle;
    NSString *myDesc;
    NSString *myAddress;
    NSArray *myImageInfos;
}

@synthesize table;
@synthesize cellTitle;
@synthesize cellDesc;
@synthesize cellLocation;
@synthesize cellImage;
@synthesize listData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)handelTitle:(NSString *)title desc:(NSString *)desc address:(NSString *)address imageInfos:(NSArray *)imageInfos;
{
    myTitle = title;
    myDesc = desc;
    myAddress = address;
    myImageInfos = imageInfos;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView {
	[super loadView];
    
	//self.title = @"FGallery";
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
	//localCaptions = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"Happy New Year!",@"Frosty Web",nil];
    //localImages = [[NSArray alloc] initWithObjects: @"lava.jpeg", @"hawaii.jpeg", @"audi.jpg",nil];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:nil];
    for (id obj in myImageInfos) {
        if ([obj isKindOfClass:[NSDictionary class]]){
            //显示多个图片
            NSDictionary *dic = obj;
            
            UIImage *image = [dic objectForKey : UIImagePickerControllerOriginalImage];
            [array addObject:image];
            
        }
    }
    
    localImages = [[NSArray alloc] initWithArray: array];
    
    networkCaptions = [[NSArray alloc] initWithObjects:@"Happy New Year!",@"Frosty Web",nil];
    networkImages = [[NSArray alloc] initWithObjects:@"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg",nil];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"兴趣点"     
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(clickRightButton)];  
    //把按钮添加入导航栏集合中  
    [self.navigationItem setRightBarButtonItem:rightButton]; 

}

-(void)clickRightButton  
{  
    NSLog(@"点击了导航栏右边按钮");  
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"加入我的兴趣点", @"从我的兴趣点 删除",nil]; 
    
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
        case 0:  //加入我的兴趣点
            [self addToMyFavority];
            break;
            
        case 1:  //从我的兴趣点 删除
            [self removeFromMyFavority];
            break;
    }
}
- (void)change:(NSString *)value{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];    
    NSArray *allData = [defaults arrayForKey:@"allData"];
    for (id obj in allData) {
        if ([obj isKindOfClass:[NSMutableDictionary class]]){
            NSMutableDictionary *dic = obj;
            [dic setObject:value forKey:@"favorite"];
        }
    }
    
    [defaults synchronize];//用synchronize方法把数据持久化到standardUserDefaults数据库
}
- (void)addToMyFavority{
    [self change:@"yes"];
}

- (void)removeFromMyFavority{
  [self change:@"no"];
}


- (void)viewDidUnload
{
    [self setTable:nil];
    [self setCellTitle:nil];
    [self setCellDesc:nil];
    [self setCellLocation:nil];
    [self setCellImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
     self.listData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark Table View Data Source Methods 
//返回行数
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section { 
    return 3; 
}

//新建某一行并返回
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    

	static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier.
	if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
	}
	    
     switch (indexPath.row) {
         case 0:
         {
             cell.textLabel.text = @"说明"; 
             cell.detailTextLabel.text = myTitle;
             cell.detailTextLabel.numberOfLines = 3;
             cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
             cell.textLabel.textColor = [UIColor lightGrayColor];
             break;
         }
         case 1:
         {
             cell.textLabel.text = @"地址"; 
             cell.detailTextLabel.text = myDesc;
             cell.detailTextLabel.numberOfLines = 3;
             cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
             cell.textLabel.textColor = [UIColor lightGrayColor];

             break;
         }
         case 2:
         {
             cell.textLabel.text = @"图片"; 
             cell.textLabel.textColor = [UIColor lightGrayColor];

             UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 2, 60, 60)];

             int i = 0;
             for (id obj in myImageInfos) {
                 if ([obj isKindOfClass:[NSDictionary class]]){
                     if(i == 3) break;//最多显示三张图片
                     //显示多个图片
                     NSDictionary *dic = obj;
                     
                     UIImage *image = [dic objectForKey : UIImagePickerControllerOriginalImage];
                     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50 + i*62, 2, 60, 60)];
                     imageView.image = image;
                     [view addSubview:imageView];
                     i++;
                 }
             }
             [cell.contentView addSubview:view];
             cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
             
             break;
         }
         default:
             break;
     }
     
	return cell;

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
    NSUInteger row = [indexPath row];
    if (row == 0 || row == 1) {
        return nil;
    }
    return indexPath; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
    NSUInteger row = [indexPath row]; 
    //NSString *rowValue = [listData objectAtIndex:row]; 
    
    //NSString *message = [[NSString alloc] initWithFormat: 
   //                      @"You selected %@", rowValue]; 
    //UIAlertView *alert = [[UIAlertView alloc] 
     //                     initWithTitle:@"Row Selected!" 
     //                     message:message 
      //                    delegate:nil 
      //                    cancelButtonTitle:@"Yes I Did" 
      //                    otherButtonTitles:nil]; 
    //[alert show]; 
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    InterestGallaryViewController *igc = [storyboard instantiateViewControllerWithIdentifier:@"InterestGallaryViewController"];
    [igc handelImage:myImageInfos];
    [self.navigationController pushViewController:igc animated:YES];
     */
   // FGalleryViewController *myGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
   // [self.navigationController pushViewController:myGallery animated:YES];
    if(row == 2){
        localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:localGallery animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 64; 
}

#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    if( gallery == localGallery ) {
        num = [localImages count];
    }
    else if( gallery == networkGallery ) {
        num = [networkImages count];
    }
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	if( gallery == localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == localGallery ) {
        caption = [localCaptions objectAtIndex:index];
    }
    else if( gallery == networkGallery ) {
        caption = [networkCaptions objectAtIndex:index];
    }
	return caption;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [localImages objectAtIndex:index];
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [networkImages objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

@end

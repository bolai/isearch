//
//  FirstViewController.m
//  goout
//
//  Created by chen xin on 13-8-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuViewController.h"
#import "ASIHTTPRequest.h"
#import "Tesseract.h"
#import "DishesDefinitionReader.h"
#import "SimilarSearcher.h"
#import "ScoredDoc.h"
#import "MenuTranslator.h"

@implementation MenuViewController

@synthesize ourcameraimage = _ourcameraimage;
@synthesize firstbutton = _firstbutton;
@synthesize ourtext = _ourtext;
@synthesize ourlabel = _ourlabel;

- (void)changesomething:(id)sender{
    NSLog(@"test....");
    //for camera
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //select from photo library
    //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    //for RESTful
    //[self startrequest];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *chosenImage = [info objectForKey : UIImagePickerControllerEditedImage];
    if(!chosenImage) chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.ourcameraimage.image = chosenImage;
    
    Tesseract * tesseract = [[Tesseract alloc] initWithDataPath:@"" language:@"eng"];
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    // NSLog(@"%@", documentDirPath);
    NSString *tessdataDirPath = [documentDirPath stringByAppendingPathComponent:@"tessdata"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:tessdataDirPath] == NO)
        if([manager fileExistsAtPath:documentDirPath])
            [manager createDirectoryAtPath:tessdataDirPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSArray *langArray = [[NSArray alloc] initWithObjects: @"eng", nil];
    for(NSString *lang in langArray)
    {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:lang ofType:@"traineddata"];
        // NSLog(@"source: %@", sourcePath);
        NSString *destPath = [tessdataDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.traineddata", lang]];
        // NSLog(@"dest: %@", destPath);
        
        if([manager fileExistsAtPath:destPath] == NO)
            [manager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];

    [tesseract setImage:chosenImage];
    [tesseract recognize];
    
    NSString * recogText = [tesseract recognizedText];
    NSLog(@"test..: %@",recogText);
    //self.ourtext.text = recogText;
    [tesseract clear];
    
    
    NSString * cnFile = @"menu.cn.v0.0.1";
    NSString * enFile = @"menu.en.v0.0.1";
    MenuTranslator *mt = [[MenuTranslator alloc] initWithLangs:enFile srcLang:@"en" targetFile:cnFile targetLang:@"cn"];
    NSString *target = @"a kind of mapo";
    NSMutableArray *sdList = [mt translate:target];
    NSLog(@"Search the dish: %@", target);
    // insert code here...
    for (int i=0; i<[sdList count]; i++) {
        ScoredDoc *sd = [sdList objectAtIndex:i];
        NSLog(@"The top %i dish is: %@, with the similarity %f", i, [[sd dish] dishName], [sd score]);
        self.ourtext.text = [[[sdList objectAtIndex:0] dish] dishName];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)startrequest{
    NSLog(@"test2...");
    NSLog(@"%@",_ourlabel.text);
    
    _ourtext.text = @"北京欢迎你";
    NSLog(@"%@",_ourtext.text);
    NSString * a = @"testmy";
    NSLog(@"%@", a);
    /*
    NSURL *url = [NSURL URLWithString:@"http://allseeing-i.com"];
    ASIHTTPRequest *myrequest = [ASIHTTPRequest requestWithURL:url];
    [myrequest startSynchronous];
    NSData *myresponse = [myrequest responseData];
    NSError *error = [myrequest error];
    if(!error){
        NSLog(@"test3...");
    }
    */
    
    /*
    NSString * strURL = [[NSString alloc] initWithFormat:
                         @"http://127.0.0.1:8080"];
    NSURL * url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    
    [request startSynchronous];
    
    NSLog(@"请求完毕");
    
    NSData * mydata = [request responseData];
    
    NSString * mystring = [request responseString];
    
    NSError * error =[request error];
    
    if(!error){
        mydata = [request responseData];
        NSDictionary * resDict = [NSJSONSerialization JSONObjectWithData:mydata options:NSJSONReadingAllowFragments error:nil];
        
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"So...OK" otherButtonTitles:nil];
        [myAlertView show];
    }
}

- (void)viewDidUnload
{
    [self setOurtext:nil];
    [self setOurlabel:nil];
    [self setOurcameraimage:nil];
    [self setFirstbutton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

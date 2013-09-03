//
//  ThirdViewController.m
//  goout
//
//  Created by chen xin on 13-8-31.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"

@implementation ThirdViewController

@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"about.html" ofType:nil]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

@end

//
//  main.m
//  goout
//
//  Created by chen xin on 13-8-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import "MenuViewController.h"
#import "DishesDefinitionReader.h"
#import "SimilarSearcher.h"
#import "ScoredDoc.h"
#import "MenuTranslator.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        /*
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
        }
         */
    }
    return 1;
}

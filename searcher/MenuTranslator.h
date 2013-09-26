//
//  MenuTranslator.h
//  searcher
//
//  Created by Edwin Zhao on 13-9-23.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dish.h"
#import "SimilarSearcher.h"
#import "DishStore.h"

@interface MenuTranslator : NSObject
{
    SimilarSearcher *similarSearcher;
    DishStore* dishStore;
    NSString *srcLang;
    NSString *targetLang;
}
-(id) initWithLangs: (NSString*)srcFile srcLang:(NSString*)srcLanguage targetFile:(NSString*)targetFile targetLang:(NSString*)targetLang;

-(NSMutableArray*)translate:(NSString*)input;

@end

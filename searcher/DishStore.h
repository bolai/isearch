//
//  DishStore.h
//  searcher
//
//  Created by Edwin Zhao on 13-9-23.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dish.h"

@interface DishStore : NSObject
{
    NSMutableDictionary *languageDict;
}

-(void)addLanguagePack:(NSString*)lan fileName:(NSString*)fn;

-(Dish*)getDishByID:(int)dishID targetLang:(NSString*)lang;

-(NSMutableArray*)getAllDishesByLang:(NSString*)lang;

@end

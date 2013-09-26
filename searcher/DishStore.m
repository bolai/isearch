//
//  DishStore.m
//  searcher
//
//  Created by Edwin Zhao on 13-9-23.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import "DishStore.h"
#import "DishesDefinitionReader.h"

@implementation DishStore

-(id)init
{
    self = [super init];
    if(self){
        languageDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)addLanguagePack:(NSString*)lan fileName:(NSString*)fn
{
    DishesDefinitionReader* reader = [[DishesDefinitionReader alloc] initWithFilePath:fn];
    [reader readDishDefinitions];
    NSMutableArray *dishList = [reader dishesList];
    if (dishList) {
        NSMutableDictionary* dishDict = [[NSMutableDictionary alloc]initWithCapacity:[dishList count]];
        
        for (int i=0; i<[dishList count]; i++) {
            Dish *dish = [dishList objectAtIndex:i];
            NSNumber *idP = [NSNumber numberWithInt:[dish ID]] ;
            [dishDict setObject:dish forKey:idP];
        }
        [languageDict setObject:dishDict forKey:lan];
    }
}

-(Dish*)getDishByID:(int)dishID targetLang:(NSString*)lang
{
    NSMutableDictionary* dishDict = [languageDict objectForKey:lang]; 
    if (dishDict) {
        NSNumber *idP = [NSNumber numberWithInt:dishID];
        return [dishDict objectForKey:idP];
    }
    return NULL;
}

-(NSMutableArray*)getAllDishesByLang:(NSString*)lang
{
    NSMutableDictionary* dishDict = [languageDict objectForKey:lang];
    if (dishDict) {
        return [[NSMutableArray alloc] initWithArray:[dishDict allValues]];
    }
    return NULL;
}

@end

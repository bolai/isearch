//
//  MenuReader.m
//  goout
//
//  Created by Edwin Zhao on 13-9-13.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import "DishesDefinitionReader.h"
#import "Dish.h"

@implementation DishesDefinitionReader

-(id)initWithFilePath:(NSString *)fileName
{
    if (self=[super init]) {
        definitionFilePath = fileName;    
    }
    return (self);
}

// reads dishes from the definition file
-(BOOL)readDishDefinitions
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:definitionFilePath ofType:@"plist"];
    if (plistPath == Nil) {
        return FALSE;
    }
//    NSFileManager *ns = [NSFileManager defaultManager];

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (data==Nil) {
        return FALSE;
    }
    definitionVersion = [data objectForKey:@"version"]; 
    [data removeObjectForKey:@"version"];
    
    NSEnumerator * enumerator = [data keyEnumerator];
    id key;
    dishesList = [NSMutableArray new];
    while (key = [enumerator nextObject]) {
        NSMutableDictionary* definition = [data objectForKey:key];
        NSString *name = [definition objectForKey:@"name"];
        NSString *description = [definition objectForKey:@"description"];
        NSMutableArray *meterials = [definition objectForKey:@"meterials"];
        NSMutableArray *pictures = [definition objectForKey:@"pictureFiles"];
        NSString    *dishType = [definition objectForKey:@"dishType"];
        Dish *dish = [[Dish alloc] init];
        [dish setID:[key intValue]];
        [dish setDishName:name];
        [dish setDescription:description];
        [dish setMeterials:meterials];
        [dish setPictureFiles:pictures];
        [dish setDishType:[Dish getDishType:dishType]];
        [dishesList addObject:dish];
        NSLog(@"%@", definition);
    }
    return TRUE;
}

-(NSString*)definitionVersion
{
    return definitionVersion;
}

-(NSMutableArray*)dishesList
{
    return dishesList;
}


@end

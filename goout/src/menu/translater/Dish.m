//
//  MenuItem.m
//  goout
//
//  Created by Edwin Zhao on 13-9-12.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import "Dish.h"

@implementation Dish

+(enum DishType) getDishType: (NSString*)dt
{
    if ([@"Western" isEqualToString:dt]) {
        return Western;
    }
    else{
        return Chinese;
    }
        
}

-(int)ID
{
    return (ID);
}

-(void)setID:(int)i_id
{
    ID = i_id;
}

-(NSString*)dishName
{
    return (dishName);
}

-(void)setDishName:(NSString*)s_dishName
{
    dishName = s_dishName;
}

-(NSString *)description
{
    return description;
}

-(void)setDescription: (NSString*)s_description
{
    description = s_description;
}

-(NSArray*) meterials
{
    return meterials;
}

-(void)setMeterials:(NSMutableArray*)a_meterials
{
    meterials = a_meterials;
}

-(void)addMeterial:(NSString*)s_meterial
{
    if (meterials == Nil) {
        meterials = [NSMutableArray new];
    }
    [meterials addObject: s_meterial];
}

-(enum DishType)dishType
{
    return dishType;
}

-(void)setDishType:(enum DishType)t_dishType
{
    dishType = t_dishType;
}


-(NSMutableArray*)pictureFiles
{
    return pictureFiles;
}

-(void) setPictureFiles: (NSMutableArray*)a_pictureFiles
{
    pictureFiles = a_pictureFiles;
}

-(void) addPictureFile: (NSString*)pictureFile
{
    if (pictureFiles == Nil) {
        pictureFiles = [NSMutableArray new];
    }
    [pictureFiles addObject:pictureFile];
}

@end

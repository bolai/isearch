//
//  MenuItem.h
//  goout
//
//  Created by Edwin Zhao on 13-9-12.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dish : NSObject
{

    enum DishType{Western, Chinese};
    
    // the global id of a dish
    int ID;
    
    // the dish's name
    NSString *dishName;
    
    // description about the dish
    NSString *description;
    
    // the materials of the dish
    NSMutableArray *meterials;
    
    // type of the dish, e.g. western food or chinese food
    enum DishType dishType;
    
    // the path of the picture of the dish
    NSMutableArray* pictureFiles;
    
}

+(enum DishType) getDishType: (NSString*)dt;

-(int)ID;

-(void)setID:(int)i_id;

-(NSString*)dishName;

-(void)setDishName:(NSString*)s_dishName;

-(NSString *)description;

-(void)setDescription: (NSString*)s_description;

-(NSMutableArray*) meterials;

-(void)setMeterials:(NSMutableArray*)a_meterials;

-(void)addMeterial:(NSString*)s_meterial;

-(enum DishType)dishType;

-(void)setDishType:(enum DishType)t_dishType;

-(NSMutableArray*)pictureFiles;

-(void) setPictureFiles: (NSMutableArray*)a_pictureFiles;

-(void) addPictureFile: (NSString*)pictureFile;

@end

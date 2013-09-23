//
//  MenuReader.h
//  goout
//
//  Created by Edwin Zhao on 13-9-13.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishesDefinitionReader : NSObject

{
    // file name of the definition file 
    NSString *definitionFilePath;
    
    // the version of the dishes definition file
    NSString* definitionVersion;
    
    // the dishes read out from the definition file
    NSMutableArray * dishesList;
    
}

-(id)initWithFilePath:(NSString *)fileName;

// reads dishes from the definition file
-(BOOL)readDishDefinitions;

-(NSString*)definitionVersion;

-(NSMutableArray*)dishesList;

@end

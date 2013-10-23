//
//  ScoredDoc.h
//  searcher
//
//  Created by Edwin Zhao on 13-9-20.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dish.h"

@interface ScoredDoc : NSObject
{
    double score;
    Dish *dish;
}
@property(nonatomic) double score;
@property(nonatomic,retain) Dish *dish;

-(id) initWithScAndDish: (double)ascore dish:(Dish *)adish;

@end

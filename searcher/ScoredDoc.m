//
//  ScoredDoc.m
//  searcher
//
//  Created by Edwin Zhao on 13-9-20.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import "ScoredDoc.h"

@implementation ScoredDoc

@synthesize score;
@synthesize dish;

-(id) initWithScAndDish: (int)ascore dish:adish
{
    self = [super init];
    if (self) {
        score = ascore;
        dish = adish;
    }
    return self;
}

@end

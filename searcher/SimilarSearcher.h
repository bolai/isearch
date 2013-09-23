//
//  SimilarSearcher.h
//  searcher
//
//  Created by Edwin Zhao on 13-9-20.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimilarSearcher : NSObject

{
    // the number of similar results to return by searchSimilar method
    int similarResultNum;
    // array of Dish instances
    NSMutableArray *dishList;
}

-(id) initWithDishes:(NSMutableArray*) aDishList similarResultNum:(int)srn;

-(NSMutableArray*) searchSimilar: (NSString*)similar;

@end

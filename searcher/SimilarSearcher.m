//
//  SimilarSearcher.m
//  searcher
//
//  Created by Edwin Zhao on 13-9-20.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import "SimilarSearcher.h"
#import "Dish.h"
#import "ScoredDoc.h"

@implementation SimilarSearcher

-(id) initWithDishes:(NSMutableArray*) aDishList similarResultNum:(int)srn
{
    self = [super init];
    if (self) {
        dishList = aDishList;
        similarResultNum = srn;
    }
    return self;
}

-(int) min: (int)a b:(int)b c:(int)c
{
    int tmp = a<b?a:b;
    return tmp<c?tmp:c;
}

-(int) max: (NSString*)aString aIndex:(int)aIndex 
   bString:(NSString *)bString bIndex:(int)bIndex
{
    int aRest = (int)[aString length]-aIndex;
    int bRest = (int)[bString length]-bIndex;
    return aRest>bRest ? aRest:bRest;
}

-(BOOL) isTheEnd: (NSString*)strValue index:(int)index
{
    if (index>=[strValue length]) {
        return TRUE;
    }
    else{
        return FALSE;
    }
}

-(int) getStringsSimilar: (NSString*)aString aIndex:(int)aIndex 
                 bString:(NSString *)bString bIndex:(int)bIndex
{
    // one of them reach to end
    if ([self isTheEnd:aString index:aIndex] || [self isTheEnd:bString index:bIndex]) {
        return [self max:aString aIndex:aIndex bString:bString bIndex:bIndex];
    }
    char aChar = [aString characterAtIndex:aIndex];
    char bChar = [bString characterAtIndex:bIndex];
    if (aChar == bChar) {
        return [self getStringsSimilar:aString aIndex:(aIndex+1) bString:bString bIndex:(bIndex+1)];
    }
    else{
        return [self min:[self getStringsSimilar:aString aIndex:(aIndex+1) bString:bString bIndex:bIndex] 
                       b:[self getStringsSimilar:aString aIndex:aIndex bString:bString bIndex:(bIndex+1)] 
                       c:[self getStringsSimilar:aString aIndex:(aIndex+1) bString:bString bIndex:(bIndex+1)]]+1;
    }
}

-(int) scoreDocument: (NSString*)targetString aDish:(Dish*) dish
{
    NSString * dishName = [dish dishName];
    return [self getStringsSimilar:targetString aIndex:0 bString:dishName bIndex:0];
}

-(void) insertScoredDoc: (NSMutableArray  *)scoredDocList scoredDoc:(ScoredDoc *)scoredDoc
{
    int insertIndex = -1;
    for (int i=0; i<[scoredDocList count]; i++) {
        ScoredDoc *current = [scoredDocList objectAtIndex:i];
        if (current.score >= scoredDoc.score) {
            insertIndex = i;
            break;
        }
    }
    // none is larger
    if (insertIndex==-1) {
        if ([scoredDocList count]>=similarResultNum) {
            return ;
        }
        insertIndex = (int)[scoredDocList count];
    }
    [scoredDocList insertObject:scoredDoc atIndex:insertIndex];
    // if too much docs after inserted
    if ([scoredDocList count] > similarResultNum) {
        [scoredDocList removeLastObject];
    }
}

-(NSMutableArray*) searchSimilar: (NSString*)targetString
{
    if (targetString == NULL || dishList == NULL || [dishList count]==0) {
        return NULL;
    }
    NSMutableArray *scoredDocList = [[NSMutableArray alloc] initWithCapacity:similarResultNum]; 
    
    for (int i=0; i<[dishList count]; i++) {
        Dish *dish = [dishList objectAtIndex:i];
        int score = [self scoreDocument: targetString aDish:dish];
        double dscore = ((double)score)/((double)[[dish dishName] length]);
        ScoredDoc *sd = [[ScoredDoc alloc] initWithScAndDish:dscore dish:dish];
        [self insertScoredDoc: scoredDocList scoredDoc:sd];
    }  
    
    return scoredDocList;
}



@end

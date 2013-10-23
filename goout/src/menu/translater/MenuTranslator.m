//
//  MenuTranslator.m
//  searcher
//
//  Created by Edwin Zhao on 13-9-23.
//  Copyright (c) 2013年 Hw. All rights reserved.
//

#import "MenuTranslator.h"
#import "ScoredDoc.h"



@implementation MenuTranslator


-(id) initWithLangs: (NSString*)srcFile srcLang:(NSString*)srcLanguage targetFile:(NSString*)targetFile targetLang:(NSString*)targetLanguage
{
    self = [super init];
    if (self) {
        srcLang = srcLanguage;
        targetLang = targetLanguage;    
        dishStore = [[DishStore alloc] init];
        [dishStore addLanguagePack:srcLang fileName:srcFile];
        [dishStore addLanguagePack:targetLang fileName:targetFile];
        similarSearcher = [[SimilarSearcher alloc] initWithDishes:[dishStore getAllDishesByLang:srcLang] similarResultNum:5];
        
    }
    return self;
}

-(NSMutableArray*)translate:(NSString*)input
{
    NSMutableArray* srcScoredDishes = [similarSearcher searchSimilar:input];
    if (!srcScoredDishes) {
        return NULL;
    }
    for (int i=0; i<[srcScoredDishes count]; i++) {
        ScoredDoc *srcScoredDoc = [srcScoredDishes objectAtIndex:i];
        Dish *targetDish = [dishStore getDishByID:[srcScoredDoc.dish ID] targetLang:targetLang];
        srcScoredDoc.dish = targetDish;
    }
    return srcScoredDishes;
}

@end

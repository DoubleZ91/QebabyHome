//
//  BabyHomeDataManager.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-16.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QebabyHomeData.h"
@interface BabyHomeDataManager : NSObject <BabyHomeDataOperateDelegate>

@property (nonatomic, retain) QebabyHomeData* babyHomeData;


- (void) setIsExcuBlock:(bool)isExcu;
- (NSInteger) numOfBlocks;
#pragma mark -
#pragma mark - BabyHomeDataOperateDelegate
- (void) addGrowthsDataWithURL:(NSURL*)url;     //通过URL增加数据 需同时更新allGrowthsData和babyMsgData
- (void) addGrowthsDataWithDict:(NSDictionary*)dataDict;        //通过字典增加数据 需同时更新allGrowthsData和babyMsgData
- (void) addGrowthsDataWithDictArray:(NSArray *)arrayDict;

- (void) addGrowthsDataWithStartAndLength:(NSUInteger)start withLength:(NSUInteger)length;
- (void) resetGrowthsData;
- (void) updateGrowthsData;
@end

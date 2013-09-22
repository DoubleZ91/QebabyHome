//
//  BabyHomeDataManager.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-16.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "BabyHomeDataManager.h"
#import "BabyNetwork.h"
#import "BabyNetworkManager.h"
#import "BabyMsgData.h"
#import "BabyDefine.h"
#import "QebabyHomeData.h"
#import <dispatch/dispatch.h>
static Boolean isExcuteBlock = true;
static int numOfBlock = 0;
@interface BabyHomeDataManager()
@property (nonatomic, retain) dispatch_queue_t dispatchQueue;
//因为不能中止block，所以通过两个变量来做判断 一个block总数，一个是否执行
@end
@implementation BabyHomeDataManager

- (BabyHomeDataManager*) init
{
    self = [super init];
    if (self) {
        _babyHomeData = [QebabyHomeData shareQebabyHomeData];
        _dispatchQueue = dispatch_queue_create("Json Image Load", NULL);
    }
    return self;
}
/**add more msg about baby*/
- (void) addGrowthsDataWithURL:(NSURL*)url
{
    NSData *data = [BabyNetworkManager babyGrowthsWithURL:url];
    NSDictionary *jsonDict = [self _parseDictionaryFromData:data];
    [self _addGrowthsDataWithJSONDict:jsonDict];
    [self updateGrowthsData];
}

- (void) addGrowthsDataWithDict:(NSDictionary*) dataDict
{
    [_babyHomeData.allGrowthsData addObject: dataDict];
    [self updateGrowthsData];
}

- (void) addGrowthsDataWithDictArray:(NSArray *)arrayDict
{
    [_babyHomeData.allGrowthsData addObjectsFromArray:arrayDict];
    [self updateGrowthsData];
}
- (NSInteger) dataCount
{
    return _babyHomeData.allGrowthsData.count;
}


- (void) addGrowthsDataWithStartAndLength:(NSUInteger)start withLength:(NSUInteger)length
{
    NSData *data = [BabyNetworkManager babyGrowthsWithStartAndLength:start Length:length];
    NSDictionary *jsonDict = [self _parseDictionaryFromData:data];
    [self _addGrowthsDataWithJSONDict:jsonDict];
    [self updateGrowthsData];
}

- (void) addGrowthsDataWithNumber:(NSInteger) num
{
    NSUInteger start = [_babyHomeData dataCount];
    [self addGrowthsDataWithStartAndLength:start withLength:num];
    [self updateGrowthsData];
}
- (void) resetGrowthsData
{
    
}
- (void) updateGrowthsData
{
    NSUInteger needUpdateCount = [_babyHomeData dataCount] - _babyHomeData.oldUpdateCount;
    //更新以oldUpdateCount为起点 , needUpdateCount为偏移量的数据
    if (needUpdateCount > 0) {
        NSInteger tmpUpdataStart = _babyHomeData.oldUpdateCount;
        _babyHomeData.oldUpdateCount += needUpdateCount;
        numOfBlock++;
        dispatch_async(_dispatchQueue, ^(void) {
            if (!isExcuteBlock) {
                numOfBlock--;
                return;
            }
            NSDictionary *dict;
            BabyMsgData *msg;
            NSInteger tmpStart = tmpUpdataStart; //用tmpStart做中转，这样子tmpStart的值就不会根据needUpdateCount实时的值，而是用加入线程块时候的值
            NSLog(@"XXXXX:%d", tmpStart);
            for (int i = 0; i < needUpdateCount; i++) {
#warning dispatch easy to error
                dict = [_babyHomeData.allGrowthsData objectAtIndex:(tmpStart + i)];
                BabyLog(@"begin to get msg............................");
                msg = [BabyNetwork requestBabyMsgWithJSONDictionary:dict];
                BabyLog(@"end to get msg.........................");
                @synchronized(_babyHomeData.babyMsgData)
                {
                    [_babyHomeData.babyMsgData addObject:msg];
                } 
                BabyLog(@"add msg to data.........................");
                [[NSNotificationCenter defaultCenter] postNotificationName:BabyMsgHadRefreshed object:nil];
                BabyLog(@"notification refresh data...................");
            }
            numOfBlock --;
            BabyLog(@"invoking block end.............");
        });
    }    
}
- (NSDictionary*) _parseDictionaryFromData:(NSData*)data
{
    NSError *error = nil;
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];  ///????&
    if (jsonDict != nil && error == nil)
    {
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"json is a Dictionary.");
            NSLog(@"%@", (NSDictionary*)jsonDict);
            return (NSDictionary*)jsonDict;
        }
    }
    return jsonDict;
}
-(void) _addGrowthsDataWithJSONDict:(NSDictionary*) jsonDict
{
    NSDictionary *dataDict = (NSDictionary*)[jsonDict objectForKey:@"data"];
    NSArray *growths = (NSArray*)[dataDict objectForKey:@"growths"];
    BabyLog(@"the is no growths for jsonDict! Add Growths Error.");
    [_babyHomeData.allGrowthsData addObjectsFromArray:growths];
    
    BabyLog(@"%@",_babyHomeData);
    BabyLog(@"The count of babyData is:%d",_babyHomeData.dataCount);
}

- (void) setIsExcuBlock:(bool)isExcu
{
    isExcuteBlock = isExcu;
}

- (NSInteger) numOfBlocks
{
    return numOfBlock;
}
@end

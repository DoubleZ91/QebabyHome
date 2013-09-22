//
//  QebabyHomeData.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-11.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyMsgData.h"
@protocol  BabyHomeDataOperateDelegate;

@interface QebabyHomeData : NSObject
/**过去更新到的数量*/
@property (nonatomic, assign) NSUInteger oldUpdateCount;
@property (nonatomic, retain) NSMutableArray *allGrowthsData;       //解析出来的json数据        json
@property (nonatomic, retain) NSMutableArray *babyMsgData;          //主页上已经读取的所有分享信息，是allGrowthsData中url解析后的结果     实际数据
@property (nonatomic, assign) bool isToDataEnd;                     //是否数据已经取完
@property (nonatomic, retain) id<BabyHomeDataOperateDelegate> urlDelegate;

+ (QebabyHomeData*) shareQebabyHomeData;
- (void) addGrowthsDataWithURL:(NSURL*)url;                     
- (void) addGrowthsDataWithDict:(NSDictionary*)dataDict;        //通过字典增加数据 需同时更新allGrowthsData和babyMsgData
- (void) addGrowthsDataWithDictArray:(NSArray*) arrayDict;      //通过字典数组增加数据 

- (NSInteger) dataCount;                                        //当前读取的数据总量
- (NSInteger) dataHeightForCell: (NSIndexPath*) indexPath;
- (NSInteger) countForContentImage:(NSIndexPath*) indexPath;

/**数据处理,json与msgData必须同步更新*/
- (void) addGrowthsDataWithNumber:(NSInteger) num;
- (void) addGrowthsDataWithStartAndLength:(NSUInteger)start withLength:(NSUInteger)length;
- (void) resetGrowthsData;
- (void) updateGrowthsData;
@end


/** QebabyHomeData网络修改时候的代理*/
@protocol BabyHomeDataOperateDelegate <NSObject>
@required
- (void) addGrowthsDataWithURL:(NSURL*)url;     //通过URL增加数据 需同时更新allGrowthsData和babyMsgData
- (void) addGrowthsDataWithDict:(NSDictionary*)dataDict;        //通过字典增加数据 需同时更新allGrowthsData和babyMsgData
- (void) addGrowthsDataWithDictArray:(NSArray*) arrayDict;      //通过字典数组增加数据 需同时更新allGrowthsData和babyMsgData

- (void) addGrowthsDataWithNumber:(NSInteger) num;
- (void) addGrowthsDataWithStartAndLength:(NSUInteger)start withLength:(NSUInteger)length;
- (void) resetGrowthsData;
- (void) updateGrowthsData;
@end
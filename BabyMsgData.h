//
//  BabyMsgData.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-12.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 发表信息的详细内容*/
@interface BabyMsgData : NSObject

@property (nonatomic, retain) NSString *name;           //用户名
@property (nonatomic, retain) UIImage *headImage;       //头像
@property (nonatomic, assign) NSUInteger timeInterval;   //发表日期

@property (nonatomic, retain) NSString *content;        //文字内容
@property (nonatomic, retain) NSArray *imageArray;      //图片集
@property (nonatomic, assign) NSInteger *totalHeight;   //总高度

- (BabyMsgData*) initWithAllMsg:(NSString*) name withHeadImage:(UIImage*) headImage
               withTime:(NSUInteger) time
            withContent:(NSString*)content
         withImageArray:(NSArray*)imageArray;

- (NSInteger) heightForMsgImage;
- (NSInteger) countForContentImage;
@end

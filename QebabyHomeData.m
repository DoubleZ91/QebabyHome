//
//  QebabyHomeData.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-11.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "QebabyHomeData.h"
#import "BabyNetwork.h"
#import "BabyHomeDataManager.h"
#import "BabyDefine.h"




static QebabyHomeData* qebabyHomeData;
@interface QebabyHomeData()

@end

@implementation QebabyHomeData
/** singleton*/
+ (QebabyHomeData*) shareQebabyHomeData
{
    if (qebabyHomeData == nil) {
        qebabyHomeData = [[QebabyHomeData alloc] init];
    }
    return qebabyHomeData;
}
- (QebabyHomeData*) init
{
    self = [super init];
    if (self) {
        _isToDataEnd = NO;
        _oldUpdateCount = 0;
        _babyMsgData = [[NSMutableArray alloc]init];
        _allGrowthsData = [[NSMutableArray alloc]init];
    }
    return self;
}
#pragma mark -
#pragma mark - add baby msg .be delegate by babyHomeDataDelegate
/**add more msg about baby*/
- (void) addGrowthsDataWithURL:(NSURL*)url
{
    if (_urlDelegate != nil && [_urlDelegate respondsToSelector:@selector(addGrowthsDataWithURL:)]) {
        [_urlDelegate addGrowthsDataWithURL:url];
    }
}

- (void) addGrowthsDataWithDict:(NSDictionary*) dataDict
{
    if (_urlDelegate != nil && [_urlDelegate respondsToSelector:@selector(addGrowthsDataWithDict:)]) {
        [_urlDelegate addGrowthsDataWithDict:dataDict];
    }
}

- (void) addGrowthsDataWithDictArray:(NSArray*) arrayDict
{
    if (_urlDelegate != nil && [_urlDelegate respondsToSelector:@selector(addGrowthsDataWithDictArray:)]) {
        [_urlDelegate addGrowthsDataWithDictArray:arrayDict];
    }
}
- (void) addGrowthsDataWithNumber:(NSInteger) num
{
    if (_urlDelegate != nil && [_urlDelegate respondsToSelector:@selector(addGrowthsDataWithNumber:)]) {
        [_urlDelegate addGrowthsDataWithNumber:num];
    }
}
- (void) addGrowthsDataWithStartAndLength:(NSUInteger)start withLength:(NSUInteger)length
{
    if (_urlDelegate != nil && [_urlDelegate respondsToSelector:@selector(addGrowthsDataWithStartAndLength:)]) {
        [_urlDelegate addGrowthsDataWithStartAndLength:start withLength:length];
    }
}
- (void) resetGrowthsData
{
    [_allGrowthsData removeAllObjects];
    [_babyMsgData removeAllObjects];
    _oldUpdateCount = 0;
}
- (void) updateGrowthsData
{
    
}
- (NSInteger) dataCount
{
    return _allGrowthsData.count;
}
- (NSInteger) dataHeightForCell: (NSIndexPath*) indexPath
{
    //第i个的json
    NSDictionary* dict = [_allGrowthsData objectAtIndex:indexPath.row];
    
    //算contentlabel高度
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    CGSize size = CGSizeMake(320,2000);
    NSString *contentStr = [dict valueForKey:@"growth_content"];
    CGSize labelsize = [contentStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    NSInteger totalHeight = HeadViewHeight + labelsize.height;
    return totalHeight;
}
- (NSInteger) countForContentImage:(NSIndexPath*) indexPath
{
    NSDictionary* dict = [_allGrowthsData objectAtIndex:indexPath.row];
    NSArray *imageArray = [dict valueForKey:@"growth_photos"];
    return imageArray.count;
}
@end

//
//  BabyMsgData.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-12.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "BabyMsgData.h"


@implementation BabyMsgData
- (BabyMsgData*) initWithAllMsg:(NSString*) name withHeadImage:(UIImage*) headImage
               withTime:(NSUInteger) time
            withContent:(NSString*)content
         withImageArray:(NSArray*)imageArray
{
    self = [super init];
    if (self) {
        _name = name;
        _headImage = headImage;
        _timeInterval = time;
        _content = content;
        _imageArray = [NSArray arrayWithArray:imageArray];
    }
    return self;
}
- (NSInteger) heightForMsgImage
{
    NSInteger height = 0;
    for (int i = 0; i < _imageArray.count; ++i) {
        height += ((UIImage*)[_imageArray objectAtIndex:i]).size.height;
    }
    return height;
}
- (NSInteger) countForContentImage
{
    return _imageArray.count;
}

- (NSString *)description
{
    if (_headImage) {
        NSLog(@"he has headImage");
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSString *dateStr = [formatter stringFromDate:date];
    NSLog(@"username: %@ \n time: %@ ",_name,dateStr);
    NSLog(@"content: %@",_content);
    NSLog(@"image num:%d",_imageArray.count);
    return [super description];
}
@end

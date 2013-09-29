//
//  WaterFallTableViewCell.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-10.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WaterFallCellDelegate <NSObject>

@optional
- (void) didTapedWaterFallCellImage:(NSString*)url;

@end

@interface WaterFallTableViewCell : UITableViewCell

@property (nonatomic, retain) id<WaterFallCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *headImageView;
//@property (nonatomic, retain) UIImageView *contentImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) NSMutableArray *imageURLArray;

//为了识别是一个cell中的哪张图片被点击
@property (nonatomic, retain) NSMutableArray *imageViewArray;
@property (nonatomic, retain) NSMutableArray *gestureArray;
- (NSInteger) height;
- (void) refreshCellFrame;
- (void) configCellImageShow:(NSArray *)imageArray;
@end

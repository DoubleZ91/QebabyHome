//
//  WaterFallTableViewCell.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-10.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterFallTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIImageView *contentImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *timeLabel;
- (NSInteger) height;
- (void) refreshCellFrame;
@end

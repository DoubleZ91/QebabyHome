//
//  WaterFallTableViewCell.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-10.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "WaterFallTableViewCell.h"

@implementation WaterFallTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //x轴偏移
        float xOffset = 0;
        //y轴偏移
        float yOffset = 0;
        //headimage image
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, yOffset, 40, 40)];
        [self.contentView addSubview:_headImageView];
        xOffset += _headImageView.frame.size.width;
        //yOffset = _headImageView.frame.size.height;
        //name label
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset + 15, yOffset + 10, 150, 20)];
        [self.contentView addSubview:_nameLabel];
        xOffset += _nameLabel.frame.size.width;
        //time label
        UIFont *font = [UIFont fontWithName:@"Arial" size:10];
        _timeLabel.font = font;
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset - 50, yOffset + 20, 200, 20)];
        [self.contentView addSubview:_timeLabel];
              
        xOffset = 0;
        yOffset += _headImageView.frame.size.height;
        NSLog(@" y offset : %f",yOffset);
        //content label
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, 0, 0)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        //[_contentLabel setAutoresizesSubviews:YES];
        [self.contentView addSubview:_contentLabel];
        //content image
        
        //.....
        yOffset += _headImageView.frame.size.height;
        NSLog(@" y offset : %f",yOffset);
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, yOffset, 380, 400)];
        [self.contentView addSubview:_contentImageView];
        
        yOffset += _contentImageView.frame.size.height;
        NSLog(@" y offset : %f",yOffset);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger) height
{
    NSInteger length = _headImageView.frame.size.height + _contentLabel.frame.size.height + _contentImageView.frame.size.height;
    return length;
}

- (void) refreshCellFrame
{
    CGRect rect = self.frame;
    rect.size.height = [self height];
    [self setFrame:rect];
}
@end

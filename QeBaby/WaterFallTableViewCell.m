//
//  WaterFallTableViewCell.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-10.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "WaterFallTableViewCell.h"
#import "BabyDefine.h"
@implementation WaterFallTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _imageURLArray = [[NSMutableArray alloc]init];
        _imageViewArray = [[NSMutableArray alloc]init];
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
//        NSLog(@" y offset : %f",yOffset);
//        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, yOffset, 380, 400)];
//        [self.contentView addSubview:_contentImageView];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//        [_contentImageView addGestureRecognizer:tap];
//        [_contentImageView setUserInteractionEnabled:YES];
//        
//        yOffset += _contentImageView.frame.size.height;
        NSLog(@" y offset : %f",yOffset);
    }
    return self;
}
- (void) configCellImageShow:(NSArray *)imageArray
{
    NSInteger yOffset = HeadViewHeight+ Height(_contentLabel);
    for (int i = 0; i < imageArray.count; ++i) {
        UIImage *imageContent = [imageArray objectAtIndex:i];
        CGSize imageViewSize = [self scaleRect:imageContent.size];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, yOffset, imageViewSize.width, imageViewSize.height)];
        imageView.image = imageContent;
        yOffset += imageViewSize.height + 5;
        [self addSubview:imageView];
        [_imageViewArray addObject:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageView addGestureRecognizer:tap];
        [imageView setUserInteractionEnabled:YES];
        [_gestureArray addObject:tap];
    }
}
- (CGSize) scaleRect:(CGSize)srcSize
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSInteger imageMaxWidth = screenSize.size.width;
    
    if (srcSize.width < imageMaxWidth){
        return srcSize;
    }
    
    float scale = imageMaxWidth / srcSize.width;
    CGSize imageViewSize = CGSizeMake(imageMaxWidth, srcSize.height * scale);
    
    return imageViewSize;
}
#pragma mark -
#pragma mark - image tap handle
- (void) handleSingleTap:(UIGestureRecognizer*) gestureRecognizer
{
    int i = 0;
    for (; i < _gestureArray.count; ++i) {
        if (gestureRecognizer == [_gestureArray objectAtIndex:i]) {
            break;
        }
    }
    NSString *url = [_imageURLArray objectAtIndex:i];
    if ([_delegate respondsToSelector:@selector(didTapedWaterFallCellImage:)]) {
        [_delegate didTapedWaterFallCellImage:url];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger) height
{
    NSInteger length = _headImageView.frame.size.height + _contentLabel.frame.size.height;// + _contentImageView.frame.size.height;
    return length;
}

- (void) refreshCellFrame
{
    CGRect rect = self.frame;
    rect.size.height = [self height];
    [self setFrame:rect];
}
@end

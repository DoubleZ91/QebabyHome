//
//  BabyImageViewController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-27.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWImagePreviewView.h"

//---------------------------------
//---全屏显示静态图片， gif图片，拖放放大缩小，保存图片到本地(gif会保存成静态
//---------------------------------
@interface BabyImageViewController : UIViewController <XWImagePreviewViewDelegate>
{
    XWImagePreviewView *_previewView;
    NSString *_babyImageURL;
}

- (void) setBabyImageURL:(NSString *)url;
@end

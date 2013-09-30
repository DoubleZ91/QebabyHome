//
//  IssueNewMsg.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-23.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IssueNewMsgProtocol;
@protocol BabyNetworkMgrDelegate;
@interface IssueNewMsg : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BabyNetworkMgrDelegate>

@property (nonatomic,weak) id<IssueNewMsgProtocol> delegate;

@property (nonatomic,weak) IBOutlet UITextView *contentTF;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UIToolbar *bottomToolbar;

/** 上传图片相关*/
@property (nonatomic,retain) NSMutableArray *imageViewArray;
@property (nonatomic,retain) NSMutableArray *imageArray;
- (IBAction) addImageBtnPress:(id)sender;
- (IBAction) sendBtnPress:(id)sender;
- (IBAction) cancelBtnPress:(id)sender;
@end


@protocol IssueNewMsgProtocol <NSObject>

- (void) dismissThePresented;

@end

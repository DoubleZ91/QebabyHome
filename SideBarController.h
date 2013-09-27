//
//  SideBarController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-26.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideDelegate.h"
@interface SideBarController : UIViewController<LeftSideDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *leftSideView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@end

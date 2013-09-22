//
//  ViewController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-10.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFallViewController;
@class LoginViewController;
@interface ViewController : UIViewController

@property (strong, nonatomic) WaterFallViewController *waterFallVC;
@property (strong, nonatomic) LoginViewController *loginVC;
@end

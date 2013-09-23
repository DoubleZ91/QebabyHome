//
//  LoginViewController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-11.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyRegisterViewController.h"
@interface LoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *userNameTF;
@property (nonatomic, weak) IBOutlet UITextField *passwordTF;
@property (nonatomic, retain) BabyRegisterViewController *registerVC;
- (IBAction) loginBtnPress: (id) sender;
- (IBAction) registerBtnPress:(id) sender;
@end

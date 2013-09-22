//
//  LoginViewController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-11.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *userNameTF;
@property (nonatomic, weak) IBOutlet UITextField *passwordTF;

- (IBAction) loginBtnPress: (id) sender;
@end

//
//  BabyRegisterViewController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-22.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyRegisterViewController : UIViewController

@property (nonatomic, assign) bool isCanRegister;
@property (nonatomic, assign) bool isRightCheck;
@property (nonatomic, weak) IBOutlet UIButton *signUpBtn;               //注册按钮
@property (nonatomic, weak) IBOutlet UIButton *readRightCheck;          //模拟是否同意使用协议的checkbox
@property (nonatomic, weak) IBOutlet UITextField *emailTF;
@property (nonatomic, weak) IBOutlet UITextField *passwordTF;
@property (nonatomic, weak) IBOutlet UITextField *confirmTF;
@property (nonatomic, weak) IBOutlet UITextField *babynameTF;

- (IBAction) signUpBtnPress:(id)sender;
- (IBAction) rightCheckBtnPress:(id)sender;
- (IBAction) resignFirstPress:(id)sender;

- (IBAction) textEditEnd:(id)sender;
@end

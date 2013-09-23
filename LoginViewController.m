//
//  LoginViewController.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-11.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "BabyDefine.h"
#import "BabyNetwork.h"
#import "BabyNetworkManager.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) loginBtnPress:(id)sender
{
    [BabyNetworkManager initNetworkWorkplace];
    [BabyNetworkManager loginWithEmailAndPwd:_userNameTF.text withPassword:_passwordTF.text autologin:false];
}

- (IBAction) registerBtnPress:(id) sender
{
    if (!_registerVC) {
        _registerVC = [[BabyRegisterViewController alloc] init];
    }
    [self.navigationController pushViewController:_registerVC animated:YES];
}
- (IBAction) didEditOnEnd:(id)sender
{
    [_userNameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}
@end






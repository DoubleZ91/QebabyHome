//
//  BabyRegisterViewController.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-22.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "BabyRegisterViewController.h"
#import "BabyNetworkManager.h"
typedef enum  {
    RAEmailEmpty = 0,
    RAEmailExisted,
    RAEmailFormatError,
    RAPasswordTooSmall = 5,
    RAPasswordEmpty,
    RAConfirmError = 10,
    RABabyNameError,
    RARightCheck = 12
}RegisterAlertState;

@interface BabyRegisterViewController ()

@end

@implementation BabyRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isRightCheck = false;
        _isCanRegister = 0x0F;
    
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
#endif
    
    //_readRightCheck.adjustsImageWhenHighlighted = YES;
    //_readRightCheck.adjustsImageWhenDisabled = YES;
    [_readRightCheck setBackgroundImage:[UIImage imageNamed:@"Austria.png" ] forState:UIControlStateSelected];
    [_readRightCheck setBackgroundImage:[UIImage imageNamed:@"Brazil.png" ] forState:UIControlStateHighlighted];
    [_readRightCheck setBackgroundImage:[UIImage imageNamed:@"Brazil.png" ] forState:UIControlStateNormal];
    
    [_readRightCheck setTitle:@"YES" forState:UIControlStateSelected];
    [_readRightCheck setTitle:@"NO" forState:UIControlStateNormal];
    _readRightCheck.adjustsImageWhenHighlighted = YES;
    _readRightCheck.selected = _isRightCheck;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpBtnPress:(id)sender
{
    if (_isRightCheck && _isCanRegister==0) {
        if ([BabyNetworkManager registerWithInfo:_emailTF.text withPassword:_passwordTF.text withBabyName:_babynameTF.text]) {
            //注册成功，将邮箱标记位致为有误
            _isCanRegister |= 0x01;
            [BabyNetworkManager loginWithEmailAndPwd:_emailTF.text withPassword:_passwordTF.text autologin:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    if (!_isRightCheck) {
        NSLog(@"please read the user.txt ,and accept it.-just check the box");
    }
    if (_isCanRegister != 0) {
        NSLog(@"you register msg is wrong.");
    }
    return;
}

- (IBAction)rightCheckBtnPress:(id)sender
{
    _isRightCheck = !_isRightCheck;
    [_readRightCheck setSelected:_isRightCheck];
    
    NSLog(@"rightCheckBtn turn : %d",_isRightCheck);
}

- (IBAction) resignFirstPress:(id)sender
{
    [_emailTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    [_confirmTF resignFirstResponder];
    [_babynameTF resignFirstResponder];
    
}

- (IBAction) textEditEnd:(id)sender
{
    if (sender == _emailTF) {
        _isCanRegister |= 0x01;
        //判断是否email是否有效
        if (_emailTF.text == nil) {
            [self alertViewShow:RAEmailEmpty];
            return;
        }
        if ([_emailTF.text rangeOfString:@"@"].length <= 0 || (![_emailTF.text hasSuffix:@".com"])) {
            [self alertViewShow:RAEmailFormatError];
            return;
        }
        if([BabyNetworkManager checkRegisterEmail:_emailTF.text])//check is existed
        {
            [self alertViewShow:RAEmailExisted];
            return;
        }
        _isCanRegister &= 0xFD;
    }
    else if(sender == _passwordTF){
        _isCanRegister |= 0x02;
        if (_passwordTF.text == nil) {
            [self alertViewShow:RAPasswordEmpty];
            return;
        }
        if (_passwordTF.text.length < 8) {
            [self alertViewShow:RAPasswordTooSmall];
            return;
        }
        _isCanRegister &= 0xFC;
    }
    else if (sender == _confirmTF){
        _isCanRegister |= 0x04;
        if (![_confirmTF.text isEqualToString:_passwordTF.text]) {
            [self alertViewShow:RAConfirmError];
            return;
        }
        _isCanRegister &= 0xFA;
    }
    else if (sender == _babynameTF){
        _isCanRegister |= 0x08;
        if (_babynameTF.text.length < 1) {
            [self alertViewShow:RABabyNameError];
            return;
        }
        _isCanRegister &= 0xF7;
    }
}

- (void) alertViewShow:(RegisterAlertState) raState
{
    switch (raState) {
        case RAEmailEmpty:
            NSLog(@"RAEmailEmpty");
            break;
        case RAEmailExisted:
            NSLog(@"RAEmailExisted");
            break;
            
        case RAPasswordEmpty:
            NSLog(@"RAPasswordEmpty");
            break;
        
        case RAPasswordTooSmall:
            NSLog(@"RAPasswordTooSmall");
            break;
            
        case RAConfirmError:
            NSLog(@"RAConfirmError");
            break;
            
        case RARightCheck:
            NSLog(@"RARightCheck");
            break;
            
        default:
            break;
    }
}
@end

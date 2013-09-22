//
//  ViewController.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-10.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "ViewController.h"
#import "WaterFallViewController.h"
#import "LoginViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshBtn.frame = CGRectMake(10, 120, 300, 40);
    [refreshBtn setTitle:@"Pull-to-Login" forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    UIButton *refreshBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshBtn2.frame = CGRectMake(10, 200, 300, 40);
    [refreshBtn2 setTitle:@"Pull-to-Home" forState:UIControlStateNormal];
    [refreshBtn2 addTarget:self action:@selector(refreshClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refreshClick:(id)sender
{
    //waterfall
//    if (!_waterFallVC) {
//        _waterFallVC = [[WaterFallViewController alloc] init];
//    }
//    [self.navigationController pushViewController:_waterFallVC animated:YES];
    
    //login
    if (!_loginVC){
        _loginVC = [[LoginViewController alloc] initWithNibName:@"Login" bundle:nil];
    }
    [self.navigationController pushViewController:_loginVC animated:YES];
}

-(void)refreshClick2:(id)sender
{
    //waterfall
        if (!_waterFallVC) {
            _waterFallVC = [[WaterFallViewController alloc] init];
        }
        [self.navigationController pushViewController:_waterFallVC animated:YES];
    
    //login
//    if (!_loginVC){
//        _loginVC = [[LoginViewController alloc] initWithNibName:@"Login" bundle:nil];
//    }
//    [self.navigationController pushViewController:_loginVC animated:YES];
}

@end

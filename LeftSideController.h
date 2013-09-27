//
//  LeftSideController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-26.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideDelegate.h"
#import "WaterFallViewcontroller.h"
#import "ViewController.h"
@interface LeftSideController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) id<LeftSideDelegate> delegate;

@property (nonatomic, retain)  WaterFallViewController *waterfallController;
@property (nonatomic, retain)  UINavigationController *waterfallNavController;

@property (nonatomic, retain) ViewController*   viewController;
@property (nonatomic, retain) UINavigationController *viewNavController;

@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
@end

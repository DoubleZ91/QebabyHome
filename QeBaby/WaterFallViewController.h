//
//  WaterFallViewController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-10.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QebabyHomeData;
@class CellDetailController;
@class BabyHomeDataManager;
@interface WaterFallViewController : UITableViewController

//@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain)CellDetailController *cellDetailController;

@property (nonatomic, assign)NSInteger tableViewCellSum;
@property (nonatomic, assign)NSInteger bottomCellIndex;
@property (nonatomic, retain)QebabyHomeData *babyHomeData;
@property (nonatomic, retain)BabyHomeDataManager *babyHomeDataMgr;
- (void) refreshView:(UIRefreshControl*)refreshControl;

@end

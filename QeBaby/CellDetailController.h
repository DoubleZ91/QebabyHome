//
//  CellDetailController.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-12.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

@interface CellDetailController : UIViewController
{
    dispatch_source_t readTimerSrc;
}

- (void) reloadDetailData:(NSIndexPath*) indexPath;
@end

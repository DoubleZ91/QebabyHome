//
//  CellDetailController.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-12.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "CellDetailController.h"

@interface CellDetailController ()

@end

@implementation CellDetailController

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
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadDetailData:(NSIndexPath *)indexPath
{
    //延时线程
    dispatch_queue_t readDataQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    readTimerSrc = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, readDataQueue);
    dispatch_source_set_event_handler(readTimerSrc, ^{NSLog(@"60s later ,TimesrcHandle");});
    
    //dispatch_source_t testReadTimeSrc = readTimerSrc;
    dispatch_source_set_cancel_handler(readTimerSrc, ^{
        NSLog(@"release readtimesrc.");
        //dispatch_release(readTimerSrc);
    });
    
    dispatch_time_t tt = dispatch_time(DISPATCH_TIME_NOW, (1 * NSEC_PER_SEC));
    dispatch_source_set_timer(readTimerSrc, tt, DISPATCH_TIME_FOREVER, 0);
    dispatch_resume(readTimerSrc);
    //dispatch_source_cancel(readTimerSrc);
    
}
@end

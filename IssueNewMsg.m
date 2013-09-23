//
//  IssueNewMsg.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-23.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "IssueNewMsg.h"

@interface IssueNewMsg ()

@end

@implementation IssueNewMsg

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
#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
#endif

    //UIBarButtonItem *btnSend = [[UIBarButtonItem alloc]initWithTitle:@"send" style:UIBarButtonItemStyleBordered target:self action:@selector(sendBtnPress:)];
    //self.navigationItem.rightBarButtonItem = btnSend;
}

/*send button has been clicked*/
- (IBAction) sendBtnPress:(id)sender
{
    if ([_delegate respondsToSelector:@selector(dismissThePresented)]) {
        [_delegate dismissThePresented];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end

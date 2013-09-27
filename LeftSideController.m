//
//  LeftSideController.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-26.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "LeftSideController.h"

@interface LeftSideController ()
@property (nonatomic, retain) NSIndexPath *selectIndexPath;

@end

@implementation LeftSideController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#ifdef __IPHONE_7_0
        if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
#endif
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    if ([_delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        self.selectIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        //选择某cell
        [_menuTableView selectRowAtIndexPath:_selectIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        //显示选择的cell的视图
        [_delegate leftSideBarSelectWithController:[self subConWithIndex:_selectIndexPath]];
    }
}
/**controller with index*/
- (UIViewController*) subConWithIndex:(NSIndexPath*)indexPath
{
    UIViewController *vc = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //_strollVC && _strollVC.isLoaded??????
                if (_waterfallController) {
                    return _waterfallNavController;
                }
                else {
                    _waterfallController = [[WaterFallViewController alloc]init];
                    _waterfallNavController = [self configNavigationControllerWithRootVC:_waterfallController];
                    return _waterfallNavController;
                }
            }
                break;
            case 1:
            {
                if (_viewController) {
                    return _viewNavController;
                }
                else {
                    _viewController = [[ViewController alloc] init];
                    _viewNavController = [self configNavigationControllerWithRootVC:_viewController];
                    return _viewNavController;
                }
                break;
            }
            default:
                break;
        }
    }
    return vc;
}

- (UINavigationController *)configNavigationControllerWithRootVC:(UIViewController*)vc
{
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"Cameroon.png" ]forBarMetrics:UIBarMetricsDefault];
    return nav;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - tableview data 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"LeftSideViewCell";
    UITableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!menuCell) {
        menuCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSString *menuTitle = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    menuTitle = @"Baby Home     >>>>";
                    break;
                case 1:
                    menuTitle = @"All View Controll >>>>>";
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    [self configCellAttribute:menuCell];
    menuCell.textLabel.text = menuTitle;
    
    return menuCell;
}
- (void) configCellAttribute:(UITableViewCell*) cell
{
    //config cell .such as :image background
}
#pragma mark -
#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        if ([indexPath isEqual:_selectIndexPath]) {
            [_delegate leftSideBarSelectWithController:nil];
        }
        else {
            [_delegate leftSideBarSelectWithController:[self subConWithIndex:indexPath]];
        }
    }
    self.selectIndexPath = indexPath;
}
@end

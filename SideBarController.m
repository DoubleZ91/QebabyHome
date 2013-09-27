//
//  SideBarController.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-26.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "SideBarController.h"
#import "LeftSideController.h"
@interface SideBarController ()
{
    UIViewController *_currentMainController;
    UIPanGestureRecognizer * _panGestureRecognizer;
    UITapGestureRecognizer * _tapGestureRecognizer;
    CGFloat currentTranslation;
}
@property (retain,nonatomic) LeftSideController *leftSideController;

@end

@implementation SideBarController

static bool _sideBarShowing;
const int ContentOffset = 480;
const int ContentMinOffset = 60;
const float MoveAnimationDuration = 0.5;

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
    _sideBarShowing = NO;
    currentTranslation = 0;
    
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 1;
    
    LeftSideController *_leftVC = [[LeftSideController alloc]init];
    _leftVC.delegate = self;
    self.leftSideController = _leftVC;
    
    [self addChildViewController:self.leftSideController];
    self.leftSideController.view.frame = self.leftSideView.bounds;
    [self.leftSideView addSubview:self.leftSideController.view];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panInContentView:)];
    // ?为什么要成为代理? 控制在最左边多少的地方滑动才能出现侧边栏
    _panGestureRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:_panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - gesture delegate
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGFloat location = [gestureRecognizer locationInView:self.contentView].x;
    if (location < 70) {
        return YES;
    }
    return NO;
}
/** pan 向右拖动界面*/
- (void) panInContentView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat translation = [panGestureRecognizer translationInView:self.contentView].x;
        UIView *view = nil;
        
        if(translation + currentTranslation > 0){
            self.contentView.transform = CGAffineTransformMakeTranslation(translation + currentTranslation, 0);
            view = self.leftSideController.view;
        }
        //for what ????
        //[self.leftSideView bringSubviewToFront:view];
    }
    else if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        currentTranslation = self.contentView.transform.tx;
        if(!_sideBarShowing){
            if(fabs(currentTranslation) < ContentMinOffset){
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }
            else
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
        }
        else{
            if (fabs(currentTranslation) < ContentOffset - ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }else if(fabs(currentTranslation) > ContentOffset - ContentOffset){
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }
        }
    }
}

/** 滑动中的动画*/
- (void) moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
        switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform = CGAffineTransformMakeTranslation(0,0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform = CGAffineTransformMakeTranslation(ContentOffset, 0);
            }
                break;
            default:
                break;
        }
    };
    void (^complete)(BOOL) = ^(BOOL finished){
        self.contentView.userInteractionEnabled = YES;
        self.leftSideView.userInteractionEnabled = YES;
        
        if(direction == SideBarShowDirectionNone){
            if(_tapGestureRecognizer){
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            _sideBarShowing = NO;
        }
        else {
            [self contentViewAddTapGestures];
            _sideBarShowing = YES;
        }
        currentTranslation = self.contentView.transform.tx;
    };
    self.contentView.userInteractionEnabled = NO;
    self.leftSideView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

//添加tap手势，判断生效范围
- (void) contentViewAddTapGestures
{
    if(_tapGestureRecognizer){
        [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}
- (void) tapOnContentView:(UITapGestureRecognizer*)tapGestureRecongnizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}




#pragma mark -
#pragma mark - sidebar delegate
- (void) leftSideBarSelectWithController:(UIViewController*) controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
        controller.view.frame = self.contentView.bounds;
        _currentMainController = controller;
        [self addChildViewController:_currentMainController];
        [self.contentView addSubview:_currentMainController.view];
    }
    else if(_currentMainController !=controller &&controller!=nil){
        controller.view.frame = self.contentView.bounds;
        [_currentMainController willMoveToParentViewController:nil];
        [self addChildViewController:controller];
        self.view.userInteractionEnabled = NO;
        [self transitionFromViewController:_currentMainController
                          toViewController:controller
                                  duration:0
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{}
                                completion:^(BOOL finish){
                                    self.view.userInteractionEnabled = YES;
                                    [_currentMainController removeFromParentViewController];
                                    [controller didMoveToParentViewController:self];
                                    _currentMainController = controller;
                                }
         ];
    }
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}

- (void) showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    if (direction != SideBarShowDirectionNone) {
        UIView *view = nil;
        if (direction == SideBarShowDirectionLeft) {
            view = self.leftSideController.view;
        }
        //for what?   有移除controller但是没有移除view
        [self.leftSideView bringSubviewToFront:view];
    }
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}
@end

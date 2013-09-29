//
//  BabyImageViewController.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-27.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "BabyImageViewController.h"

@interface BabyImageViewController ()

@end

@implementation BabyImageViewController

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
    [self initPreviewImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initPreviewImage
{
    _previewView = [[XWImagePreviewView alloc]initWithFrame:CGRectZero];
    _previewView.delegate = self;
    [self.view addSubview:_previewView];
    [_previewView initImageWithURL:_babyImageURL];
}

- (void) setBabyImageURL:(NSString*)url
{
    _babyImageURL = @"";
    _babyImageURL = url;
}
#pragma mark - Rotate
- (BOOL) shouldAutorotate
{
    return YES;
}
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait
         || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        _previewView.previewWidth = kDeviceWidth;
        _previewView.previewHeight = KDeviceHeight;
    }
    else {
        _previewView.previewWidth = KDeviceHeight;
        _previewView.previewHeight = kDeviceWidth;
    }
    
    [_previewView resetLayoutByPreviewImageView];
}
#pragma mark -
#pragma mark - XWImagePreviewView delegate
- (void) didTapPreviewView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

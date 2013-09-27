//
//  IssueNewMsg.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-23.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "IssueNewMsg.h"
#import "BabyNetworkManager.h"
#import "BabyDefine.h"
@interface IssueNewMsg ()
{
   
}
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
    _contentTF.scrollEnabled = YES;
    _contentTF.autoresizingMask &= UIViewAutoresizingNone;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc ]initWithTarget:self action:@selector(swipeTextView:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGesture];
    [self.view setUserInteractionEnabled:YES];
    
    //_contentTF.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //UIBarButtonItem *btnSend = [[UIBarButtonItem alloc]initWithTitle:@"send" style:UIBarButtonItemStyleBordered target:self action:@selector(sendBtnPress:)];
    //self.navigationItem.rightBarButtonItem = btnSend;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_contentTF addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
     //
}

- (void) swipeTextView:(UIGestureRecognizer *) gestureRecognizer
{
    [_contentTF resignFirstResponder];
}

- (void) viewDidLayoutSubviews
{
    float contentWidth = MainScreenWidth - 40;
    float contentHeight = MainScreenHeight - 2 * Height(_bottomToolbar) - 40;
    _contentTF.frame = CGRectMake(20 ,Height(_bottomToolbar) + Height(_timeLabel) + 5 , contentWidth, contentHeight);
    
    [_contentTF setText:@"请在此处输入您所要发表的文字 ......."];
    [_contentTF setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [_contentTF setTextColor:[UIColor lightGrayColor]];
    //[_contentTF becomeFirstResponder];
    
    NSDate *now = [NSDate date];
    NSDateFormatter  * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    NSString *dateStr =  [formatter stringFromDate:now];
    _timeLabel.text = dateStr;
    NSLog(@"%@",_contentTF);
}

#pragma mark -
#pragma mark - keyboard
- (void) keyboardWillShow:(NSNotification*)notification
{
    
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float textviewOffset = keyboardFrame.size.height;
    
    _contentTF.frame = CGRectMake(X(_contentTF), Y(_contentTF),Width(_contentTF), Height(_contentTF) - textviewOffset);
    _bottomToolbar.frame = CGRectMake(X(_bottomToolbar), Y(_bottomToolbar) - textviewOffset,Width(_bottomToolbar), Height(_bottomToolbar));
    BabyLog(@"%@",_bottomToolbar);
}

- (void) keyboardWillHide:(NSNotification*)notification
{
    
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float textviewOffset = keyboardFrame.size.height;
    
    _contentTF.frame = CGRectMake(X(_contentTF), Y(_contentTF),Width(_contentTF), Height(_contentTF) + textviewOffset);
    _bottomToolbar.frame = CGRectMake(X(_bottomToolbar), Y(_bottomToolbar) + textviewOffset,Width(_bottomToolbar), Height(_bottomToolbar));
    NSLog(@"%@",_bottomToolbar);
}



/*send button has been clicked*/
- (IBAction) sendBtnPress:(id)sender
{
    [_contentTF resignFirstResponder];
    if (_contentTF.textColor == [UIColor lightGrayColor]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"error" message:@"please input something." delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (_contentTF.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"error" message:@"the content can not be empty." delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if(![BabyNetworkManager createGrowthWithContent:_contentTF.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"error" message:@"send error.may be you need to login." delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ([_delegate respondsToSelector:@selector(dismissThePresented)]) {
        [_delegate dismissThePresented];
    }
}

- (IBAction) cancelBtnPress:(id)sender
{
    [_contentTF resignFirstResponder];
    
    if ([_delegate respondsToSelector:@selector(dismissThePresented)]) {
        [_delegate dismissThePresented];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma  mark -
#pragma  mark - textview delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (_contentTF.textColor == [UIColor lightGrayColor]) {
        _contentTF.text = @"";
        _contentTF.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(_contentTF.text.length == 0){
        _contentTF.textColor = [UIColor lightGrayColor];
        _contentTF.text = @"List words or terms separated by commas";
        [_contentTF resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(_contentTF.text.length == 0){
            _contentTF.textColor = [UIColor lightGrayColor];
            _contentTF.text = @"List words or terms separated by commas";
            [_contentTF resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}
@end

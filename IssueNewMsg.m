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
#define SmallImageWidth 57
#define SmallImageHeight 57
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
        _imageArray = [[NSMutableArray alloc]init];
        _imageViewArray = [[NSMutableArray alloc]init];
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
    for (int i = 0; i < _imageViewArray.count; ++i) {
        UIImageView * imageView = [_imageViewArray objectAtIndex:i];
        imageView.frame = CGRectMake(X(imageView), Y(imageView) - textviewOffset, Width(imageView), Height(imageView));
    }
    BabyLog(@"%@",_bottomToolbar);
}

- (void) keyboardWillHide:(NSNotification*)notification
{

    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float textviewOffset = keyboardFrame.size.height;
    
    _contentTF.frame = CGRectMake(X(_contentTF), Y(_contentTF),Width(_contentTF), Height(_contentTF) + textviewOffset);
    _bottomToolbar.frame = CGRectMake(X(_bottomToolbar), Y(_bottomToolbar) + textviewOffset,Width(_bottomToolbar), Height(_bottomToolbar));
    for (int i = 0; i < _imageViewArray.count; ++i) {
        UIImageView * imageView = [_imageViewArray objectAtIndex:i];
        imageView.frame = CGRectMake(X(imageView), Y(imageView) + textviewOffset, Width(imageView), Height(imageView));
    }
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
    [_imageViewArray removeAllObjects];
    if ([_delegate respondsToSelector:@selector(dismissThePresented)]) {
        [_delegate dismissThePresented];
    }
}
- (IBAction) addImageBtnPress:(id)sender
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片"
                                           delegate:self
                                  cancelButtonTitle:nil
                             destructiveButtonTitle:@"取消"
                                  otherButtonTitles:@"拍照",@"相册", nil];
    }
    else{
        sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片"
                                           delegate:self
                                  cancelButtonTitle:nil
                             destructiveButtonTitle:@"取消"
                                  otherButtonTitles:@"相册", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
}

#pragma mark -
#pragma mark - UIActionSheetDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        //判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //取消
                    return;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            }
            else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        //跳转到相机或者是相册
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}
#pragma mark -
#pragma mark - ImagePicker Delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    if (_imageViewArray.count > 3) {
        return;//最多3张
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *saveImage = [[UIImage alloc]initWithContentsOfFile:fullPath];
#warning keyboard出现的 时候，添加图片bug
    //添加ImageView
    //CGRect rect = CGRectMake(_imageViewArray.count *(SmallImageWidth + 2), Y(_bottomToolbar) - (Height(_bottomToolbar) + 2), SmallImageWidth, SmallImageHeight);
    CGRect rect = CGRectMake(_imageViewArray.count *(SmallImageWidth + 2), (Y(_bottomToolbar) - SmallImageHeight), SmallImageWidth, SmallImageHeight);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.image  = saveImage;
    [self.view addSubview:imageView];
    [_imageViewArray addObject: imageView];
    //设置到相应的imageView
//    isFullScreen = NO;
//    [self.imageView setImage:savedImage];
//    self.imageView.tag = 100;

}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void) saveImage: (UIImage*) currentImage withName:(NSString *)imageName
{
    //该函数用于高保真压缩图片
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    //获取沙盒目录
    NSString *fullPath =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    //写入文件
    [imageData writeToFile:fullPath atomically:NO];
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

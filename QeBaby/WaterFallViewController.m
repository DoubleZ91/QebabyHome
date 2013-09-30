//
//  WaterFallViewController.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-10.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "WaterFallViewController.h"
#import "WaterFallTableViewCell.h"
#import "QebabyHomeData.h"
#import "BabyDefine.h"
#import "CellDetailController.h"
#import "BabyHomeDataManager.h"
#import <dispatch/dispatch.h>
#import "IssueNewMsg.h"
#import "BabyImageViewController.h"

#define LoadMoreNum 20
@interface WaterFallViewController ()
{
    dispatch_queue_t loadQueue;
}
@end

@implementation WaterFallViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
#endif
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithTitle:@"new" style:UIBarButtonItemStyleBordered target:self action:@selector(newGrowth:)];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    //下拉更新控制器
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Baby come on!"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    self.tableView.showsVerticalScrollIndicator = NO;
    
    _babyHomeData = [QebabyHomeData shareQebabyHomeData];
    //数据处理统一由代理来
    _babyHomeData.urlDelegate = _babyHomeDataMgr = [[BabyHomeDataManager alloc]init];
    
    //初始化队列
    loadQueue = dispatch_queue_create("LoadMore.queue", NULL);
    [self initTableViewSource];
    
    //监听数据加载
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:BabyMsgHadRefreshed object:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - btn down
- (void) newGrowth:(id)sender
{
    if (_issueNewMsgController == nil) {
        _issueNewMsgController = [[IssueNewMsg alloc]init];
        _issueNewMsgController.delegate = self;
    }
    [self presentViewController:_issueNewMsgController animated:YES completion:nil];
}
#pragma mark - 
#pragma mark - RefreshViewControl
- (void) refreshView:(UIRefreshControl*)refreshControl
{
    if (refreshControl.refreshing) {
        refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"test refreshing"];
        
        [self manualRefreshData];
        
        [self performSelector:@selector(handleRefresh) withObject:nil afterDelay:2.0];
    }
}
- (void) handleRefresh
{
    [self.refreshControl endRefreshing];
}
- (void) manualRefreshData
{
    //为了控制没有加载完的block
    if ([_babyHomeDataMgr numOfBlocks]) {
        return;
    }
    [_babyHomeData resetGrowthsData];
    [self initTableViewSource];
}
- (void) initTableViewSource
{
    //初始tableview数据
    //NSURL *url = [NSURL URLWithString:BabyHomeDataUrlWithStartAndLength(0, 20)];
    //[_babyHomeData addGrowthsDataWithURL:url];
    //初始化标记最后一个cell
    _bottomCellIndex = -1;
    _tableViewCellSum = 0;
    [self loadMore];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _tableViewCellSum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WaterFallCell";
    NSLog(@"%d",indexPath.row);
    //判断是否为最后一个
    if (indexPath.row == _bottomCellIndex) {
        WaterFallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        if (!cell) {
            cell = [[WaterFallTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImage *testImage = [UIImage imageNamed: @"Brazil.png"];
        cell.headImageView.image = testImage;
        [cell refreshCellFrame];
        
        //加载更多cell
        [self loadMore];
        return cell;
    }
    

    WaterFallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (!cell) {
        cell = [[WaterFallTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    // Configure the cell...
    
    /**
     *1.图片需要缩放成为等屏幕宽
     *2.图片未加载的话采用某种颜色代替，如灰色
     *3.所有图片要显示的话，需要规定图片最大长度（因为json中没有给出图片大小的数据段）
     *4.文字换行？需要计算字符串长度，行大小。设定字体大小。
     *5.增加评论按钮？
     *6.点赞按钮.
     */
    
    
    
    NSDictionary *jsonDict = [_babyHomeData.allGrowthsData objectAtIndex:indexPath.row];
    cell.nameLabel.text = [jsonDict valueForKey:@"users_name"];
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    CGSize size = CGSizeMake(320,2000);
    NSString * contentStr = [jsonDict valueForKey:@"growth_content" ];
    CGSize labelsize = [contentStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    cell.contentLabel.frame = CGRectMake(0.0, HeadViewHeight, labelsize.width, labelsize.height );
    
    BabyLog(@"it is the contentStr:%@",contentStr);
    cell.contentLabel.font = font;
    cell.contentLabel.text = contentStr;
    
    //先显示文字
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(int)[jsonDict valueForKey:@"growth_timeline"]];
    NSString *dateStr = [formatter stringFromDate:date];
    cell.timeLabel.text = dateStr;
    cell.headImageView.image = nil;
    
    // 图片清理工作
    //手势清理
    [cell.gestureArray removeAllObjects];
    //cell.contentImageView.image = nil;
    [cell.imageURLArray removeAllObjects];
    for (int i = 0; i < cell.imageViewArray.count;++i) {
        [[cell.imageViewArray objectAtIndex:i]removeFromSuperview];
    }
    [cell.imageViewArray removeAllObjects];
    
    [cell.imageURLArray addObjectsFromArray:(NSArray *)[jsonDict valueForKey:@"growth_photos"]];
    //为了异步加载，可能需改成loadURL
    //加载图片
    if (_babyHomeData.babyMsgData.count <= indexPath.row) {
        return cell;
    }
    BabyMsgData *msg = [_babyHomeData.babyMsgData objectAtIndex:indexPath.row];

    cell.headImageView.image = msg.headImage;
    cell.nameLabel.text = msg.name;

//    if (msg.imageArray.count > 0) {
//        UIImage * imageContent = [msg.imageArray objectAtIndex:0];
//        CGSize imageViewSize = [self scaleRect: imageContent.size];
//        [cell.contentImageView setFrame:CGRectMake(0, HeadViewHeight+ Height(cell.contentLabel), imageViewSize.width, imageViewSize.height)];
//        cell.contentImageView.image = [msg.imageArray objectAtIndex:0];
//        //应该移到cell controller中。
////        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
////        singleTap.numberOfTapsRequired = 1;
////        singleTap.numberOfTouchesRequired = 1;
////        [cell.contentImageView addGestureRecognizer:singleTap];
////        [cell.contentImageView setUserInteractionEnabled:YES];
//    }
    [cell configCellImageShow:msg.imageArray];
    BabyLog(@"cell ready...........");
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger imageHeight = 0;
    if (_babyHomeData.babyMsgData.count <= indexPath.row) {
        imageHeight = [_babyHomeData countForContentImage:indexPath]*DefaultImageHeight;
    }
    else{
        BabyMsgData *msg = [_babyHomeData.babyMsgData objectAtIndex:indexPath.row];
        imageHeight = [msg heightForMsgImage];
    }
    return [_babyHomeData dataHeightForCell:indexPath] + imageHeight;
}
- (void)viewDidAppear:(BOOL)animated {
	
	//[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:NO];
}

- (void) refreshData
{
    BabyLog(@"refreshData.................");
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) loadMore
{
    BabyLog(@"Load More...");
    dispatch_async(loadQueue, ^(void){
        NSInteger dataCountBefore = [_babyHomeData dataCount];
        [_babyHomeData addGrowthsDataWithNumber:LoadMoreNum];
        NSInteger dataCountAfter = [_babyHomeData dataCount];
        if (dataCountAfter == dataCountBefore) {
            _tableViewCellSum = dataCountBefore;
            _bottomCellIndex = dataCountBefore - 1;
            return;     //不需要重新加载数据了。
        }
        else if(dataCountAfter > dataCountBefore){
            _tableViewCellSum = dataCountAfter;
            _bottomCellIndex = dataCountAfter - 1;
        }
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:true];
    });
}

//- (void) imageViewTaped:(UIGestureRecognizer *) gestureRecognizer
//{
//    BabyLog(@"single tap.............");
//}
- (void) didTapedWaterFallCellImage:(NSString *)url
{
    BabyLog(@"single tap image.............");
    BabyImageViewController *babyImageController = [[BabyImageViewController alloc]init];
    
    [babyImageController setBabyImageURL:url];
    babyImageController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentViewController:babyImageController animated:YES completion:nil];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    if(!_cellDetailController)
    {
        _cellDetailController = [[CellDetailController alloc]init];
    }
     // ...
     // Pass the selected object to the new view controller.
    UIBarButtonItem *returnBtnItem = [[UIBarButtonItem alloc] init];
    returnBtnItem.title = @"Home";
    self.navigationItem.backBarButtonItem = returnBtnItem;

    [_cellDetailController reloadDetailData:indexPath];
    [self.navigationController pushViewController:_cellDetailController animated:YES];
}

#pragma mark - issueMsgView protocol
- (void) dismissThePresented
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (CGSize) scaleRect:(CGSize)srcSize
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSInteger imageMaxWidth = screenSize.size.width;
    
    if (srcSize.width < imageMaxWidth){
        return srcSize;
    }
    
    float scale = imageMaxWidth / srcSize.width;
    CGSize imageViewSize = CGSizeMake(imageMaxWidth, srcSize.height * scale);
    
    return imageViewSize;
}
@end

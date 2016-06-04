//
//  FocusMyArtistTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistMainViewController.h"
#import "ArtworkFinishedController.h"

#import "ArtistMainCell.h"

#import "ArtistObjectModel.h"
#import "ArtworkListModel.h"
#import "BianJiJianJieModel.h"
#import "ProjectDetailsModel.H"
#import "ArtworkModel.h"

#import <MJExtension.h>
#import <SVProgressHUD.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

#import "ReleaseViewController.h"

#import "ReleaseVideoViewController.h"
#import "ReleasePicViewController.h"
#import "ComposeProjectViewController.h"

#import "DetailFinanceViewController.h"
#import "DetailCreationViewController.h"
#import "DetailCreationH5WebController.h"

@interface ArtistMainViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,ArtistMainCellDelegate>

@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageIndex;

//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------

@end

@implementation ArtistMainViewController

static NSString *ID = @"ArtistMainCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isfoot = YES;
    self.lastPageIndex = @"1";
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"ArtistMainCell" bundle:nil] forCellReuseIdentifier:ID];
    [ArtistObjectModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworkList" : @"ArtworkListModel",
                 };
    }];
    
    [ProjectDetailsModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworkAttachmentList" : @"ArtworkAttachmentListModel",
                 };
    }];
    
    [ArtworkListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"descriptions":@"description",
                 @"ID"          :@"id",
                 };
    }];
    
    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID" : @"id",
                 };
    }];
    
    [ArtworkModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descriptions":@"description",
                 @"ID":@"id"
                 };
    }];
    
    [self loadNewData];
    
    //设置刷新控件
    [self setUpRefresh];
    
    
    self.tableView.estimatedRowHeight = 400;
    
}
-(void)setUpRefresh
{
    //同样,自定义上拉刷新
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadNewData
{
    //8.2 取消之前的请求
    [self.tableView.mj_header endRefreshing];
    
    self.lastPageIndex = @"1";
    //参数
    UserMyModel *model = TakeLoginUserModel;
    NSString *currentId = model.ID;
    NSString *userId = self.userId;
    
    SSLog(@"%@",currentId);
    SSLog(@"%@",userId);
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    
    NSString *url = @"userMain.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"currentId":currentId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex
                           };
    
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        ArtistObjectModel *model = [ArtistObjectModel mj_objectWithKeyValues:modelDict[@"object"]];
        
        self.models = model.artworkList;
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
        
    }];
}

-(void)loadMoreData
{
    //8.2 取消之前的请求
    [self.tableView.mj_footer endRefreshing];
    
    //参数
    int newPageIndex = self.lastPageIndex.intValue + 1;
    
    self.lastPageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    
    //参数
    UserMyModel *model = TakeLoginUserModel;
    NSString *currentId = model.ID;
    NSString *userId = self.userId;
    
    NSString *pageSize = @"20";
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    
    NSString *url = @"userMain.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"currentId":currentId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        ArtistObjectModel *model = [ArtistObjectModel mj_objectWithKeyValues:modelDict[@"object"]];
        
        NSArray *moreModels = model.artworkList;
        
        //拼接数据
        [self.models addObjectsFromArray:moreModels];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //    [cell.btn1 addTarget:self action:@selector(cellBtn1Clicked:event:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.btn2 addTarget:self action:@selector(cellBtn2Clicked:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.indexPath = indexPath;
    cell.delegate = self;
    ArtworkListModel *model = self.models[indexPath.row];
    cell.model = model;
    return cell;
}
//发布动态按钮事件
-(void)PostDynamic:(UIButton *)sender indexPath:(NSIndexPath *)indexPath{
    ArtworkListModel *cellModel = self.models[indexPath.row];
    if ([sender.titleLabel.text isEqualToString:@"发布动态"]) {
        //发布动态
        [self publishState:cellModel.ID];
    }else {
        //传递点击当前cell的数据模型
        
        ComposeProjectViewController *releaseProject = [[ComposeProjectViewController alloc] init];
        //获取点击的编辑项目的项目信息
        NSString *currentUserId = cellModel.author.ID;
                NSString *artWorkId = cellModel.ID;
//        NSString *artWorkId = @"imyt7yax314lpzzj";
        NSString *urlStr = @"investorArtWorkView.do";
        NSDictionary *json = @{
                               @"artWorkId" : artWorkId,
                               @"currentUserId": currentUserId,
                               };
        [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
            
            NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
            NSLog(@"返回结果:%@",jsonStr);
            NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
            ProjectDetailsModel *project = [ProjectDetailsModel mj_objectWithKeyValues:modelDict[@"object"]];
            //在主线程刷新UI数据
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //传递点击当前cell的数据模型
                releaseProject.projectModel = project;
                //                releaseProject
                [self.navigationController pushViewController:releaseProject animated:YES];
            }];
        }];
    }
}
//创作完成事件
-(void)FinishCreation:(UIButton *)sender indexPath:(NSIndexPath *)indexPath{
    
    
    if ([sender.titleLabel.text isEqualToString:@"提交项目"]) {
        //提交项目
        ArtworkListModel *step = self.models[indexPath.row];
        [self loadChangeData:step AndStep:@"10" AndIndexPath:indexPath];
    }else {
        //创作完成
        sender.superview.hidden = YES;
        ArtworkListModel *model = self.models[indexPath.row];
        
        ArtworkFinishedController * vc = [[ArtworkFinishedController alloc] init];
        vc.artworkId = model.ID;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:navController animated:YES completion:nil];
        
        //        [self loadChangeData:model AndStep:@"23" AndIndexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtworkListModel *model = self.models[indexPath.row];
    
    return  model.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtworkListModel *model = self.models[indexPath.row];
    
    if ([model.step isEqualToString:@"10"]){
        [MBProgressHUD showError:@"审核待审核,请您耐心等待"];
    }else if ([model.step isEqualToString:@"11"]){
        [MBProgressHUD showError:@"审核审核中,请您耐心等待"];
    }else if ([model.step isEqualToString:@"12"]){
        [MBProgressHUD showError:@"审核审核通过,请您耐心等待"];
    }else if ([model.step isEqualToString:@"13"]){
        [MBProgressHUD showError:@"审核未通过,请您耐心等待"];
    }else if ([model.step isEqualToString:@"14"]){
        //跳转融资详情页
        DetailFinanceViewController *detail = [[DetailFinanceViewController alloc] init];
        detail.artworkId = model.ID;
        detail.title = model.title;
        [self.navigationController pushViewController:detail animated:YES];
    }else if ([model.step isEqualToString:@"21"]||[model.step isEqualToString:@"22"]||[model.step isEqualToString:@"24"]||[model.step isEqualToString:@"25"]){
        //调到创作详情页
        DetailCreationH5WebController *creationDetailsVC = [[DetailCreationH5WebController alloc] init];
        creationDetailsVC.artWorkId = model.ID;
        creationDetailsVC.title = model.title;
        [self.navigationController pushViewController:creationDetailsVC animated:YES];
    }else if([model.step isEqualToString:@"100"]) {
        [MBProgressHUD showError:@"项目可以编辑"];
    }else if ([model.step isEqualToString:@"30"]||[model.step isEqualToString:@"31"]||[model.step isEqualToString:@"32"]){
        //调到拍卖详情页
        //        DetailCreationViewController *creationDetailsVC = [[DetailCreationViewController alloc] init];
        //        creationDetailsVC.artworkId = model.ID;
        //        creationDetailsVC.title = model.title;
        //        [self.navigationController pushViewController:creationDetailsVC animated:YES];
    }else {
        [MBProgressHUD showError:@"拍卖即将开始"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)cellBtn1Clicked:(UIButton *)btn event:(id)event
{
    SSLog(@"btn1Click");
    if ([btn.titleLabel.text isEqualToString:@"提交项目"]) {
        //提交项目
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:self.tableView];
        NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];
        ArtworkListModel *step = self.models[indexPath.row];
        [self loadChangeData:step AndStep:@"10" AndIndexPath:indexPath];
    }else {
        //创作完成
        btn.superview.hidden = YES;
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:self.tableView];
        NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];
        ArtworkListModel *model = self.models[indexPath.row];
        
        [self loadChangeData:model AndStep:@"23" AndIndexPath:indexPath];
        
    }
}

-(void)loadChangeData:(ArtworkListModel *)model AndStep:(NSString *)step AndIndexPath:(NSIndexPath *)indexPath
{
    //参数
    NSString *artworkId = model.ID;
    NSString *userId = model.author.ID;
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artworkId":artworkId,
                           @"userId" : userId,
                           @"step" : step,
                           };
    NSString *url = @"updateArtWork.do";
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        //            NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //            NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        BianJiJianJieModel *model = [BianJiJianJieModel mj_objectWithKeyValues:modelDict];
        
        [SVProgressHUD showInfoWithStatus:model.resultMsg];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [self loadNewData];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            //                if (indexPath!= nil) {
            //
            //                    //局部刷新数据
            //                    NSArray *indexPaths = @[
            //                                            indexPath,
            //                                            ];
            //
            //                    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            //                }
        }];
    }];
}


//发布动态
-(void)publishState:(NSString *)artworkId{
    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //设置选择图片的截取框
    //    imagePickerController.allowsEditing = YES;
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        ReleaseVideoViewController *videoVc = [[ReleaseVideoViewController alloc] init];
        videoVc.artworkId = artworkId;
        [self.navigationController pushViewController:videoVc animated:YES];
    }];
    UIAlertAction *picAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        //之前的
        //        UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([ReleaseViewController class]) bundle:nil];
        //        ReleaseViewController *settingVC = [settingStoryBoard instantiateInitialViewController];
        ////        [self presentViewController:settingVC animated:YES completion:nil];
        //         [self.navigationController pushViewController:settingVC animated:YES];
        
        //现在的
        UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([ReleasePicViewController class]) bundle:nil];
        ReleasePicViewController *releasePicVC = [settingStoryBoard instantiateInitialViewController];
        releasePicVC.artworkId = artworkId;
        [self.navigationController pushViewController:releasePicVC animated:YES];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action)
                                   {
                                       //这里可以不写代码
                                   }];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [alertController addAction:videoAction];
    [alertController addAction:picAction];
    [alertController addAction:cancelAction];
    
}

//-----------------------联动-----------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 80; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    CGPoint offset = scrollView.contentOffset;
    UIScrollView *superView = (UIScrollView *)scrollView.superview.superview.superview.superview;
    if (superView.contentOffset.y >= self.topHeight) {
        self.isfoot = NO;
        superView.contentOffset = CGPointMake(0, self.topHeight);
        scrollView.scrollEnabled = YES;
    }
    if (superView.contentOffset.y < -64) {
        self.isfoot = YES;
        superView.contentOffset = CGPointMake(0, -64);
        scrollView.scrollEnabled = YES;
    }
    //    NSLog(@"bool = %d",self.isfoot);
    CGFloat zeroY = superView.contentOffset.y + scrollView.contentOffset.y;
    if (self.isfoot && scrollView.contentOffset.y > 0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if (!self.isfoot && scrollView.contentOffset.y < 0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
    }
    if (superView.contentOffset.y < self.topHeight && scrollView.contentOffset.y >0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if(superView.contentOffset.y < self.topHeight && scrollView.contentOffset.y <= 0){
        CGFloat y = scrollView.contentOffset.y / 10;
        zeroY = superView.contentOffset.y + y;
        
        if (zeroY < 0) {
            [superView setContentOffset:CGPointMake(0, -64) animated:YES];
        }else{
            superView.contentOffset = CGPointMake(0, superView.contentOffset.y + y);
        }
    }
}
//-----------------------联动-----------------------

@end

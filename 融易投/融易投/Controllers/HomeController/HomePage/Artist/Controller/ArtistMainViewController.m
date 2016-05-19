//
//  FocusMyArtistTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistMainViewController.h"

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

@interface ArtistMainViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
    
    
    //    self.tableView.contentInset = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, 0, 0);
    //    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, 0, 0);
    
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
                 @"ID"          :@"id",
                 };
    }];

    [ArtworkModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id",
                 };
    }];
    
    [self loadNewData];
    
    //设置刷新控件
    [self setUpRefresh];
    
}
-(void)setUpRefresh
{
    //    CommonHeader *header = [CommonHeader headerWithRefreshingBlock:^{
    //
    //        [self loadNewData];
    //
    //    }];
    //
    //    self.tableView.mj_header = header;
    
    //让程序一开始就加载数据
    //    [self.tableView.mj_header beginRefreshing];
    
    
    //同样,自定义上拉刷新
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //要是其他控制器也需要,直接把上面的拷贝到其他控制器就可以了
}

-(void)loadNewData
{
    //8.2 取消之前的请求
    [self.tableView.mj_header endRefreshing];
    
    self.lastPageIndex = @"1";
    //参数
    NSString *userId = @"imhfp1yr4636pj49";
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    //flag为1是自己看自己,为2时是看别人,还需要传递otheruserId
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&userId=%@&key=%@",pageIndex,pageSize,timestamp,userId,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8085/app/userMain.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        
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
    
    NSLog(@"newPageIndex%@",self.lastPageIndex);
    
    NSLog(@"%d",newPageIndex);
    
    //参数
    NSString *userId = @"imhfp1yr4636pj49";
    NSString *pageSize = @"20";
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&userId=%@&key=%@",pageIndex,pageSize,timestamp,userId,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8085/app/userMain.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        NSLog(@"返回结果:%@",jsonStr);
        
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
    
    [cell.btn1 addTarget:self action:@selector(cellBtn1Clicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btn2 addTarget:self action:@selector(cellBtn2Clicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    ArtworkListModel *model = self.models[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtworkListModel *model = self.models[indexPath.row];
    
    return  model.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)cellBtn1Clicked:(UIButton *)btn event:(id)event
{
    
    SSLog(@"btn1Click");
    
    if ([btn.titleLabel.text isEqualToString:@"提交项目"]) {
        
        //提交项目
        SSLog(@"提交项目");

        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:self.tableView];
        NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];
        
        ArtworkListModel *step = self.models[indexPath.row];
        
        [self loadChangeData:step AndStep:@"10" AndIndexPath:indexPath];
        
    
    }else {
        
        //创作完成
        SSLog(@"创作完成");
        
        btn.superview.hidden = YES;
        
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:self.tableView];
        NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];

        ArtworkListModel *step = self.models[indexPath.row];
        
        [self loadChangeData:step AndStep:@"30" AndIndexPath:indexPath];
    }
}

-(void)loadChangeData:(ArtworkListModel *)model AndStep:(NSString *)step AndIndexPath:(NSIndexPath *)indexPath
{
        //参数
        NSString *artworkId = model.ID;
        NSString *userId = model.author.ID;
    
        SSLog(@"%@",model.step);
    
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

- (void)cellBtn2Clicked:(UIButton *)btn event:(id)event
{
    
    SSLog(@"btn2Click");
    
    if ([btn.titleLabel.text isEqualToString:@"发布动态"]) {
        
        //发布动态
        [self publishState];
        
    }else {
        
        //编辑项目
        // 弹出发微博控制器
//        ReleaseProjectViewController *releaseProject = [[ReleaseProjectViewController alloc] init];
//        
//        [self.navigationController pushViewController:releaseProject animated:YES];
        
        //传递点击当前cell的数据模型
        NSSet *touches =[event allTouches];
        UITouch *touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:self.tableView];
        NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];
        ArtworkListModel *cellModel = self.models[indexPath.row];
        
        ComposeProjectViewController *releaseProject = [[ComposeProjectViewController alloc] init];

        
        //获取点击的编辑项目的项目信息
        
        NSString *currentUserId = cellModel.author.ID;
//        NSString *artWorkId = cellModel.ID;
        NSString *artWorkId = @"imyt7yax314lpzzj";
        
        
        NSString *urlStr = @"investorArtWorkView.do";
        NSDictionary *json = @{
                               @"artWorkId" : artWorkId,
                               @"currentUserId": currentUserId,
                               };
        
        
        [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
            
            
//            NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//            NSLog(@"返回结果:%@",jsonStr);
            
            NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
            
            ProjectDetailsModel *project = [ProjectDetailsModel mj_objectWithKeyValues:modelDict[@"object"]];
            
            SSLog(@"%@",project);
            
            //在主线程刷新UI数据
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                //传递点击当前cell的数据模型
                releaseProject.projectModel = project;
                
                 [self.navigationController pushViewController:releaseProject animated:YES];
            }];
            
            
        }];
    }
}


//发布动态
-(void)publishState{

    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    //设置选择图片的截取框
    //    imagePickerController.allowsEditing = YES;
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        ReleaseVideoViewController *videoVc = [[ReleaseVideoViewController alloc] init];
        
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

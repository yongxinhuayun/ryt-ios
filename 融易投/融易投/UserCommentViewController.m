//
//  UserCommentViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UserCommentViewController.h"
#import "CommonUserHomeViewController.h"
#import "PostCommentController.h"
#import "CommonHeader.h"
#import "CommonFooter.h"

#import <MJExtension.h>

#import "UserCommonResultModel.h"
#import "UserCommentObjectModel.h"
#import "ArtworkCommentListModel.h"
#import "ArtworkMessageModel.h"
#import "CreatorModel.h"
#import "PageInfoModel.h"
#import "UserMyModel.h"
#import "UserCommonCell.h"
#import "UserReplyCommentCell.h"
#import "ArtworkCommentListModel.h"
#import "UITableView+Improve.h"

@interface UserCommentViewController ()<ArtworkCommentListModelDelegate>
@property (nonatomic, strong) NSMutableArray *models;
/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageNum;

//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------
@end

@implementation UserCommentViewController

static NSString *ID = @"userCommentCell";
-(void)reloadDataSource{
    [self loadData];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = 250;
    [UserCommentObjectModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworkCommentList":[ArtworkCommentListModel class],
                 @"fatherComment" : [ArtworkCommentListModel class],
                 };
    }];
    [ArtworkCommentListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    [ArtworkMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    [CreatorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    NSNotificationCenter *notCenter = [NSNotificationCenter defaultCenter];
    [notCenter addObserver:self selector:@selector(reloadDataSource) name:@"POSTCOMMENT" object:nil];
    [self loadData];
    [self setUpRefresh];
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"UserCommonCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserReplyCommentCell" bundle:nil] forCellReuseIdentifier:@"ReplyCell"];
    [self.tableView improveTableView];
}

-(void)setUpRefresh
{
    //自定义上拉加载更多
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


-(void)loadData{
    
    //参数
    //    NSString *artWorkId = [[NSUserDefaults standardUserDefaults] objectForKey:@"artWorkId"];
    NSString *artWorkId = self.artWorkId;
    self.lastPageNum = @"1";
    NSString *pageIndex = @"1";
    NSString *pageSize = @"20";
    NSString *url = @"investorArtWorkComment.do";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : artWorkId,
                           @"pageIndex":pageIndex,
                           @"pageSize":pageSize,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        UserCommonResultModel *userCommentObject = [UserCommonResultModel mj_objectWithKeyValues:modelDict];
        self.models = [ArtworkCommentListModel mj_objectArrayWithKeyValuesArray:userCommentObject.object.artworkCommentList];
        for (ArtworkCommentListModel *m in self.models) {
            NSLog(@"model : %@,%@ \n",m.ID,m.content);
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

-(void)loadMoreData{
    //8.2 取消之前的请求
    [self.tableView.mj_footer endRefreshing];
    //参数
    NSString *pageSize = @"20";
    int newPageNum = self.lastPageNum.intValue + 1;
    self.lastPageNum = [NSString stringWithFormat:@"%d",newPageNum];
    NSString *pageNum = [NSString stringWithFormat:@"%d",newPageNum];
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : self.artWorkId,
                           @"pageIndex":pageNum,
                           @"pageSize":pageSize,
                           };
    NSString *url = @"investorArtWorkComment.do";
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        UserCommonResultModel *userCommentObject = [UserCommonResultModel mj_objectWithKeyValues:modelDict];
        NSArray *array = [ArtworkCommentListModel mj_objectArrayWithKeyValuesArray:userCommentObject.object.artworkCommentList];
        [self.models addObjectsFromArray:array];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

-(void)dealloc{
    NSNotificationCenter *notCenter = [NSNotificationCenter defaultCenter];
    [notCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtworkCommentListModel *model = self.models[indexPath.row];
    if (model.fatherComment == nil) {
        UserCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.model = model;
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }else{
        
        UserReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCell" forIndexPath:indexPath];
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取评论信息
    ArtworkCommentListModel *model = self.models[indexPath.row];
    PostCommentController *postCon = [[PostCommentController alloc] init];
    RYTLoginManager *manager = [RYTLoginManager shareInstance];
    if (![manager showLoginViewIfNeed]) {
        // 当前用户的ID
        NSString *currentId = manager.takeUser.ID;
        //判断当前用户ID,与发表评论的人的ID 是否 相同
        if (![currentId isEqualToString:model.creator.ID]) {
            postCon.currentUserId = currentId;
            postCon.fatherCommentId = model.ID;
            postCon.artworkId = self.artWorkId;
            postCon.title = [NSString stringWithFormat:@"回复%@",model.creator.username];
            [self.navigationController pushViewController:postCon animated:YES];
        }
    }
    
}

-(void)clickUserIconOrName:(NSIndexPath *)indexPath{
    ArtworkCommentListModel *model = self.models[indexPath.row];
    NSString *userId = model.creator.ID;
    if (userId) {
        [self jumpToUserHome:userId];
    }
    
}
-(void)clickUserIcon:(NSIndexPath *)indexPath{
    ArtworkCommentListModel *model = self.models[indexPath.row];
    NSString *userId = model.creator.ID;
    [self jumpToUserHome:userId];
}
-(void)clickfatherIcon:(NSIndexPath *)indexPath{
    ArtworkCommentListModel *model = self.models[indexPath.row];
    NSString *userId = model.fatherComment.creator.ID;
    [self jumpToUserHome:userId];
}

-(void)jumpToUserHome:(NSString *)userId{
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    NSString *currentId = [[RYTLoginManager shareInstance] takeUser].ID;
    // 3.设置请求体
    NSDictionary *json = @{
                           @"currentId" : currentId,
                           @"userId" : userId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"my.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        PageInfoModel *pageModel = [PageInfoModel mj_objectWithKeyValues:modelDict[@"pageInfo"]];
        //保存模型,赋值给控制器
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            CommonUserHomeViewController *commonUserHome = [[CommonUserHomeViewController alloc] init];
            commonUserHome.model = pageModel;
            NSString *title = [NSString stringWithFormat:@"%@的个人主页",pageModel.user.name];
            commonUserHome.title = title;
            [self.navigationController pushViewController:commonUserHome animated:YES];
        }];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtworkCommentListModel *model = self.models[indexPath.row];
    
    return  model.cellHeight;
}

//-----------------------联动-----------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.topHeight > 0) {
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
}
//-----------------------联动-----------------------


@end

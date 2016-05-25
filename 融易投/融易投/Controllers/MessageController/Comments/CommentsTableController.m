//
//  CommentsTableController.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "CommentsTableController.h"
#import "CommonNavigationController.h"
#import "PostCommentController.h"
#import "DetailFinanceViewController.h"
#import "DetailCreationViewController.h"
#import "NormalCommentsCell.h"

#import <MJExtension.h>
#import <MJRefresh.h>
#import  "UITableView+Improve.h"

#import "MessageResultModel.h"
#import "UserCommentListModel.h"
#import "CreatorModel.h"
#import "ArtworkModel.h"
#import "CommonFooter.h"


@interface CommentsTableController ()<CommentsDelegate,CommonNavigationDelegate>
@property(nonatomic,strong)NSMutableArray *commentArray;
@property(nonatomic,copy) NSString *lastPageNum;
@end

@implementation CommentsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    CommonNavigationController *nav = (CommonNavigationController *)self.navigationController;
    nav.commonDelegate = self;
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"NormalCommentsCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
    [UserCommentListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"id" forKey:@"ID"];
    }];
    [MessageResultModel mj_setupObjectClassInArray:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"UserCommentListModel" forKey:@"objectList"];
    }];
    [CreatorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"id" forKey:@"ID"];
    }];
    [ArtworkModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"id" forKey:@"ID"];
    }];
    
    [self.tableView  setSeparatorColor:[UIColor colorWithRed:227.0 / 255.0 green:228.0 / 255.0 blue:229.0 / 255.0 alpha:0.6]];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView improveTableView];
    [self setUpRefresh];
}

-(void)beforeBack{
    // 点击返回按钮，清除用户私信未读的数量
    NSString *userId = @"ioe4rahi670jsgdt";
    NSString *group = @"comment";
    NSDictionary *json = @{
                           @"group" : group,
                           @"userId" : userId
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"updateWatchedStatus" parameters:json
                                 showHUDView:nil andBlock:^(id respondObj) {
                                     NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
                                     NSLog(@"返回结果:%@",jsonStr);
                                 }];
}

-(void)postUserComments:(UserCommentListModel *)commentModel{
    PostCommentController *postController = [[PostCommentController alloc] init];
    postController.title = [NSString stringWithFormat:@"回复%@",commentModel.creator.name];
    postController.artworkId = commentModel.artwork.ID;
    // 当前用户的ID
    postController.currentUserId = @"iijq9f1r7apprtab";
    postController.fatherCommentId = commentModel.fatherArtworkCommentBean.creator.ID;
    [self.navigationController pushViewController:postController animated:YES];
}

-(void)jumpToDetailController:(UserCommentListModel *)commentModel{
    //根据 项目的进度 跳转到 融资 或 创作
    NSInteger step = [commentModel.artwork.step intValue];
//    12；14；15	融资阶段
//    21；22；23；24；25	创作阶段
    if(step == 12 ||step == 14 ||step == 15){
        DetailFinanceViewController *detailController = [[DetailFinanceViewController alloc] init];
        detailController.artworkModel = commentModel.artwork;
        detailController.artworkId = commentModel.artwork.ID;
        [self.navigationController pushViewController:detailController animated:YES];
    }
    else if (step == 21 ||step == 22 ||step == 23 ||step == 24 ||step == 25){
        DetailCreationViewController *detailController = [[DetailCreationViewController alloc] init];
        detailController.artworkId = commentModel.artwork.ID;
        detailController.creationModel = commentModel.artwork;
        detailController.title = commentModel.artwork.title;
        [self.navigationController pushViewController:detailController animated:YES];
//        detailController.
    }
}

-(void)setUpRefresh
{
    //自定义上拉加载更多
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadData{
    NSString * pageNum = @"1";
    self.lastPageNum = pageNum;
    NSString* pageSize = @"99";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId" : [[RYTLoginManager shareInstance] takeUser].ID,
                           @"pageNum" : pageNum,
                           @"pageSize" :pageSize,
                           @"type"     :@"1"
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"information.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
                NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
                NSLog(@"返回结果:%@",jsonStr);
        
        MessageResultModel *resultModel = [MessageResultModel mj_objectWithKeyValues:respondObj];
        [self.commentArray addObjectsFromArray:resultModel.objectList];
        //在主线程刷新UI数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
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
                           @"userId" : [[RYTLoginManager shareInstance] takeUser].ID,
                           @"pageNum" : pageNum,
                           @"pageSize" :pageSize,
                           @"type"     :@"1"
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"information.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        MessageResultModel *resultModel = [MessageResultModel mj_objectWithKeyValues:respondObj];
        if (resultModel.objectList) {
            [self.commentArray addObjectsFromArray:resultModel.objectList];
        }
        //在主线程刷新UI数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NormalCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell" forIndexPath:indexPath];
    UserCommentListModel *model = self.commentArray[indexPath.row];
    cell.commentModel = model;
    cell.delegate = self;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCommentListModel *model = self.commentArray[indexPath.row];
    return model.cellHeight;
}

-(NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

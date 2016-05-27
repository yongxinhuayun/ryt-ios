//
//  RecordTableViewController.m
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RecordTableViewController.h"
#import "CommonUserHomeViewController.h"
#import "RecordTableViewCell.h"
#import "TopRecordTCell.h"
#import <MJExtension.h>
#import "CommonHeader.h"
#import "CommonFooter.h"
#import "RecordModelList.h"
#import "RecordModel.h"
#import "UserMyModel.h"
#import "PageInfoModel.h"
#import "UITableView+Improve.h"
@interface RecordTableViewController ()<RecordCellDelegate>


@property(nonatomic,strong) NSMutableArray *artTopList;
@property (nonatomic, strong) NSMutableArray *artList;
/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageIndex;

//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------

@end

@implementation RecordTableViewController

//--------------
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
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    // 3.设置请求体
    NSDictionary *json = @{

                           @"artWorkId":self.ID,
//                           @"artWorkId":@"in5z7r5f2w2f73so",

                           @"artWorkId":@"qydeyugqqiugd2",

                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"investorArtWorkInvest.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        RecordModelList *model = [RecordModelList mj_objectWithKeyValues:modelDict[@"object"]];
        self.artList = model.artworkInvestList;
        self.artTopList = model.artworkInvestTopList;
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
        [self.tableView improveTableView];
    }];
}

-(void)loadMoreData{
    //8.2 取消之前的请求
    [self.tableView.mj_footer endRefreshing];
    //参数
    int newPageIndex = self.lastPageIndex.intValue + 1;
    self.lastPageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    //参数
//    NSString *userId = @"ieatht97wfw30hfd";
    NSString *pageSize = @"20";
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId":self.ID,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"investorArtWorkInvest.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
            RecordModelList *model = [RecordModelList mj_objectWithKeyValues:modelDict[@"object"]];
            //拼接数据
            //            self.artTopList = model.artworkInvestTopList;
            
            if (model.artworkInvestList != nil) {
                [self.artList addObject:model.artworkInvestList];
            }
            [self.tableView reloadData];
            
        }];

    }];

}
//--------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // 刷新
    self.lastPageIndex = @"1";
    [self loadNewData];
    //设置刷新控件
    [self setUpRefresh];
    [RecordModelList mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworkInvestTopList":@"RecordModel",
                 @"artworkInvestList":@"RecordModel"
                 };
    }];
    [RecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
      return @{@"ID":@"id"};
    }];
    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    self.isfoot = YES;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopRecordTCell" bundle:nil] forCellReuseIdentifier:@"TopRecordCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.artTopList.count == 0) {
            return 0;
        }else{
            return 1;}
    }else{
        return self.artList.count;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, tableView.width, 80);
    header.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touzimingxingbang"]];
        imgView.center = header.center;
        imgView.height = 59;
        imgView.width = 266;
        [header addSubview:imgView];
    }else{
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zuixintouzijilu"]];
        imgView.center = header.center;
        imgView.height = 15;
        [header addSubview:imgView];
    }
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TopRecordTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopRecordCell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        [cell setupUI:self.artTopList];
        return cell;
    }else{
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"                                                                    forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.model = self.artList[indexPath.row];
        return cell;
    }
}

-(void)clickUserBtnIcon:(NSIndexPath *)indexPath{
    RecordModel *recModel = self.artList[indexPath.row];
    [self jumpToUserHome:recModel.creator.ID];
}

-(void)clickUserBtn:(NSInteger)tag{
    RecordModel *recModel = self.artTopList[tag - 1];
    [self jumpToUserHome:recModel.creator.ID];
}

-(void)jumpToUserHome:(NSString *)userId{
    RYTLoginManager *manager =  [RYTLoginManager shareInstance];
    if ([manager showLoginViewIfNeed]) {
    }else{
        NSString *pageSize = @"20";
        NSString *pageIndex = @"1";
        // 3.设置请求体
        NSDictionary *json = @{
                               @"userId":userId,
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
//                commonUserHome.model = pageModel;
                commonUserHome.userId = userId;
                NSString *title = [NSString stringWithFormat:@"%@的个人主页",pageModel.user.name];
                commonUserHome.title = title;
                [self.navigationController pushViewController:commonUserHome animated:YES];
            }];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.section ==0) {
        if (self.artTopList.count == 0) {
            return 0;
        }else{
            return 200;
        }
    }else{
        return 60;
    }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSMutableArray *)artTopList{
    if (!_artTopList) {
        _artTopList = [[NSMutableArray alloc] init];
    }
    return _artTopList;
}
-(NSMutableArray *)artList{
    if (!_artList) {
        _artList = [[NSMutableArray alloc] init];
    }
    return _artList;
}
@end

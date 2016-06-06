//
//  FinanceTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceTableViewController.h"
#import "DetailFinanceViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "FinanceModel.h"
#import "authorModel.h"

#import <MJExtension.h>

#import "FinanceTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "CommonHeader.h"
#import "CommonFooter.h"

@interface FinanceTableViewController ()


//存放模型的数组
@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageNum;


/** 保存模型数据 */
@property (nonatomic, strong) FinanceModel *model;

@end

@implementation FinanceTableViewController

static NSString *ID = @"financeCell";

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

-(void)viewWillDisppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastPageNum = @"1";
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);
//    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, SSTabBarH, 0);;
    self.tableView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"FinanceTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [FinanceModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descriptions":@"description",
                 @"ID"          :@"id",
                 };
    }];
    //设置刷新控件
    [self setUpRefresh];
    //设置全屏灰色的分割线
    //使用设置setFrame的方法
    //先要把系统的分割线去除,然后把控制器的背景改成要设置分割线的颜色即可,然后在设置cell的setFrame方法中,在系统计算好的cell的高度之前让cell的高度减一,然后在赋值给系统的算好的frame
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:(229)/255.0 green:(230)/255.0 blue:(231)/255.0 alpha:1.0];
    
}

-(void)setUpRefresh{
    CommonHeader *header = [CommonHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    self.tableView.mj_header = header;
    //让程序一开始就加载数据
    [self.tableView.mj_header beginRefreshing];
    //同样,自定义上拉刷新
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadNewData{
    //8.2 取消之前的请求
    [self.tableView.mj_header endRefreshing];
    self.lastPageNum = @"1";
    //参数
    NSString *pageSize = @"20";
    NSString *pageNum = @"1";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"investorIndex.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        //                NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //                NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        self.models = [FinanceModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        //在主线程刷新UI数据
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
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"investorIndex.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        //                NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //                NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        //字典数组 -> 模型数组
        NSArray *moreModels = [FinanceModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        //拼接数据
        [self.models addObjectsFromArray:moreModels];
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];

    }];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FinanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.x = 0;
    
    FinanceModel *model = self.models[indexPath.row];
    
    self.model = model;
    
    cell.model = model;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  获取当前cell中的数据
    FinanceModel *model = self.models[indexPath.row];
    //  跳转
    DetailFinanceViewController *detail = [[DetailFinanceViewController alloc] init];
//    detail.financeModel = model;
    detail.artworkId = model.ID;
    // 传递数据
    detail.navigationItem.title = model.title;
    [self.navigationController pushViewController:detail animated:YES];

    
    //    FinanceModel *model = self.models[indexPath.row];
    
//    FinanceDetailViewController *financeDetailVC = [[FinanceDetailViewController alloc] init];
//    
//    financeDetailVC.modelsArray = self.models;
//    [self.navigationController pushViewController:financeDetailVC animated:YES];
    
//    FinanceViewController *financeDetailVC = [[FinanceViewController alloc] init];
//    
//    financeDetailVC.modelsArray = self.models;
//    
//    [self.navigationController pushViewController:financeDetailVC animated:YES];
    
//    UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([XiangqingViewController class]) bundle:nil];
//    XiangqingViewController *settingVC = [settingStoryBoard instantiateInitialViewController];
//    [self.navigationController pushViewController:settingVC animated:YES];
    
//    // 告诉其他人（全世界）吧非详情页的数据传递给详情页
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.model.ID,@"artWordID", nil];
//    
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:ProjectDetailsArtWorkIdNotification object:nil userInfo:dict];
//    
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
//    XIBDemoViewController *controller = [[XIBDemoViewController alloc] init];
    
//    FinanceDetailsViewController *controller = [[FinanceDetailsViewController alloc] init];
    
    //使用归档进行保存id
    //NSUserDefaults  是个单例,但是取出不是shared
//    [[NSUserDefaults standardUserDefaults] setObject:self.model.ID forKey:@"artWorkId"];
    
}

@end

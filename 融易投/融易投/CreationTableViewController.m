//
//  CreationTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CreationTableViewController.h"
#import "DetailFinanceViewController.h"
#import "FinanceViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "CreationModel.h"
#import "authorModel.h"
#import <MJExtension.h>
#import "CreationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "CommonHeader.h"
#import "CommonFooter.h"
#import "DetailCreationViewController.h"
#import "DetailCreationH5WebController.h"

@interface CreationTableViewController ()

@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastpageIndex;
@end

@implementation CreationTableViewController

static NSString *ID = @"creationCell";

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastpageIndex = @"1";
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    self.tableView.contentInset = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(67, 0, 50, 0);
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"CreationTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [CreationModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" :@"id",
                 @"descriptions":@"description",
                 };
    }];
    [self setUpRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setUpRefresh
{
    CommonHeader *header = [CommonHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    self.tableView.mj_header = header;
    //让程序一开始就加载数据
    [self.tableView.mj_header beginRefreshing];
    //同样,自定义上拉刷新
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData1)];
}


-(void)loadNewData{
    [self.tableView.mj_header endRefreshing];
    self.lastpageIndex = @"1";
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"artWorkCreationList.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        //5. 解析从服务器获取的JSON数据
//                NSString *jsonString = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        
         NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        NSDictionary *model = modelDict[@"object"];
        self.models = [CreationModel mj_objectArrayWithKeyValuesArray:model[@"artworkList"]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

-(void)loadMoreData1{
    [self.tableView.mj_header endRefreshing];
    //参数
    NSString *pageSize = @"20";
    int newpageIndex = self.lastpageIndex.intValue + 1;
    self.lastpageIndex = [NSString stringWithFormat:@"%d",newpageIndex];
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newpageIndex];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"artWorkCreationList.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        //5. 解析从服务器获取的JSON数据
                NSString *jsonString = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        //13. 字典数组 -> 模型数组
        NSArray *moreModels = [CreationModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        //14. 拼接数据
        [self.models addObjectsFromArray:moreModels];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
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
    CreationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    CreationModel *model = self.models[indexPath.section];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 335;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    DetailCreationViewController *creationDetailsVC = [[DetailCreationViewController alloc] init];
    CreationModel *model = self.models[indexPath.row];
    creationDetailsVC.artworkId = model.ID;
//    creationDetailsVC.creationID = model.ID;
//    creationDetailsVC.creationModel = model;
    
    creationDetailsVC.title = model.title;
    [self.navigationController pushViewController:creationDetailsVC animated:YES];
     */
    
    DetailCreationH5WebController *H5VC = [[DetailCreationH5WebController alloc] init];
//    CreationModel *model = self.models[indexPath.row];
//    creationDetailsVC.artworkId = model.ID;
    
//    creationDetailsVC.title = model.title;
    [self.navigationController pushViewController:H5VC animated:YES];
    
}

@end
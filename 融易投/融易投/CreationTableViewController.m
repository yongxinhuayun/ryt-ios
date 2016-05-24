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
    //内边距的顶部应该是导航条的最大值64加上标题栏的高度
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    //    self.tableView.contentInset = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, 0, 0);
    //    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, 0, 0);
    //运行程序,发现系统帮我们自动调整scrollView的内边距,所以在精华控制器中设置automaticallyAdjustsScrollViewInsets = NO即可
    //设置tableView的内边距---实现全局穿透让tableView向上移动64 + 标题栏的高度35/向下移动tabBar的高度49
    //运行程序,发现底部一致到了tabBar的最下面,我们应该设置成子控制器的view的显示范围为tabBar的上面
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
    //但是如果我们想整个项目都要用到上拉刷新和下拉刷新呢,不能把这上面的代码一个个拷贝了吧
    //这样,我们可以使用继承,自定义刷新控件然后继承自MJRefreshNormalHeader,这里是自定义下拉刷新
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

-(void)loadMoreData{
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
//                NSString *jsonString = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        //13. 字典数组 -> 模型数组
        NSArray *moreModels = [CreationModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        //14. 拼接数据
        [self.models addObjectsFromArray:moreModels];
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
    DetailCreationViewController *creationDetailsVC = [[DetailCreationViewController alloc] init];
    CreationModel *model = self.models[indexPath.row];
    creationDetailsVC.artworkId = model.ID;
    creationDetailsVC.creationModel = model;
    
    creationDetailsVC.title = model.title;
    [self.navigationController pushViewController:creationDetailsVC animated:YES];
}

@end
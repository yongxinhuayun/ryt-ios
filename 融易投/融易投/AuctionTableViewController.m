//
//  AuctionTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "AuctionTableViewController.h"
#import "DetailAuctionH5Controller.h"

#import "AuctionModel.h"
#import "authorModel.h"

#import <MJExtension.h>

#import "AuctionTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "CommonHeader.h"
#import "CommonFooter.h"

@interface AuctionTableViewController ()

@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageNum;

/** 计算高度的cell的工具 */
@property (nonatomic, strong) AuctionTableViewCell *auctionTableViewCellTool;

@end

@implementation AuctionTableViewController


static NSString *ID = @"auctionCell";

-(AuctionTableViewCell *)auctionTableViewCellTool{
    if (!_auctionTableViewCellTool) {
        _auctionTableViewCellTool = [self.tableView dequeueReusableCellWithIdentifier:ID];
    }
    
    return _auctionTableViewCellTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView *tableview = [[UIView alloc] initWithFrame:self.view.bounds];
//    tableview.backgroundColor = [UIColor whiteColor];
//    UILabel *label = [[UILabel alloc] init];
//    label.centerX = self.view.centerX - 54;
//    label.centerY = self.view.centerY - 64;
//    label.text = @"敬请期待...";
////    [label setTextColor:[UIColor grayColor]];
//    label.textColor = [UIColor grayColor];
//    label.font = [UIFont systemFontOfSize:24];
//    label.width = 120;
//    label.height = 30;
//    [tableview addSubview:label];
//    self.view = tableview;
    
    self.lastPageNum = @"1";
    
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(SSNavMaxY, 0, SSTabBarH, 0);
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"AuctionTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    
    [AuctionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID" :@"id",
                 @"descriptions":@"description",
                 };
    }];
    
    //设置刷新控件
    [self setUpRefresh];
    
    //设置全屏灰色的分割线
    //使用设置setFrame的方法
    //先要把系统的分割线去除,然后把控制器的背景改成要设置分割线的颜色即可,然后在设置cell的setFrame方法中,在系统计算好的cell的高度之前让cell的高度减一,然后在赋值给系统的算好的frame
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.view.backgroundColor = [UIColor colorWithRed:(250)/255.0 green:(250)/255.0 blue:(250)/255.0 alpha:1.0];
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
    
    //要是其他控制器也需要,直接把上面的拷贝到其他控制器就可以了
}

-(void)loadNewData
{
    //8.2 取消之前的请求
    [self.tableView.mj_header endRefreshing];
    
    self.lastPageNum = @"1";
    
    //参数
    NSString *pageSize = @"20";
    NSString *pageNum = @"1";
    
    NSString *url = @"artWorkAuctionList.do";
    
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum
                           };
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
    
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        NSLog(@"%@",modelDict);
        
        self.models = [AuctionModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        
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
    NSString *pageSize = @"1";
    
    int newPageNum = self.lastPageNum.intValue + 1;
    
    self.lastPageNum = [NSString stringWithFormat:@"%d",newPageNum];

    
    NSString *pageNum = [NSString stringWithFormat:@"%d",newPageNum];
     NSString *url = @"artWorkAuctionList.do";
    
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum
                           };
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:self.view andBlock:^(id respondObj) {

        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        //13. 字典数组 -> 模型数组
        NSArray *moreModels = [AuctionModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        //14. 拼接数据
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
    AuctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    AuctionModel *model = self.models[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

// 10. 确定cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuctionModel *model = self.models[indexPath.row];
    
    SSLog(@"%ld-------%f",(long)indexPath.row,model.cellH);
    
    return  model.cellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailAuctionH5Controller *H5VC = [[DetailAuctionH5Controller alloc] init];
    
    AuctionModel *model = self.models[indexPath.row];
    H5VC.artWorkId = @"qydeyugqqiugd2";
    H5VC.step = model.step;
    H5VC.title = model.title;
    
    SSLog(@"%@---%@---%@",model.ID,model.step,model.title);
    
    [self.navigationController pushViewController:H5VC animated:YES];
    
}

@end

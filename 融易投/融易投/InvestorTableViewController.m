//
//  InvestorTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "InvestorTableViewController.h"

#import <MJExtension.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

#import "InvestorModel.h"
#import "InvestorTableViewCell.h"

@interface InvestorTableViewController ()

@property (nonatomic, strong) NSMutableArray *models;
/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageNum;
/** header标题栏 */
@property (nonatomic, strong) UIView *subTitlesView;
@end
@implementation InvestorTableViewController
static NSString *ID = @"investorCell";

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.lastPageNum = @"1";
    self.tableView.contentInset = UIEdgeInsetsMake(SSTitlesViewH, 0, SSTabBarH, 0);
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, SSTabBarH, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestorTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    //设置刷新控件
    [self setUpRefresh];
    //添加顶部Header
    [self setUpSubTitlesView];
    [self loadNewData];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.tableView reloadData];
}

//添加副标题栏
-(void)setUpSubTitlesView
{
    UIView *subTitlesView = [[UIView alloc] init];
    self.subTitlesView = subTitlesView;
    subTitlesView.frame = CGRectMake(0, SSNavMaxY + SSTitlesViewH, self.view.width, SSTitlesViewH);
    subTitlesView.backgroundColor = [UIColor whiteColor];
    //2.2 添加所有的标题按钮
    [self setUpSubTitleLabel];
}

-(void)setUpSubTitleLabel
{
    NSArray *titles = @[@"排行", @"用户昵称",@"回报总金额"];
    NSInteger index = titles.count;
    //2.3 设置按钮尺寸,要想拿到titlesView需设置成成员属性
    //    CGFloat titleButtonW = self.titlesView.width / 5;
    CGFloat SubTitleLabelW = self.subTitlesView.width / index;
    CGFloat SubTitleLabelH = self.subTitlesView.height;
    //2.4 遍历添加所有标题按钮
    for (NSInteger i = 0; i < index; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(i * SubTitleLabelW, 0, SubTitleLabelW, SubTitleLabelH);
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        [self.subTitlesView addSubview:label];
    }
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
    self.lastPageNum = @"1";
    //参数
    NSString *pageSize = @"20";
    NSString *pageNum = @"1";
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSLog(@"pageSize=%@,pageNum=%@,timestamp=%@",pageNum,pageNum,timestamp);
    
    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&key=%@",pageNum,pageSize,timestamp,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8080/app/getInvestorTopList.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        self.models = [InvestorModel mj_objectArrayWithKeyValuesArray:modelDict[@"InvestorTopList"]];
        
        NSLog(@"11111111111111%@",self.models);
        
        //4. 刷新数据
        //        [self.tableView reloadData];
        
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
    
    NSLog(@"self.lastPageNum%@",self.lastPageNum);
    
    NSLog(@"%d",newPageNum);
    
    NSString *pageNum = [NSString stringWithFormat:@"%d",newPageNum];
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSLog(@"pageSize=%@,pageNum=%@,timestamp=%@",pageNum,pageNum,timestamp);
    
    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&key=%@",pageNum,pageSize,timestamp,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8080/app/getInvestorTopList.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];

        NSArray *moreModels = [InvestorModel mj_objectArrayWithKeyValuesArray:modelDict[@"InvestorTopList"]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvestorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    InvestorModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.RankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"11111";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.subTitlesView;
}

@end

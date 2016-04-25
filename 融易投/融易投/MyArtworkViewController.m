//
//  MyArtworkViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MyArtworkViewController.h"

#import <MJExtension.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

#import "MyArtworkCell.h"

@interface MyArtworkViewController ()

@property (nonatomic, strong) NSMutableArray *models;


/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageNum;


@end

@implementation MyArtworkViewController

static NSString *ID = @"myArtworkCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.lastPageNum = @"1";
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"MyArtworkCell" bundle:nil] forCellReuseIdentifier:ID];
    
    //设置刷新控件
//    [self setUpRefresh];
    
//    [self loadNewData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source
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


-(void)loadNewData
{
    //8.2 取消之前的请求
    [self.tableView.mj_header endRefreshing];
    self.lastPageNum = @"1";
    
    //参数
    NSString *userId = @"imhipoyk18s4k52u";
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
//    NSString *pageSize = @"20";
//    NSString *pageNum = @"1";
//    NSString *timestamp = [MyMD5 timestamp];
//    NSString *appkey = MD5key;
//    
//    NSLog(@"pageSize=%@,pageNum=%@,timestamp=%@",pageNum,pageNum,timestamp);
//    
//    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&key=%@",pageNum,pageSize,timestamp,appkey];
//    NSLog(@"%@",signmsg);
    
    NSString *signmsg = [NSString stringWithFormat:@"timestamp=%@&userId=%@&key=%@",timestamp,userId,appkey];
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId" : userId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.69:8001/app/myArtwork.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        /*
          {"pageInfo":{"artworks":[],"sumInvestment":0.00,"yield":0.00,"user":null,"followNum":0,"num":0}}
         */
//
//        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
//        
//        self.models = [InvestorModel mj_objectArrayWithKeyValuesArray:modelDict[@"InvestorTopList"]];
//        
//        NSLog(@"11111111111111%@",self.models);
        
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
    
    NSString *url = @"http://192.168.1.69:8001/app/getInvestorTopList.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        NSLog(@"返回结果:%@",jsonStr);
        
//        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
//        
//        NSArray *moreModels = [InvestorModel mj_objectArrayWithKeyValuesArray:modelDict[@"InvestorTopList"]];
//        //拼接数据
//        [self.models addObjectsFromArray:moreModels];
        
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
        
    }];
}


#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
//    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyArtworkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
//    InvestorModel *model = self.models[indexPath.row];
//    
//    cell.model = model;
//    
//    cell.RankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    return cell;
}




@end

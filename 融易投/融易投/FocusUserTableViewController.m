//
//  FocusUserTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/22.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FocusUserTableViewController.h"

#import "FocusTableViewCell.h"

#import "FocusModel.h"

#import <MJExtension.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

@interface FocusUserTableViewController ()

@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageNum;

@end

@implementation FocusUserTableViewController


static NSString *ID = @"focusCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.lastPageNum = @"1";
    
//   self.view.backgroundColor = [UIColor yellowColor];


    //设置tableView的内边距---实现全局穿透让tableView向上移动64 + 标题栏的高度35/向下移动tabBar的高度49
    //运行程序,发现底部一致到了tabBar的最下面,我们应该设置成子控制器的view的显示范围为tabBar的上面
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    self.tableView.contentInset = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, 0, 0);
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, 0, 0);
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"FocusTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    //设置刷新控件
    [self setUpRefresh];
    
    [self loadNewData];

}

-(void)setUpRefresh
{
    //但是如果我们想整个项目都要用到上拉刷新和下拉刷新呢,不能把这上面的代码一个个拷贝了吧
    //这样,我们可以使用继承,自定义刷新控件然后继承自MJRefreshNormalHeader,这里是自定义下拉刷新
    
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
    self.lastPageNum = @"1";
    //参数
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"artWorkId"];
    NSString *type = @"1";
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&type=%@&userId=%@&key=%@",pageIndex,pageSize,timestamp,type,userId,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"type":type,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.69:8001/app/userFollowed.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        NSLog(@"返回结果:%@",jsonStr);
        
        //        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        //
        //        self.models = [FocusModel mj_objectArrayWithKeyValuesArray:modelDict[@"InvestorTopList"]];
        //
        //        NSLog(@"11111111111111%@",self.models);
        //
        //
        //        //在主线程刷新UI数据
        //        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //
        //            [self.tableView reloadData];
        //
        //        }];
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
        //
        //
        //        //在主线程刷新UI数据
        //        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //            
        //            [self.tableView reloadData];
        //            
        //        }];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    FocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}


@end

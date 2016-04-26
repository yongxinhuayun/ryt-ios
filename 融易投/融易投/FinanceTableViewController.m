//
//  FinanceTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceTableViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "FinanceModel.h"
#import "authorModel.h"

#import <MJExtension.h>

#import "FinanceTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "CommonHeader.h"
#import "CommonFooter.h"


#import "XiangqingViewController.h"

#import "XIBDemoViewController.h"

#import "FinanceDetailsViewController.h"

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

    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.lastPageNum = @"1";
    
    //内边距的顶部应该是导航条的最大值64加上标题栏的高度
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    //    self.tableView.contentInset = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, 0, 0);
    //    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, 0, 0);
    //运行程序,发现系统帮我们自动调整scrollView的内边距,所以在精华控制器中设置automaticallyAdjustsScrollViewInsets = NO即可
    
    //设置tableView的内边距---实现全局穿透让tableView向上移动64 + 标题栏的高度35/向下移动tabBar的高度49
    //运行程序,发现底部一致到了tabBar的最下面,我们应该设置成子控制器的view的显示范围为tabBar的上面
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);
    
    //我们可以往底部添加额外了滚动区域25,那么整体就向上移动了,但是这样底部离tabbar会有一定的间距了,不好看
    //可以修改顶部的间距,让顶部减25就可以了
    self.tableView.contentInset = UIEdgeInsetsMake(67, 0, 50, 0);
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"FinanceTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    
    [FinanceModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"descriptions":@"description",
                 @"ID"          :@"id",
                 };
    }];
    
    //加载数据
    //    [self loadNewData];
    
    //设置刷新控件
    [self setUpRefresh];
    
    //设置全屏灰色的分割线
    //使用设置setFrame的方法
    //先要把系统的分割线去除,然后把控制器的背景改成要设置分割线的颜色即可,然后在设置cell的setFrame方法中,在系统计算好的cell的高度之前让cell的高度减一,然后在赋值给系统的算好的frame
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.view.backgroundColor = [UIColor lightGrayColor];
    
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
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
//    NSLog(@"pageSize=%@,pageNum=%@,timestamp=%@",pageNum,pageNum,timestamp);
    
    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&key=%@",pageNum,pageSize,timestamp,appkey];
    //    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    //    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 1.创建请求
    //http://192.168.1.69:8001/app/login.do
    //http://192.168.1.57/app-wikiServer/
    //http://j.efeiyi.com:8080/app-wikiServer/app/
    //http://j.efeiyi.com:8080/app-wikiServer/app/login.do
    
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.69:8001/app/investorIndex.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        NSLog(@"返回结果:%@",jsonStr);
        
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        self.models = [FinanceModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        
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
    NSString *pageSize = @"20";
    
    int newPageNum = self.lastPageNum.intValue + 1;
    
    self.lastPageNum = [NSString stringWithFormat:@"%d",newPageNum];
    
    NSString *pageNum = [NSString stringWithFormat:@"%d",newPageNum];
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSLog(@"pageSize=%@,pageNum=%@,timestamp=%@",pageSize,pageNum,timestamp);
    
    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&key=%@",pageNum,pageSize,timestamp,appkey];
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    
    // 1.创建请求
    //http://192.168.1.69:8001/app/login.do
    //http://192.168.1.57/app-wikiServer/
    //http://j.efeiyi.com:8080/app-wikiServer/app/
    //http://j.efeiyi.com:8080/app-wikiServer/app/login.do
    
    
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.69:8001/app/investorIndex.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        NSLog(@"返回结果:%@",jsonStr);
        
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
    
    FinanceModel *model = self.models[indexPath.row];
    
    self.model = model;
    
    cell.model = model;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 378;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    FinanceDetailsViewController *controller = [[FinanceDetailsViewController alloc] init];
    
    //使用归档进行保存id
    //NSUserDefaults  是个单例,但是取出不是shared
    [[NSUserDefaults standardUserDefaults] setObject:self.model.ID forKey:@"artWorkId"];

    [self.navigationController pushViewController:controller animated:YES];
    
}

@end

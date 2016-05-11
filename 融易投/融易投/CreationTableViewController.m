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
    //我们可以往底部添加额外了滚动区域25,那么整体就向上移动了,但是这样底部离tabbar会有一定的间距了,不好看
    //可以修改顶部的间距,让顶部减25就可以了
    self.tableView.contentInset = UIEdgeInsetsMake(67, 0, 50, 0);
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"CreationTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [CreationModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" :@"id",
                 @"descriptions":@"description",
                 };
    }];
    //加载数据
    //    [self loadData];
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
}

-(void)loadNewData
{
    //8.2 取消之前的请求
    [self.tableView.mj_header endRefreshing];
    
    self.lastpageIndex = @"1";
    
    //时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSArray *strArray = [timeString componentsSeparatedByString:@"."];
    //参数
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    NSLog(@"pageSize=%@,pageIndex=%@,timestamp=%@",pageIndex,pageIndex,timestamp);
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&key=%@",pageIndex,pageSize,timestamp,appkey];
    NSString *signmsgMD5 = [self md5:signmsg];
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.41:8080/app/artWorkCreationList.do"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
//    NSString *dataJson = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //5. 解析从服务器获取的JSON数据
//        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *model = modelDict[@"object"];
        self.models = [CreationModel mj_objectArrayWithKeyValuesArray:model[@"artworkList"]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
        
    }];
}

-(void)loadMoreData
{
    //8.2 取消之前的请求
    [self.tableView.mj_footer endRefreshing];
    
    //时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSArray *strArray = [timeString componentsSeparatedByString:@"."];
    
    NSLog(@"%@",strArray.firstObject);
    
    //参数
    NSString *pageSize = @"20";
    
    int newpageIndex = self.lastpageIndex.intValue + 1;
    
    self.lastpageIndex = [NSString stringWithFormat:@"%d",newpageIndex];
    
    NSLog(@"self.lastpageIndex%@",self.lastpageIndex);
    
    NSLog(@"%d",newpageIndex);
    
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newpageIndex];
    
    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    
    NSLog(@"pageSize=%@,pageIndex=%@,timestamp=%@",pageIndex,pageIndex,timestamp);
    
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&key=%@",pageIndex,pageSize,timestamp,appkey];
    //    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [self md5:signmsg];
    
    //    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 1.创建请求
    //http://192.168.1.69:8001/app/login.do
    //http://192.168.1.57/app-wikiServer/
    //http://j.efeiyi.com:8080/app-wikiServer/app/
    //http://j.efeiyi.com:8080/app-wikiServer/app/login.do
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.69:8001/app/artWorkCreationList.do"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    //    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
    //    NSString *dataJson = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    //    NSLog(@"%@",dataJson);
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //5. 解析从服务器获取的JSON数据
        //        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //13. 字典数组 -> 模型数组
        NSArray *moreModels = [CreationModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        //14. 拼接数据
        [self.models addObjectsFromArray:moreModels];
        
        
        //4. 刷新数据
        //        [self.tableView reloadData];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
        
    }];
}
-(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
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
    creationDetailsVC.creationModel =model;
    creationDetailsVC.title = model.title;
    [self.navigationController pushViewController:creationDetailsVC animated:YES];
}

@end
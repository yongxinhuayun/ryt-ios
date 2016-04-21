//
//  ArtistTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistTableViewController.h"

#import <MJExtension.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

#import "ArtistModel.h"
#import "ArtistTableViewCell.h"

@interface ArtistTableViewController ()

@property (nonatomic, strong) NSMutableArray *models;


/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageNum;

/** header标题栏 */
@property (nonatomic, strong) UIView *subTitlesView;

@end

@implementation ArtistTableViewController

static NSString *ID = @"artistCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastPageNum = @"1";
    
    //设置tableView的内边距---实现全局穿透让tableView向上移动64 + 标题栏的高度35/向下移动tabBar的高度49
    //运行程序,发现底部一致到了tabBar的最下面,我们应该设置成子控制器的view的显示范围为tabBar的上面
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    self.tableView.contentInset = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, SSTabBarH, 0);
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, SSTabBarH, 0);
    
    //设置全屏灰色的分割线
    //使用设置setFrame的方法
    //先要把系统的分割线去除,然后把控制器的背景改成要设置分割线的颜色即可,然后在设置cell的setFrame方法中,在系统计算好的cell的高度之前让cell的高度减一,然后在赋值给系统的算好的frame
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"ArtistTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    //设置刷新控件
    [self setUpRefresh];
    
    //添加顶部Header
    [self setUpSubTitlesView];
    
    [self loadNewData];
}

//添加副标题栏
-(void)setUpSubTitlesView
{
    UIView *subTitlesView = [[UIView alloc] init];
    
    self.subTitlesView = subTitlesView;
    
    subTitlesView.frame = CGRectMake(0, SSNavMaxY + SSTitlesViewH, self.view.width, SSTitlesViewH);
    
    subTitlesView.backgroundColor = [UIColor whiteColor];
    //2.9 设置标题栏为半透明的
    //    subTitlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    //    [self.tableView.tableHeaderView addSubview:subTitlesView];
    
    //2.1 运行程序,发现titlesView添加到了tableView,但是我们这里需要时用不同的UIViewController,所以把之前的控制器UITableViewController改成UIViewController
    
    //2.2 添加所有的标题按钮
    [self setUpSubTitleLabel];
}

-(void)setUpSubTitleLabel
{
    NSArray *titles = @[@"排行", @"艺术家",@"项目总金额",@"总成交价"];
    
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
    //但是如果我们想整个项目都要用到上拉刷新和下拉刷新呢,不能把这上面的代码一个个拷贝了吧
    //这样,我们可以使用继承,自定义刷新控件然后继承自MJRefreshNormalHeader,这里是自定义下拉刷新
    
//    CommonHeader *header = [CommonHeader headerWithRefreshingBlock:^{
//        
//        [self loadNewData];
//        
//    }];
//    
//    self.tableView.mj_header = header;
//    
//    //让程序一开始就加载数据
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
    NSString *pageSize = @"1";
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
    
    NSString *url = @"http://192.168.1.69:8001/app/getArtistTopList.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        self.models = [ArtistModel mj_objectArrayWithKeyValuesArray:modelDict[@"ArtistTopList"]];
        
        
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
    
    NSString *url = @"http://192.168.1.69:8001/app/getArtistTopList.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        NSArray *moreModels = [ArtistModel mj_objectArrayWithKeyValuesArray:modelDict[@"ArtistTopList"]];
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
    /*
     //程序一运行就只加载一次背景颜色,如果不这么写,一滚动就会变颜色
     static UIColor *cellBgColor = nil;
     if (cellBgColor == nil) {
     cellBgColor = SSRandomColor;
     }
     
     static NSString *ID = @"cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
     cell.backgroundColor = cellBgColor;
     }
     
     cell.textLabel.text = [NSString stringWithFormat:@"%@ - %zd", self.class, indexPath.row];
     
     return cell;
     */
    
    ArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    ArtistModel *model = self.models[indexPath.row];
    
    cell.model = model;
    
    cell.RankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.subTitlesView;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"11111";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

@end


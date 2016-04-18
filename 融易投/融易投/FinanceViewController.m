//
//  FinanceViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/16.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceViewController.h"

#import "navTitleButton.h"

#import "ProjectDetailViewController.h"
#import "ProjectScheduleViewController.h"
#import "UserCommentViewController.h"
#import<QuartzCore/QuartzCore.h>


#import <MJExtension.h>


#import "FinanceDetailFirstCell.h"
#import "FinanceDetailSecondCell.h"

#import "UIImageView+WebCache.h"

#import "JPSlideBar.h"
#import "JPBaseTableViewController.h"

#import "CommonHeader.h"
#import "CommonFooter.h"

#import "ProjectDetailViewController.h"
#import "ProjectScheduleViewController.h"
#import "UserCommentViewController.h"
#import "InvestRecordViewController.h"

#import "ArtworkModel.h"



@interface FinanceViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSArray * titles;
    
}

/** 嵌套tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


/** 存放所有数据(artWorkList)的数组 */
@property (nonatomic, strong) NSArray *models;


@property (nonatomic ,strong) NSArray *titleArray;

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)JPSlideNavigationBar * slideBar;

//头部视图
@property (nonatomic, strong)UIView *headerView;
//子视图
@property (nonatomic, strong)UIView *subViews;

@property (nonatomic, strong)FinanceDetailSecondCell *cell2;



/** 底部栏 */
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation FinanceViewController

static NSString *ID1 = @"Cell1";
static NSString *ID2 = @"Cell2";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self setUpNav];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    //设置刷新控件
    [self setUpRefresh];
    
//    [self loadData];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"FinanceDetailFirstCell" bundle:nil] forCellReuseIdentifier:ID1];
    [self.tableView registerNib:[UINib nibWithNibName:@"FinanceDetailSecondCell" bundle:nil] forCellReuseIdentifier:ID2];
    
}



-(void)setUpRefresh
{
    //但是如果我们想整个项目都要用到上拉刷新和下拉刷新呢,不能把这上面的代码一个个拷贝了吧
    //这样,我们可以使用继承,自定义刷新控件然后继承自MJRefreshNormalHeader,这里是自定义下拉刷新
    
//    CommonHeader *header = [CommonHeader headerWithRefreshingBlock:^{
//        
//        
//        //    [self loadData];
//        
//    }];
//    
//    self.tableView.mj_header = header;
    
    //让程序一开始就加载数据
//    [self.tableView.mj_header beginRefreshing];
    
    //同样,自定义上拉刷新
//    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
}


-(void)setUpNav
{
    self.navigationItem.title = @"项目详情";
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 50, 0);
    
    //我们可以往底部添加额外了滚动区域25,那么整体就向上移动了,但是这样底部离tabbar会有一定的间距了,不好看
    //可以修改顶部的间距,让顶部减25就可以了
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0);}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        FinanceDetailFirstCell *cell1 = [tableView dequeueReusableCellWithIdentifier:ID1];
        
        cell1.model = self.modelsArray[indexPath.section];
        
        return cell1;
        
    }else {
        
        
        FinanceDetailSecondCell *cell2 = [tableView dequeueReusableCellWithIdentifier:ID2];
        
        self.cell2 = cell2;
        
        return cell2;

        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell1的高度,注意;需要根据cell空间的高度来设置,这里只是测试,写的是固定值
    if (indexPath.section ==0) {
        
        return 407;
        
    }else if (indexPath.section == 1){
        
        return 487;  //这个返回高度决定下面cell2的滚动范围
    }
    
    return 0;
}

//去除第一个表头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;;
    }else {
        return 30;
    }
   
}

//让表头出现
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else {
        return @"222";
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
  
    
    if (section == 1){
        
        self.headerView = [[UIView alloc] init];
        
        titles = @[@"项目进度",@"投资流程",@"用户评论",@"投资记录"];
        
        [self initializeUI];
        
        self.scrollView.decelerationRate = 1.0;
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
        // 解决scrollView的pan手势和侧滑返回手势冲突
        NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
        
        for (UIGestureRecognizer *gesture in gestureArray) {
            if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
                break;
            }
        }
        
        self.slideBar = [JPSlideNavigationBar slideBarWithObservableScrollView:self.scrollView
                                                                viewController:self
                                                                  frameOriginY:0
                                                           slideBarSliderStyle:JPSlideBarStyleChangeColorOnly];
        
        self.slideBar.backgroundColor = [UIColor whiteColor];
        
        
        [self.headerView addSubview:self.slideBar];
        
        Weak(self); //避免循环引用
        [self.slideBar configureSlideBarWithTitles:titles
                                         titleFont:[UIFont systemFontOfSize:15]
                                         itemSpace:30
                               normalTitleRGBColor:JColor_RGB(0,0,0)
                             selectedTitleRGBColor:JColor_RGB(255,255,255)
                                     selectedBlock:^(NSInteger index) {
                                         Strong(self);
                                         CGFloat scrollX = CGRectGetWidth(self.scrollView.bounds) * index;
                                         [self.scrollView setContentOffset:CGPointMake(scrollX, 0)];
                                     }];
        
        // 可以监听每次翻页的通知。(比如刷新数据)
        [JPNotificationCenter addObserver:self selector:@selector(doSomeThingWhenScrollViewChangePage:) name:JPSlideBarChangePageNotification object:nil];
        
        return self.headerView;
        
    }
    
    return nil;
}


- (void)doSomeThingWhenScrollViewChangePage:(NSNotification *)notification{
    CGFloat offsetX = [notification.userInfo[JPSlideBarScrollViewContentOffsetX] floatValue];
    NSInteger index = [notification.userInfo[JPSlideBarCurrentIndex] integerValue];
    
    JKLog(@"offsetX:%f    index:%ld",offsetX,index);
}

- (void)initializeUI{
    
    //    self.view.backgroundColor = [UIColor whiteColor];
    //    self.navigationItem.title = @"JPSlideBar";
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    [self initializeScrollViewWithStatusBarHeight:(44)];
    
    [self setupScrollViewSubViewsWithNumber:titles.count];
    
    self.scrollView.contentSize = CGSizeMake(titles.count * SSScreenW, 200);
}


- (void)initializeScrollViewWithStatusBarHeight:(CGFloat)statusBarHeight{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SSScreenW, SSScreenH)];
    
    self.scrollView.showsHorizontalScrollIndicator= NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    [self.cell2 addSubview:self.scrollView];
}



- (void)setupScrollViewSubViewsWithNumber:(NSInteger)count{

    
    ProjectDetailViewController * subVC1 = [[ProjectDetailViewController alloc]init];
//    subVC1.view.backgroundColor = [UIColor redColor];
    subVC1.view.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self addChildViewController:subVC1];
    [self.scrollView addSubview:subVC1.view];
    
    ProjectScheduleViewController * subVC2 = [[ProjectScheduleViewController alloc]init];
//    subVC2.view.backgroundColor = [UIColor greenColor];
    subVC2.view.frame = CGRectMake(self.scrollView.bounds.size.width * 1, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self addChildViewController:subVC2];
    [self.scrollView addSubview:subVC2.view];
    
    UserCommentViewController * subVC3 = [[UserCommentViewController alloc]init];
//    subVC3.view.backgroundColor = [UIColor blueColor];
    subVC3.view.frame = CGRectMake(self.scrollView.bounds.size.width * 2, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self addChildViewController:subVC3];
    [self.scrollView addSubview:subVC3.view];
    
    InvestRecordViewController * subVC4 = [[InvestRecordViewController alloc]init];
//     subVC4.view.backgroundColor = [UIColor orangeColor];
    subVC4.view.frame = CGRectMake(self.scrollView.bounds.size.width * 3, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self addChildViewController:subVC4];
    [self.scrollView addSubview:subVC4.view];

}



- (void)dealloc{
    NSLog(@"%@被释放",[self class]);
}

/**********************************  不要删除：根据文字的个数调整 label 的高度
 
 NSString *text =[[NSString alloc]init];
 text = @"输入文本内容";
 CGSize size = CGSizeMake(280, 180);
 UIFont *fonts = [UIFont systemFontOfSize:14.0];
 CGSize msgSie = [text sizeWithFont:fonts constrainedToSize:size lineBreakMode: NSLineBreakByCharWrapping];
 UILabel *textLabel  = [[UILabel alloc] init];
 [textLabel setFont:[UIFont boldSystemFontOfSize:14]];
 textLabel.frame = CGRectMake(20,70, 280,msgSie.height);
 textLabel.text = text;
 textLabel.lineBreakMode = NSLineBreakByCharWrapping;//实现文字多行显示
 textLabel.numberOfLines = 0;
 [self.view addSubview:textLabel];
 ********************************************************/

//加载数据
-(void)loadData
{
    //参数
    NSString *artWorkId = @"qydeyugqqiugd7";
    NSString *currentUserId = @"imhipoyk18s4k52u";
    
    //注意:刷新最新数据的时候,是全部刷新,包括4个tab里面的数据所以应该判断当前tab为哪个选项
    NSString *tab = @"view";
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&currentUserId=%@&tab=%@&timestamp=%@&key=%@",artWorkId,currentUserId,tab,timestamp,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.69:8001/app/investorArtWork.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : artWorkId,
                           @"tab"       : tab,
                           @"currentUserId":currentUserId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        /*
         {"artworkInvestTopList":null,"artworkInvestList":null,
         "artworkAttachmentList":[],
         "artworkCommentList":null,"investNum":0,"resultCode":"0","isPraise":false,"artworkdirection":null,"time":"66日1时2分35秒","resultMsg":"成功",
         "object":{"id":"qydeyugqqiugd7","title":"测试6","brief":"这是一个","description":null,"status":"0","investGoalMoney":1.00,"investStartDatetime":1455005261000,"investEndDatetime":1454314064000,"auctionStartDatetime":1454400455000,"auctionEndDatetime":1462003649000,
         "author":{"id":"icjxkedl0000b6i0","username":"123123","name":"魏立中","pictureUrl":"http://tenant.efeiyi.com/background/蔡水况.jpg","cityId":null,"status":"0","createDatetime":null,"type":"10000",                 "master":
         {"id":"icjxkedl0000b6i0","brief":"版画家，他使得业已消失数百年的明代印刷业老字号十竹斋重新恢复并焕发生机，成为杭州市文化产业传承创新的亮点。","title":"国家级传承人","favicon":"http://tenant.efeiyi.com/background/蔡水况.jpg","birthday":"1968年","level":"1","content":null,"presentAddress":"浙江","backgroundUrl":"background/魏立中.jpg","provinceName":"浙江","theStatus":"1","logoUrl":"logo/魏立中.jpg","masterSpeech":null,"artCategory":null,"titleCertificate":null,"feedback":null,"identityFront":null,"identityBack":null}},
         "createDatetime":1454314046000,"picture_url":"http://tenant.efeiyi.com/background/蔡水况.jpg","step":"31","investsMoney":0,"creationEndDatetime":1458285492000,"type":"3","newCreationDate":null,"auctionNum":null,"newBidingPrice":500.00,"newBiddingDate":null,"sorts":"6","winner":null,"feedback":null,"duration":null,"startingPrice":1000}}
         
         */
        
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        ArtworkModel *models = [ArtworkModel mj_objectWithKeyValues:modelDict];
        
        NSLog(@"%@",models);
        
        NSLog(@"%@",models.artworkAttachmentList.fileName);
        NSLog(@"%@",models.object.author.name);
        
    
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
    }];
}

- (IBAction)dianzan:(id)sender {
    
    
}

- (IBAction)commentBtnClick:(id)sender {
    
    
}

- (IBAction)finanaceBtnClick:(id)sender {
    
    
}


@end

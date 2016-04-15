//
//  FinanceDetailViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceDetailViewController.h"

#import "navTitleButton.h"

#import "ProjectDetailViewController.h"
#import "ProjectScheduleViewController.h"
#import "UserCommentViewController.h"
#import<QuartzCore/QuartzCore.h>


#import <MJExtension.h>

#import "FinanceDetailModel.h"
#import "ArtWorkListModel.h"
#import "authorDetailModel.h"
#import "masterDetailModel.h"

#import "FinanceDetailFirstCell.h"
#import "FinanceDetailSecondCell.h"

#import "UIImageView+WebCache.h"

#import "JPSlideBar.h"
#import "JPBaseTableViewController.h"

#import "FinanceTableViewController.h"

@interface FinanceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView *DxTableView;
    UITableViewCell *cell;
    UIImageView *cellImageView;
    NSArray *_arr;
    
    NSArray * titles;
    
}


/** 标题栏 */
@property (nonatomic, strong) UIView *titlesView;

/** 当前被点中的按钮 */
@property (nonatomic, weak) navTitleButton *clickedTitleButton;

/** 下划线 */
@property (nonatomic, strong) UIView *underlineView;

/** 用来显示所有子控制器view的scrollView */
//@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic,strong)NSArray *arrIndexPath;

@property (nonatomic,strong)UIScrollView *scrollCellView;


/** 存放所有数据(artWorkList)的数组 */
@property (nonatomic, strong) NSMutableArray *models;

/** 存放第一层数据 */
@property (nonatomic, strong) FinanceDetailModel *financeDetailModel;
/** 存放第二层数据(author) */
@property (nonatomic, strong) AuthorDetailModel *authorDetailModel;
/** 存放第三层数据(master) */
@property (nonatomic, strong) MasterDetailModel *masterDetailModel;



/** 项目背景图 */
@property (nonatomic ,strong) NSString *picture_url;


/** 融资目标金额 */
@property (nonatomic ,assign) NSInteger investGoalMoney;

/** 融资开始时间 */
@property (nonatomic ,assign) NSInteger investStartDatetime;
/** 融资结束时间/创作开始时间 */
@property (nonatomic ,assign) NSInteger investEndDatetime;

/** 拍卖开始时间 */
@property (nonatomic ,assign) NSInteger auctionStartDatetime;
/** 拍卖结束时间 */
@property (nonatomic ,assign) NSInteger auctionEndDatetime;




@property (nonatomic ,strong) NSArray *titleArray;

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)JPSlideNavigationBar * slideBar;

//头部视图
@property (nonatomic, strong)UIView *headerView;
//子视图
@property (nonatomic, strong)UIView *subViews;

@property (nonatomic, strong)FinanceDetailSecondCell *cell2;

@end

@implementation FinanceDetailViewController


static NSString *ID1 = @"Cell1";
static NSString *ID2 = @"Cell2";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    self.navigationController.navigationBarHidden = NO;
    
    [self setUpNav];
    
    //    [self loadData];
    
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"FinanceDetailFirstCell" bundle:nil] forCellReuseIdentifier:ID1];
    [self.tableView registerNib:[UINib nibWithNibName:@"FinanceDetailSecondCell" bundle:nil] forCellReuseIdentifier:ID2];
}



-(void)setUpNav
{
    
    
    
    self.navigationItem.title = @"项目详情";
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    if (indexPath.section ==0) {
        
        return 367;
        
    }else if (indexPath.section == 1){
        return 190;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.headerView = [[UIView alloc] init];//我在sectionHeader中建立了一个View
    // view.frame= CGRectMake(0, 0, 320, 30);
    
    if (section == 1){       //这个和上一个一样，我没写全
        
        
        titles = @[@"简书",@"腾讯",@"阿里",@"网易云"];
        
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
                                         titleFont:[UIFont systemFontOfSize:18]
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
    
    [self initializeScrollViewWithStatusBarHeight:(0)];
    
    [self setupScrollViewSubViewsWithNumber:titles.count];
    
    self.scrollView.contentSize = CGSizeMake(titles.count * JPScreen_Width, 200);
}


- (void)initializeScrollViewWithStatusBarHeight:(CGFloat)statusBarHeight{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, JPScreen_Width, JPScreen_Height)];
    
    self.scrollView.showsHorizontalScrollIndicator= NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    [self.cell2 addSubview:self.scrollView];
}



- (void)setupScrollViewSubViewsWithNumber:(NSInteger)count{
    
    
    for (NSInteger index = 0; index < count; index ++) {
        
        JPBaseTableViewController * subVC = [[JPBaseTableViewController alloc]init];
        subVC.dataSourceArray = [titles mutableCopy];
        subVC.view.frame = CGRectMake(self.scrollView.bounds.size.width * index, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        
        [self addChildViewController:subVC];
        [self.scrollView addSubview:subVC.view];
    }
    
    
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



- (void)sj_tap:(UIGestureRecognizer*)sender //注意与平时的不同

{
    NSLog(@"dddddddd");
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else {
        return @"222";
    }
}

//上面的
-(UIView *)sectionView
{
    
    //    for (ArtWorkListModel *artWorkListModel in self.financeDetailModel.artWorkList) {
    //
    //
    //        self.picture_url = artWorkListModel.picture_url;
    //
    //    }
    //
    //    NSLog(@"%@",self.picture_url);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    label.text = @"2324234";
    label.backgroundColor = [UIColor redColor];
    [self.headerView addSubview:label];
    
    return self.headerView;
}

//加载数据
-(void)loadData
{
    //参数
    
    //ibxgyqc000006eb2
    //ieatht97wfw30hfd
    //qydeyugqqiugd7
    NSString *artWorkId = @"qydeyugqqiugd7";
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&timestamp=%@&key=%@",artWorkId,timestamp,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.69:8001/app/investorArtWork.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : artWorkId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        
        //        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        // 字典数组 -> 模型数组
        //        NSArray *moreModels = [FinanceModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        //        // 拼接数据
        //        [self.models addObjectsFromArray:moreModels];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
        
        
    }];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end

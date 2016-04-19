//
//  ViewController.m
//  2.微博个人详情界面
//
//  Created by 王梦思 on 15/10/17.
//  Copyright © 2015年 王梦思. All rights reserved.
//

#import "XiangqingViewController.h"

#import "UIImage+Image.h"

#import "navTitleButton.h"


#import "FinanceTableViewController.h"
#import "CreationTableViewController.h"
#import "AuctionTableViewController.h"


#import "JPSlideBar.h"
#import "JPBaseTableViewController.h"

#import "ProjectDetailViewController.h"
#import "ProjectScheduleViewController.h"
#import "UserCommentViewController.h"
#import "InvestRecordViewController.h"

#import "TopTabControlDefine.h"


@interface XiangqingViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,TopTabControlDataSource>

{
    NSArray * titles;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *titleView;


//1.2 记录原始的偏移量
@property (nonatomic, assign) CGFloat oriOffsetY;

//头部视图(背景view头部y值的约束)的y值
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headYConstraint;

//头部视图(背景view头部高度的约束)的高度值  --视觉差
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeightConstraint;


/** 标题栏 */
@property (nonatomic, strong) UIView *titlesView;

@property (nonatomic, strong)JPSlideNavigationBar * slideBar;

/** 当前被点中的按钮 */
@property (nonatomic, weak) navTitleButton *clickedTitleButton;

/** 下划线 */
@property (nonatomic, strong) UIView *underlineView;

/** 用来显示所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;


/** 底部栏 */
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation XiangqingViewController

static NSString *ID = @"cell";

#define XMGHeadH 236

#define XMGTabBarH 44

#define XMGTabMinH 0

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNav];
    
    [self setupTitlesView];
    
    [self setupBottomView];
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    // 记录下最原始偏移量
    _oriOffsetY = - (XMGHeadH + 64);
    
    
    //默认情况下,在iOS7之后,只要是导航控制器下所有UIScrollView顶部都会添加额外的滚动区域
    //设置导航条不要调节ScrollViewInsets,让tableView顶到屏幕最上面
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //运行程序发现,tableView相对黄色的view应该对齐,所以设置有偏移 - 偏移量为背景图和黄色view的高度 =  200 + 44 = 244
    self.tableView.contentInset = UIEdgeInsetsMake(XMGHeadH + 64 * 2, 0, 0, 0);
}

-(void)setUpNav
{
    self.navigationItem.title = @"项目详情";
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)setupBottomView{
    
    UIView *bottomView = [[UIView alloc] init];
    
    self.bottomView = bottomView;
    
    bottomView.frame = CGRectMake(0, SSScreenH - 44, self.view.width, 44);
    bottomView.backgroundColor = [UIColor blackColor];
    //2.9 设置标题栏为半透明的
    //    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:bottomView];
    
    //2.1 运行程序,发现titlesView添加到了tableView,但是我们这里需要时用不同的UIViewController,所以把之前的控制器UITableViewController改成UIViewController
    
    //2.2 添加所有的标题按钮
    [self setUpBottomButtons];
    
}

-(void)setUpBottomButtons
{
    NSArray *bottomtitles = @[@"点赞", @"评论", @"投资"];
    
    NSInteger index = bottomtitles.count;
    //2.3 设置按钮尺寸,要想拿到titlesView需设置成成员属性
    //    CGFloat titleButtonW = self.titlesView.width / 5;
    CGFloat titleButtonW = self.bottomView.width / index;
    CGFloat titleButtonH = self.bottomView.height;
    
    //2.4 遍历添加所有标题按钮
    for (NSInteger i = 0; i < index; i++) {
        
        navTitleButton *titleButton = [navTitleButton buttonWithType:UIButtonTypeCustom];
        
        //6.2给标题按钮绑定tag
        titleButton.tag= i;
        
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
        //2.5 设置标题按钮的标题
        //因为标题是已知的,所以我们可以把标题保存到数组中,然后根据数组中的索引去一一对应各个按钮的标题
        //这样我们就不会把按钮的个数写死了
        [titleButton setTitle:bottomtitles[i] forState:UIControlStateNormal];
        [titleButton setTintColor:[UIColor whiteColor]];
        
        //2.6 设置按钮的选中状态
        [titleButton addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //        titleButton.titleLabel.backgroundColor = BSRandomColor;
        
        [self.bottomView addSubview:titleButton];
        
    }
}

-(void)bottomClick:(navTitleButton *)titleButton
{
    SSLog(@"1111");
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

//一:监听tableView的滚动,让黄色view伴随着tableView一块移动

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //1.3 记录当前的偏移量
    CGFloat currentOffsetY = scrollView.contentOffset.y; //scrollView.contentOffset.y 能获取scrollView滚动了多少
    
    //1.4 计算当前用户滚动了多少
    CGFloat delta = currentOffsetY - self.oriOffsetY;  //当前的偏移量减去原始的偏移量等于用户实际滚动了多少,刚开始为0---  -244 - (-244) = 0
    
    //    NSLog(@"%f",delta);
    
    //2.修改头部视图(背景view头部高度的约束)的高度值
    
    CGFloat h = XMGHeadH - delta;
    
    if (h < XMGTabMinH) {
        h = 0;
    }
    
    if (h > XMGHeadH) {
        h = XMGHeadH;
    }
    
    self.headHeightConstraint.constant = h;
    //注意:这时候往下拉的功能也实现了,图片超出部分裁剪,头部视图根据滚动范围变化自己的高度
    
    //3.设置导航条图片的渐变显示,即修改导航条图片的alpha 的值
    
    CGFloat alpha = delta / (XMGHeadH - XMGTabMinH);

    if (alpha >= 1) {
        alpha = 0.99;
    }
    UIColor *whiteColor = [UIColor colorWithWhite:1 alpha:alpha];
    
    UIImage *image = [UIImage imageWithColor:whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


-(void)setupTitlesView{


    TopTabControl *tabCtrl = [[TopTabControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    tabCtrl.datasource = self;
    [tabCtrl reloadData];
    tabCtrl.showIndicatorView = YES;
    [self.titleView addSubview:tabCtrl];
}


#pragma mark - TopTabControl Datasource

/**
 *  得到顶部菜单栏的高度
 *
 *  @param tabCtrl tab控件
 *
 *  @return 高度（像素）
 */
- (CGFloat)TopTabHeight:(TopTabControl *)tabCtrl
{
    
    return 44;
}


/**
 *  得到顶部菜单栏的宽度
 *
 *  @param tabCtrl tab控件
 *
 *  @return 高度（像素）
 */
- (CGFloat)TopTabWidth:(TopTabControl *)tabCtrl
{
    return SSScreenW / 4;
}


/**
 *  得到顶部菜单的个数
 *
 *  @param tabCtrl tab控件
 *
 *  @return 返回菜单的个数
 */
- (NSInteger)TopTabMenuCount:(TopTabControl *)tabCtrl
{
    return 4;
}



/**
 *  得到第几个菜单的view
 *
 *  @param tabCtrl tab控件
 *  @param index   菜单的index，从0开始
 *
 *  @return 返回单个菜单项
 */
- (TopTabMenuItem *)TopTabControl:(TopTabControl *)tabCtrl
                      itemAtIndex:(NSUInteger)index
{
    TopTabMenuItem *topItem = [[TopTabMenuItem alloc] initWithFrame:CGRectMake(0, 0, SSScreenW / 4, 44)];
//    topItem.backgroundColor = [UIColor randomColor];
    UILabel *label = [[UILabel alloc] initWithFrame:topItem.bounds];
    
    titles = @[@"项目进度",@"投资流程",@"用户评论",@"投资记录"];
    
//    label.text = [NSString stringWithFormat:@"%ld",index];
    label.text = titles[index];
    label.textAlignment = NSTextAlignmentCenter;
    [topItem addSubview:label];
    return topItem;
}


/**
 *  得到第几个菜单对应的page内容
 *
 *  @param tabCtrl tab控件
 *  @param index   菜单的index，从0开始
 *
 *  @return 返回单个菜单页
 */
- (TopTabPage *)TopTabControl:(TopTabControl *)tabCtrl
                  pageAtIndex:(NSUInteger)index
{
    TopTabPage *page = [[TopTabPage alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    CGRectGetWidth(self.view.frame),
                                                                    CGRectGetHeight(self.view.bounds) - 64 - 30
                                                                    )];
    UILabel *label = [[UILabel alloc] initWithFrame:page.bounds];
    label.text = [NSString stringWithFormat:@"%ld",index];
    label.textAlignment = NSTextAlignmentCenter;
    [page addSubview:label];
    
    return page;
}


@end

//
//  FinanceDetailsViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceDetailsViewController.h"

#import "TYTitlePageTabBar.h"
#import "TableViewController.h"
#import "CollectionViewController.h"

#import "FinanceDetailsHeaderView.h"
#import "navTitleButton.h"


#import "ProjectDetailsViewController.h"

@interface FinanceDetailsViewController ()


@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIButton *pageBarBackBtn;

@property (nonatomic, weak) UIButton *shareBtn;
@property (nonatomic, weak) UIButton *pageBarShareBtn;

@end

@implementation FinanceDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //显示导航条
    self.navigationController.navigationBarHidden = NO;
   
    [self setUpChildVc];
}

//设置tab子控制器
-(void)setUpChildVc{

    ProjectDetailsViewController *projectDetailsVC = [[ProjectDetailsViewController alloc] init];
    
    self.viewControllers = @[projectDetailsVC,[self creatViewControllerPage:1 itemNum:16],[self creatViewControllerPage:2 itemNum:6],[self creatViewControllerPage:3 itemNum:12],[self creatViewControllerPage:0 itemNum:6]];
    
    self.slidePageScrollView.pageTabBarStopOnTopHeight = _isNoHeaderView ? 0 : 64;
    self.slidePageScrollView.headerViewScrollEnable = _isNoHeaderView ? NO : YES;
    
    [self setUpNavBar];
    
    [self addHeaderView];
    
    [self addTabPageMenu];
    
    [self addFooterView];
    
    [self.slidePageScrollView reloadData];
    
}

// 设置导航条
-(void)setUpNavBar
{
    self.navigationItem.title = @"项目名称";
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (_isNoHeaderView) {
        [self.slidePageScrollView scrollToPageIndex:1 animated:NO];
    }
}

//设置头部视图
- (void)addHeaderView
{
    FinanceDetailsHeaderView *headerView = [FinanceDetailsHeaderView financeDetailsHeaderView];
    headerView.frame = CGRectMake(0, 0, SSScreenW, headerView.height);
    
    self.slidePageScrollView.headerView = _isNoHeaderView ? nil : headerView;
}

//设置tab栏
- (void)addTabPageMenu
{
    TYTitlePageTabBar *titlePageTabBar = [[TYTitlePageTabBar alloc]initWithTitleArray:@[@"项目详情", @"投资流程",@"用户评论",@"投资记录"]];
    titlePageTabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), _isNoHeaderView?50:40);
    titlePageTabBar.edgeInset = UIEdgeInsetsMake(_isNoHeaderView?20:0, 50, 0, 50);
    titlePageTabBar.titleSpacing = 10;
    titlePageTabBar.backgroundColor = [UIColor lightGrayColor];
    self.slidePageScrollView.pageTabBar = titlePageTabBar;
    
}

//设置底部按钮
- (void)addFooterView {
    
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), 40)];
//    footerView.backgroundColor = [UIColor orangeColor];
//    UILabel *lable = [[UILabel alloc]initWithFrame:footerView.bounds];
//    lable.textColor = [UIColor whiteColor];
//    lable.text = @"  footerView";
//    [footerView addSubview:lable];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), 44)];
    bottomView.backgroundColor = [UIColor blackColor];
    NSArray *bottomtitles = @[@"点赞", @"评论", @"投资"];
    NSInteger index = bottomtitles.count;
    //设置按钮尺寸,要想拿到titlesView需设置成成员属性
    //    CGFloat titleButtonW = self.titlesView.width / 5;
    CGFloat titleButtonW = bottomView.width / index;
    CGFloat titleButtonH = bottomView.height;
    //遍历添加所有标题按钮
    for (NSInteger i = 0; i < index; i++) {
        navTitleButton *titleButton = [navTitleButton buttonWithType:UIButtonTypeCustom];
        //给标题按钮绑定tag
        titleButton.tag= i;
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        //设置标题按钮的标题
        [titleButton setTitle:bottomtitles[i] forState:UIControlStateNormal];
        [titleButton setTintColor:[UIColor whiteColor]];
        //设置按钮的选中状态
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:titleButton];
    }
    
    self.slidePageScrollView.footerView = bottomView;
}
    
-(void)titleClick:(navTitleButton *)titleButton
{
    SSLog(@"1111");
    
}

- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageTabBarScrollOffset:(CGFloat)offset state:(TYPageTabBarState)state
{
    switch (state) {
        case TYPageTabBarStateStopOnTop:
            
            _backBtn.hidden = YES;
            _pageBarBackBtn.hidden = NO;
            
            _shareBtn.hidden = YES;
            _pageBarShareBtn.hidden = NO;
            break;
        case TYPageTabBarStateStopOnButtom:
            
            break;
        default:
            if (_backBtn.isHidden) {
                _backBtn.hidden = NO;
            }
            if (!_pageBarBackBtn.isHidden) {
                _pageBarBackBtn.hidden = YES;
            }
            
            if (_shareBtn.isHidden) {
                _shareBtn.hidden = NO;
            }
            if (!_pageBarShareBtn.isHidden) {
                _pageBarShareBtn.hidden = YES;
            }
            break;
    }
}

- (void)clickedPageTabBarStopOnTop:(UIButton *)button
{
    button.selected = !button.isSelected;
    self.slidePageScrollView.pageTabBarIsStopOnTop = !button.isSelected;
}

- (void)shareClicked:(UIButton *)button
{
    //[self.slidePageScrollView scrollToPageIndex:(self.slidePageScrollView.curPageIndex+1)%4 animated:YES];
    [self.slidePageScrollView reloadData];
}

//测试子控制器
- (UIViewController *)creatViewControllerPage:(NSInteger)page itemNum:(NSInteger)num
{
    if (page%2 == 0) {
        TableViewController *tableViewVC = [[TableViewController alloc]init];
        tableViewVC.itemNum = num;
        tableViewVC.page = page;
        tableViewVC.isNeedRefresh = YES;
        return tableViewVC;
    }else {
        CollectionViewController *collectVC = [[CollectionViewController alloc]init];
        return collectVC;
    }
}


@end

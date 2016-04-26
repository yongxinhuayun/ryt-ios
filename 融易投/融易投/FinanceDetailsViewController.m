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

@interface FinanceDetailsViewController ()


@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIButton *pageBarBackBtn;

@property (nonatomic, weak) UIButton *shareBtn;
@property (nonatomic, weak) UIButton *pageBarShareBtn;

@end

@implementation FinanceDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.viewControllers = @[[self creatViewControllerPage:0 itemNum:6],[self creatViewControllerPage:1 itemNum:16],[self creatViewControllerPage:2 itemNum:6],[self creatViewControllerPage:3 itemNum:12],[self creatViewControllerPage:0 itemNum:6]];
    
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

- (void)addHeaderView
{
    FinanceDetailsHeaderView *headerView = [FinanceDetailsHeaderView financeDetailsHeaderView];
    headerView.frame = CGRectMake(0, 0, SSScreenW, 277);
    
    self.slidePageScrollView.headerView = _isNoHeaderView ? nil : headerView;
}

- (void)addTabPageMenu
{
    TYTitlePageTabBar *titlePageTabBar = [[TYTitlePageTabBar alloc]initWithTitleArray:@[@"项目详情", @"投资流程",@"用户评论",@"投资记录"]];
    titlePageTabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), _isNoHeaderView?50:40);
    titlePageTabBar.edgeInset = UIEdgeInsetsMake(_isNoHeaderView?20:0, 50, 0, 50);
    titlePageTabBar.titleSpacing = 10;
    titlePageTabBar.backgroundColor = [UIColor lightGrayColor];
    self.slidePageScrollView.pageTabBar = titlePageTabBar;
    
}

- (void)addFooterView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), 40)];
    footerView.backgroundColor = [UIColor orangeColor];
    UILabel *lable = [[UILabel alloc]initWithFrame:footerView.bounds];
    lable.textColor = [UIColor whiteColor];
    lable.text = @"  footerView";
    [footerView addSubview:lable];
    
    self.slidePageScrollView.footerView = footerView;
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

- (void)navGoBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

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

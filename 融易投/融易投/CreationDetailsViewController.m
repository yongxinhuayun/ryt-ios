//
//  CreationDetailsViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CreationDetailsViewController.h"

#import "TYTitlePageTabBar.h"
#import "TableViewController.h"
#import "CollectionViewController.h"

#import "ArtistUserHomeViewController.h"

#import "ArtistUserHeaderView.h"

@interface CreationDetailsViewController ()

@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIButton *pageBarBackBtn;

@property (nonatomic, weak) UIButton *shareBtn;
@property (nonatomic, weak) UIButton *pageBarShareBtn;

@end

@implementation CreationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.viewControllers = @[[self creatViewControllerPage:0 itemNum:6],[self creatViewControllerPage:1 itemNum:16],[self creatViewControllerPage:2 itemNum:6],[self creatViewControllerPage:3 itemNum:12],[self creatViewControllerPage:0 itemNum:6]];
    
    self.slidePageScrollView.pageTabBarStopOnTopHeight = _isNoHeaderView ? 0 : 64;
    self.slidePageScrollView.headerViewScrollEnable = _isNoHeaderView ? NO : YES;
    
//    [self addBackNavButton];
    
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

- (void)addBackNavButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back-hover"] forState:UIControlStateNormal];
    //backBtn.frame = CGRectMake(10, 25, 30, 30);
    [backBtn addTarget:self action:@selector(navGoBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.slidePageScrollView addSubview:backBtn];
    _backBtn = backBtn;
    
    backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.slidePageScrollView addConstraint:[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.slidePageScrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.slidePageScrollView addConstraint:[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.slidePageScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:25]];
    [backBtn addConstraint:[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
    [backBtn addConstraint:[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share-hover"] forState:UIControlStateNormal];
    //shareBtn.frame = CGRectMake(CGRectGetWidth(self.slidePageScrollView.frame)-10-30, 25, 30, 30);
    [shareBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.slidePageScrollView addSubview:shareBtn];
    _shareBtn = shareBtn;
    
    shareBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.slidePageScrollView addConstraint:[NSLayoutConstraint constraintWithItem:shareBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.slidePageScrollView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self.slidePageScrollView addConstraint:[NSLayoutConstraint constraintWithItem:shareBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.slidePageScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:25]];
    [shareBtn addConstraint:[NSLayoutConstraint constraintWithItem:shareBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
    [shareBtn addConstraint:[NSLayoutConstraint constraintWithItem:shareBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:30]];
    
    _backBtn.hidden = _isNoHeaderView;
    _shareBtn.hidden = _isNoHeaderView;
}

- (void)addHeaderView
{
    //    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), 200)];
    //    imageView.image = [UIImage imageNamed:@"headerImage"];
    //
    //    UIButton *label = [UIButton buttonWithType:UIButtonTypeSystem];
    //    label.frame = CGRectMake(10, 75, 100, 30);
    //    [label setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal] ;
    //    [label setTitle:@"Button tap me!" forState:UIControlStateNormal];
    //    [imageView addSubview:label];
    //    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, 320, 30)];
    //    label1.textColor = [UIColor orangeColor];
    //    label1.text = @"pageTabBarStopOnTopHeight 20 ↓↓";
    //    [imageView addSubview:label1];
    //
    //    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 135, 320, 30)];
    //    label2.textColor = [UIColor orangeColor];
    //    label2.text = @"pageTabBarIsStopOnTop YES ↓↓";
    //    [imageView addSubview:label2];
    
    ArtistUserHeaderView *headerView = [ArtistUserHeaderView artistUserHeaderView];
    headerView.frame = CGRectMake(0, 0, SSScreenW, 277);
    
    self.slidePageScrollView.headerView = _isNoHeaderView ? nil : headerView;
}

- (void)addTabPageMenu
{
    TYTitlePageTabBar *titlePageTabBar = [[TYTitlePageTabBar alloc]initWithTitleArray:@[@"主页",@"简介",@"作品",@"投过的",@"赞过的"]];
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

- (void)navGoBack:(UIButton *)button {
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

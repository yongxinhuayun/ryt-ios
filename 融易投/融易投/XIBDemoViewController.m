//
//  XIBDemoViewController.m
//  XCLPageViewDemo
//
//  Created by stone on 16/3/22.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "XIBDemoViewController.h"
#import "DemoTableViewController.h"
#import "XIBHeaderView.h"

#import "XCLPageView.h"
#import "XCLSegmentView.h"
#import "navTitleButton.h"
#import "ProjectDetailsViewController.h"

#import "InvestorArtWorkViewController.h"


@interface XIBDemoViewController () <XCLPageViewDelegate, XCLSegmentViewDelegate>

@property (weak  , nonatomic) IBOutlet XCLPageView *pageView;
@property (strong, nonatomic) XIBHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation XIBDemoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupBottomView];
    
    self.navigationItem.title = @"项目详情";
    
    self.navigationController.navigationBarHidden = NO;

    ProjectDetailsViewController *controller1 = [[ProjectDetailsViewController alloc] init];
    DemoTableViewController *controller2 = [[DemoTableViewController alloc] initWithItemCount:100];
    
    DemoTableViewController *controller3 = [[DemoTableViewController alloc] initWithItemCount:100];
    DemoTableViewController *controller4 = [[DemoTableViewController alloc] initWithItemCount:100];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XIBHeaderView class]) owner:self options:nil] firstObject];
    
    
    [self.headerView.segmentView setTitles:@[@"项目详情", @"投资流程",@"用户评论",@"投资记录"]];
    self.headerView.segmentView.delegate = self;
    self.headerView.segmentView.font = [UIFont systemFontOfSize:14];
    self.headerView.segmentView.normalColor = [UIColor blackColor];
    self.headerView.segmentView.selectedColor = [UIColor blackColor];
    self.headerView.segmentView.indicator.backgroundColor = self.headerView.segmentView.selectedColor;
    self.headerView.segmentView.indicatorEdgeInsets = UIEdgeInsetsMake(self.headerView.segmentView.bounds.size.height - 2, 10, 0, 10);
    self.headerView.segmentView.selectedSegmentIndex = 0;
    
    self.pageView.delegate = self;
    [self.pageView setParentViewController:self childViewControllers:@[controller1, controller2,controller3,controller4]];
    [self.pageView setHeaderView:self.headerView defaultHeight:387 minHeight:self.headerView.segmentView.bounds.size.height];
    [self.pageView setIndex:0];
}

-(void)setupBottomView{
    
    //添加所有的标题按钮
    [self setUpBottomTitleButtons];
    
}


-(void)setUpBottomTitleButtons
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
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //        titleButton.titleLabel.backgroundColor = BSRandomColor;
        
        [self.bottomView addSubview:titleButton];
        
    }
}

-(void)titleClick:(navTitleButton *)titleButton
{
    SSLog(@"1111");
    
}

#pragma mark - XCLSegmentViewDelegate

- (void)segmentView:(XCLSegmentView *)segmentView clickedAtIndex:(NSUInteger)index
{
    [self.pageView setIndex:index];
}

#pragma mark - XCLPageViewDelegate

- (void)pageViewDidScroll:(XCLPageView *)pageView
{
    CGFloat pageWidth = pageView.scrollView.contentSize.width/self.headerView.segmentView.titles.count;
    self.headerView.segmentView.indicatorPosition = pageView.scrollView.contentOffset.x / (pageWidth * (self.headerView.segmentView.titles.count - 1));
}

- (void)pageView:(XCLPageView *)pageView scrollDidEndAtIndex:(NSUInteger)index
{
    self.headerView.segmentView.selectedSegmentIndex = index;
}

@end

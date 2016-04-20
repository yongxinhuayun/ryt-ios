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


@interface XIBDemoViewController () <XCLPageViewDelegate, XCLSegmentViewDelegate>

@property (weak  , nonatomic) IBOutlet XCLPageView *pageView;
@property (strong, nonatomic) XIBHeaderView *headerView;

@end

@implementation XIBDemoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"项目详情";
    
    self.navigationController.navigationBarHidden = NO;

    DemoTableViewController *controller1 = [[DemoTableViewController alloc] initWithItemCount:40];
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

//
//  BaseScrollViewController.m
//  融易投
//
//  Created by dongxin on 16/4/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BaseScrollViewController.h"
#import "TopView.h"
#import "UIView+Frame.h"
#import "CycleView.h"

@interface BaseScrollViewController ()<UIScrollViewDelegate>

@end

@implementation BaseScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.topview];
    [self.backgroundScrollView addSubview:self.middleView];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//懒加载
-(UIView *)topview{
    if (!_topview) {
        _topview = [[UIView alloc] init];
        _topview.backgroundColor = [UIColor redColor];
    }
    return _topview;
}
-(UIView *)middleView{
    if (!_middleView) {
        _middleView = [[UIView alloc] init];
    }
    return _middleView;
}

-(UIScrollView *)backgroundScrollView{
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _backgroundScrollView.backgroundColor = [UIColor whiteColor];
        _backgroundScrollView.bounces = NO;
        _backgroundScrollView.showsVerticalScrollIndicator = NO;
        _backgroundScrollView.delegate = self;
    }
    return _backgroundScrollView;
}

@end

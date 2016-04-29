//
//  BaseScrollViewController.m
//  融易投
//
//  Created by dongxin on 16/4/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BaseScrollViewController.h"

@interface BaseScrollViewController ()

@end

@implementation BaseScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.topView];
    [self.backgroundScrollView addSubview:self.middleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//懒加载
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor redColor];
//        _topView.frame = CGRectMake(0, 0, 375, 100);
    }
    return _topView;
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
    }
    return _backgroundScrollView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

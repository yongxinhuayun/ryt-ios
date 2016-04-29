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

@interface BaseScrollViewController ()

@end

@implementation BaseScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.topview];
    [self.backgroundScrollView addSubview:self.middleView];
    
    
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationItem.title = @"项目名称";
////    self.topview.height = 400;
//    self.middleView.frame = CGRectMake(0, CGRectGetHeight(self.topview.frame), SSScreenW, SSScreenH - CGRectGetMaxY(self.navigationController.navigationBar.frame));
//    self.middleView.backgroundColor = [UIColor blueColor];
//    //    CycleView *cycleView = [[CycleView alloc] initWithFrame:self.middleView.bounds];
//    self.cycleView.frame = self.middleView.bounds;
//    self.cycleView.titleArray = self.titleArray;
//    self.cycleView.controllers = self.controllersView;
//    [self.middleView addSubview:self.cycleView];
//    //添加控制器视图 到scrollView中
//    int count = 0;
//    for(UIView *vi in self.cycleView.controllers){
//        vi.frame = CGRectMake(SSScreenW * count, 0, SSScreenW, self.cycleView.bottomScrollView.frame.size.height);
//        [self.cycleView.bottomScrollView addSubview:vi];
//        count++;
//    }
//    self.backgroundScrollView.contentSize = CGSizeMake(SSScreenW,self.topview.height + self.middleView.height);

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
    }
    return _backgroundScrollView;
}

//-(CycleView *)cycleView{
//    if (!_cycleView) {
//        _cycleView = [[CycleView alloc] init];
//        _cycleView.backgroundColor = [UIColor redColor];
//    }
//    return _cycleView;
//}
//
//-(NSMutableArray *)titleArray{
//    if (!_titleArray) {
//        NSArray *array = @[@"项目进度",@"项目详情",@"用户评论",@"投资记录"];
//        _titleArray = [NSMutableArray arrayWithArray:array];
//    }
//    return _titleArray;
//}
//
//-(NSMutableArray *)controllersView{
//    if (!_controllersView) {
//        _controllersView = [NSMutableArray arrayWithCapacity:self.titleArray.count];
//    }
//    return _controllersView;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

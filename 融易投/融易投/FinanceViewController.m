//
//  FinanceViewController.m
//  融易投
//
//  Created by dongxin on 16/4/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "FinanceViewController.h"
#import "CreationTableViewController.h"
#import "TopView.h"
#import "UIView+Frame.h"
#import "CycleView.h"
@interface FinanceViewController ()

@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"项目名称";
    
    TopView *tView = [[[NSBundle mainBundle] loadNibNamed:@"TopView" owner:nil options:nil] lastObject];
    self.topView.height = tView.height;
    tView.backgroundColor = [UIColor whiteColor];
    tView.width = ScreenWidth;
    [tView.imgView setBackgroundColor:[UIColor whiteColor]];
    [self.topView addSubview:tView];
    NSLog(@"tView的高度%f",tView.height);
    
    self.middleView.frame = CGRectMake(0, CGRectGetHeight(tView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    self.middleView.backgroundColor = [UIColor blueColor];
    CycleView *cycleView = [[CycleView alloc] initWithFrame:self.middleView.bounds];
    NSArray *array = @[@"项目进度",@"项目详情",@"用户评论",@"投资记录"];
    cycleView.titleArray = array;
    cycleView.backgroundColor = [UIColor redColor];
    CreationTableViewController *vc1 = [[CreationTableViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    UIViewController *vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor orangeColor];
    UIViewController *vc3 = [[UIViewController alloc]init];
    vc3.view.backgroundColor = [UIColor blueColor];
    UIViewController *vc4 = [[UIViewController alloc]init];
    vc4.view.backgroundColor = [UIColor lightGrayColor];
    NSArray *arr = @[vc1.view,vc2.view,vc3.view,vc4.view];
    cycleView.controllers = arr;
    [self.middleView addSubview:cycleView];
    //添加控制器视图 到scrollView中
    
    int count = 0;
    for(UIView *vi in arr){
        vi.frame = CGRectMake(ScreenWidth * count, 0, ScreenWidth, cycleView.bottomScrollView.frame.size.height);
        [cycleView.bottomScrollView addSubview:vi];
        count++;
    }
//    for (int i = 0; i < arr.count; i++) {
//        if (i == 0) {
//            vc1.view.frame = CGRectMake(0, 0, ScreenWidth, cycleView.bottomScrollView.frame.size.height);
//            [cycleView.bottomScrollView addSubview:vc1.view];
//        }else if (i == 1){
//            vc2.view.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, cycleView.bottomScrollView.frame.size.height);
//            [cycleView.bottomScrollView addSubview:vc2.view];
//        }else if (i == 2){
//            vc3.view.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, cycleView.bottomScrollView.frame.size.height);
//            [cycleView.bottomScrollView addSubview:vc3.view];
//        }else{
//            vc4.view.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, cycleView.bottomScrollView.frame.size.height);
//            [cycleView.bottomScrollView addSubview:vc4.view];
//        }
//    }
    self.backgroundScrollView.contentSize = CGSizeMake(ScreenWidth,self.topView.height + self.middleView.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

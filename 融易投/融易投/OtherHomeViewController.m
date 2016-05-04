//
//  MyHomeViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "OtherHomeViewController.h"

#import "TopView.h"
#import "CycleView.h"
#import "OtherHeaderView.h"

#import "TouGuoViewController.h"
#import "ZanGuoViewController.h"

@interface OtherHomeViewController ()

@end

@implementation OtherHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self setupUI];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];

}

-(void)setupUI{

    OtherHeaderView *tView = [[[NSBundle mainBundle] loadNibNamed:@"OtherHeaderView" owner:nil options:nil] lastObject];
    self.topview.height = tView.height;
    tView.backgroundColor = [UIColor whiteColor];
    tView.width = SSScreenW;
    //    [tView.imgView setBackgroundColor:[UIColor whiteColor]];
    
    [self.topview addSubview:tView];
    self.middleView.frame = CGRectMake(0, CGRectGetHeight(self.topview.frame), SSScreenW, SSScreenH - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    self.middleView.backgroundColor = [UIColor blueColor];
    //    CycleView *cycleView = [[CycleView alloc] initWithFrame:self.middleView.bounds];
    self.cycleView.frame = self.middleView.bounds;
    self.cycleView.titleArray = self.titleArray;
    
    
    //添加控制器view
    [self addControllersToCycleView];
    [self.middleView addSubview:self.cycleView];
    //添加控制器视图 到scrollView中
    self.backgroundScrollView.contentSize = CGSizeMake(SSScreenW,self.topview.height + self.middleView.height);

}

-(void)addControllersToCycleView{
    
    //添加控制器view
    TouGuoViewController *record1 = [[TouGuoViewController alloc] init];
    [self.controllersView addObject:record1.view];
    [self addChildViewController:record1];

    ZanGuoViewController * record2 = [[ZanGuoViewController alloc] init];
    [self.controllersView addObject:record2.view];
    [self addChildViewController:record2];

//    ProjectDetailsViewController *pro = [[ProjectDetailsViewController alloc] init];
//    [self.controllersView addObject:pro.view];
//    [self addChildViewController:pro];
//
//    ProjectDetailTableViewController * pro1 = [[ProjectDetailTableViewController alloc] init];
//    [self.controllersView addObject:pro1.view];
//    [self addChildViewController:pro1];
    
    self.cycleView.controllers = self.controllersView;
    
    int count = 0;
    for(UIView *vi in self.cycleView.controllers){
        vi.frame = CGRectMake(SSScreenW * count, 0, SSScreenW, self.cycleView.bottomScrollView.frame.size.height);
        [self.cycleView.bottomScrollView addSubview:vi];
        count++;
    }
    
    
}

-(CycleView *)cycleView{
    if (!_cycleView) {
        _cycleView = [[CycleView alloc] init];
        _cycleView.backgroundColor = [UIColor redColor];
    }
    return _cycleView;
}

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        NSArray *array = @[@"投过的",@"赞过的",@"简介"];
        _titleArray = [NSMutableArray arrayWithArray:array];
    }
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray *)controllersView{
    if (!_controllersView) {
        _controllersView = [NSMutableArray arrayWithCapacity:self.titleArray.count];
    }
    return _controllersView;
}
@end

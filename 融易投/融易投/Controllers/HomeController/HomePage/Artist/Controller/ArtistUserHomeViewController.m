//
//  MyHomeViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistUserHomeViewController.h"

#import "TopView.h"
#import "CycleView.h"
#import "CommonUserHeaderView.h"

#import "TouGuoViewController.h"
#import "ZanGuoViewController.h"
#import "JianjieViewController.h"
#import "ArtistWorksViewController.h"
#import "ArtistMainViewController.h"

#import "PageInfoModel.h"

@interface ArtistUserHomeViewController ()

@end

@implementation ArtistUserHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setupUI];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
}

-(void)setupUI{
    
    CommonUserHeaderView *tView = [[[NSBundle mainBundle] loadNibNamed:@"CommonUserHeaderView" owner:nil options:nil] lastObject];
    //    if (tView.otherView.hidden) {
    //        self.topview.height = tView.height - 26;
    //    }
    
    tView.model = self.model;
    
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
    ArtistMainViewController *record1 = [[ArtistMainViewController alloc] init];
    record1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record1.view];
    [self addChildViewController:record1];
    
    JianjieViewController *record2 = [[JianjieViewController alloc] init];
    [self.controllersView addObject:record2.view];
    [self addChildViewController:record2];
    
    ArtistWorksViewController *record3 = [[ArtistWorksViewController alloc] init];
    record3.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record3.view];
    [self addChildViewController:record3];
    
    TouGuoViewController *record4 = [[TouGuoViewController alloc] init];
    record4.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record4.view];
    [self addChildViewController:record4];
    
    ZanGuoViewController *record5 = [[ZanGuoViewController alloc] init];
    record5.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record5.view];
    [self addChildViewController:record5];
    
   
    
    
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
        NSArray *array = @[@"主页",@"简介",@"作品",@"投过的",@"赞过的"];
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

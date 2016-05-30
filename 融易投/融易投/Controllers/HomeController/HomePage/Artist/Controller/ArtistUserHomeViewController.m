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
#import <MJExtension.h>

@interface ArtistUserHomeViewController ()<CommonUserHeaderViewDelegate>

@property (nonatomic ,strong)PageInfoModel *model;

@end

@implementation ArtistUserHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self loadNewData];
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
    tView.delegate = self;
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


-(void)loadNewData
{
    //参数
    UserMyModel *model = TakeLoginUserModel;
    NSString *currentId = model.ID;
    
    NSString *userId = self.userId;
    
    
    SSLog(@"%@",currentId);
    SSLog(@"%@",userId);
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    
    NSString *url = @"my.do";
    
    NSDictionary *json = @{
                           @"userId":userId,
                           @"currentId":currentId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex
                           };
    
    // 创建一个组
    dispatch_group_t group = dispatch_group_create();
    
    // 添加当前操作到组中
    dispatch_group_enter(group);
    
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        PageInfoModel *model = [PageInfoModel mj_objectWithKeyValues:modelDict[@"pageInfo"]];
        
        self.model = model;
        
        //// 从组中移除一个操作
        dispatch_group_leave(group);
    }];
    
    /// 当所有添加到组中的操作都被移除之后就会调用
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        
        // 6.回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"更新UI %@", [NSThread currentThread]);
            
            [self setupUI];
        });
    });
    
}

-(void)addControllersToCycleView{
    
    //添加控制器view
    ArtistMainViewController *record1 = [[ArtistMainViewController alloc] init];
    record1.userId = self.userId;
    record1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record1.view];
    [self addChildViewController:record1];
    
    JianjieViewController *record2 = [[JianjieViewController alloc] init];
    record2.userModel = self.model;
    record2.userId = self.userId;
    [self.controllersView addObject:record2.view];
    [self addChildViewController:record2];
    
    ArtistWorksViewController *record3 = [[ArtistWorksViewController alloc] init];
    record3.userModel = self.model;
    record3.userId = self.userId;
    record3.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record3.view];
    [self addChildViewController:record3];
    
    TouGuoViewController *record4 = [[TouGuoViewController alloc] init];
    record4.topHeight = self.topview.height - 64;
    record4.userId = self.userId;
    [self.controllersView addObject:record4.view];
    [self addChildViewController:record4];
    
    ZanGuoViewController *record5 = [[ZanGuoViewController alloc] init];
    record5.topHeight = self.topview.height - 64;
    record5.userId = self.userId;
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

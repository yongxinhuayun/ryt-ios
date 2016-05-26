//
//  MyHomeViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonUserHomeViewController.h"

#import "TopView.h"
#import "CycleView.h"
#import "CommonUserHeaderView.h"

#import "TouGuoViewController.h"
#import "ZanGuoViewController.h"
#import "JianjieViewController.h"
#import "PrivateLetterViewController.h"

#import "PageInfoModel.h"

@interface CommonUserHomeViewController ()<CommonUserHeaderViewDelegate>

@end

@implementation CommonUserHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self setupUI];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = self.model.user.name;
}

-(void)setupUI{

    CommonUserHeaderView *tView = [[[NSBundle mainBundle] loadNibNamed:@"CommonUserHeaderView" owner:nil options:nil] lastObject];
//    if (tView.otherView.hidden) {
//        self.topview.height = tView.height - 26;
//    }
    tView.delegate = self;
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


-(void)postPrivateLetter{
    // 拿到当前用户的ID，如果为空，提醒用户进行登录
    RYTLoginManager *manager = [RYTLoginManager shareInstance] ;
    if (![manager showLoginViewIfNeed]) {
        //用户登录成功，获取用户的ID
        // targetUserId : 私信接受者,当前被查看的用户
        // fromUserId : 私信发送者,当前登录的用户
        NSString *fromUserId = [manager takeUser].ID;
        NSString *targetUserId = self.model.user.ID;
        //
        PrivateLetterViewController *letterController = [[PrivateLetterViewController alloc] init];
        letterController.fromUserId = fromUserId;
        letterController.userId = targetUserId;
        [self.navigationController pushViewController:letterController animated:YES];
    }
}

-(void)addConcern{

}

-(void)guanzhuBtnClick:(UIButton *)btn{
    
    SSLog(@"guanzhuBtnClick");
    
    btn.selected = !btn.selected;
    
    
    NSString *currentUserId = @"";
    //        NSString *artWorkId = cellModel.ID;
    NSString *artWorkId = @"imyt7yax314lpzzj";
    
    
    NSString *urlStr = @"investorArtWorkView.do";
    NSDictionary *json = @{
                           @"artWorkId" : artWorkId,
                           @"currentUserId": currentUserId,
                           };
    
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        
        //            NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //            NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
//        ProjectDetailsModel *project = [ProjectDetailsModel mj_objectWithKeyValues:modelDict[@"object"]];
        
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            

        }];
    }];
}

-(void)addControllersToCycleView{
    
    //添加控制器view
    TouGuoViewController *record1 = [[TouGuoViewController alloc] init];
    record1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record1.view];
    [self addChildViewController:record1];

    ZanGuoViewController *record2 = [[ZanGuoViewController alloc] init];
     record2.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record2.view];
    [self addChildViewController:record2];

    JianjieViewController *record3 = [[JianjieViewController alloc] init];
    record3.userModel = self.model;
    [self.controllersView addObject:record3.view];
    [self addChildViewController:record3];

    
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

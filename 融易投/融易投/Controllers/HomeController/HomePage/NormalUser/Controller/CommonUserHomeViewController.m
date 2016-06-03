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
#import "EditingInfoViewController.h"
#import "FocusMyViewController.h"
#import "FansMyViewController.h"
#import <MJExtension.h>

#import "PageInfoModel.h"
#import "MeHeaderView.h"

@interface CommonUserHomeViewController ()<CommonUserHeaderViewDelegate>

@property (nonatomic ,strong)PageInfoModel *model;
@property (nonatomic,strong)CommonUserHeaderView *HeaderView;
@property (strong, nonatomic) MeHeaderView *meheaderView;

@end

@implementation CommonUserHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self loadNewData];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(void)setupUI{

    if (![[[RYTLoginManager shareInstance] takeUser].ID isEqualToString:self.model.user.ID]) {
        CommonUserHeaderView *tView = [[[NSBundle mainBundle] loadNibNamed:@"CommonUserHeaderView" owner:nil options:nil] lastObject];
        tView.delegate = self;
        tView.model = self.model;
        self.HeaderView = tView;
        self.topview.height = tView.height;
        self.topview.width = SSScreenW;
        tView.backgroundColor = [UIColor whiteColor];
        tView.width = SSScreenW;
        [self jumpFansVc];
        [self jumpFocusVc];
        [self.topview addSubview:tView];
    }else{
        MeHeaderView *tView = [[[NSBundle mainBundle] loadNibNamed:@"MeHeaderView" owner:nil options:nil] lastObject];
        tView.model = self.model;
        self.topview.height = tView.height;
        self.topview.width = SSScreenW;
        tView.backgroundColor = [UIColor whiteColor];
        tView.width = SSScreenW;
        self.meheaderView = tView;
        [self jumpFansVc];
        [self jumpFocusVc];
        [self jumpeditingInfoVc];
        [self.topview addSubview:tView];
    }

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

-(void)jumpeditingInfoVc{
    
    __weak CommonUserHomeViewController *weakself = self;
    
    self.meheaderView.editingInfoBlcok = ^{
        
        RYTLoginManager *manger = [RYTLoginManager shareInstance];
        
        if ([manger isVisitor]) {
            
            [manger showLoginViewIfNeed];
            
            return;
        }
        
        UIStoryboard *editingInfoStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([EditingInfoViewController class]) bundle:nil];
        EditingInfoViewController *editingInfoVC = [editingInfoStoryBoard instantiateInitialViewController];
        
        editingInfoVC.userModel = weakself.model;
        
        [weakself.navigationController pushViewController:editingInfoVC animated:YES];
    };
}

-(void)jumpFocusVc{
    
    __weak CommonUserHomeViewController *weakself=self;
    
    self.meheaderView.focusBlcok = ^{
        
        RYTLoginManager *manger = [RYTLoginManager shareInstance];
        
        if ([manger isVisitor]) {
            
            [manger showLoginViewIfNeed];
            
            return;
        }
        
        if ([[[RYTLoginManager shareInstance] takeUser].ID isEqualToString:weakself.userId]) {
            
            //从我的跳过去的userId就是当前登录的用户
            FocusMyViewController *focusVC = [[FocusMyViewController alloc] init];
            UserMyModel *model = TakeLoginUserModel;
            focusVC.userId =  model.ID;
            [weakself.navigationController pushViewController:focusVC animated:YES];
            
        }else{
            
            //从其他用户跳过去
            FocusMyViewController *focusVC = [[FocusMyViewController alloc] init];
            focusVC.userId =  weakself.userId;
            [weakself.navigationController pushViewController:focusVC animated:YES];
            
        }
    };
    
    self.HeaderView.focusBlcok = ^{
        
        RYTLoginManager *manger = [RYTLoginManager shareInstance];
        
        if ([manger isVisitor]) {
            
            [manger showLoginViewIfNeed];
            
            return;
        }
        
        if ([[[RYTLoginManager shareInstance] takeUser].ID isEqualToString:weakself.userId]) {
            
            //从我的跳过去的userId就是当前登录的用户
            FocusMyViewController *focusVC = [[FocusMyViewController alloc] init];
            UserMyModel *model = TakeLoginUserModel;
            focusVC.userId =  model.ID;
            [weakself.navigationController pushViewController:focusVC animated:YES];
            
        }else{
            
            //从其他用户跳过去
            FocusMyViewController *focusVC = [[FocusMyViewController alloc] init];
            focusVC.userId =  weakself.userId;
            [weakself.navigationController pushViewController:focusVC animated:YES];
            
        }
    };
    
}

-(void)jumpFansVc{
    
    __weak CommonUserHomeViewController *weakself= self;
    
    self.meheaderView.fansBlcok = ^{
        
        RYTLoginManager *manger = [RYTLoginManager shareInstance];
        
        if ([manger isVisitor]) {
            
            [manger showLoginViewIfNeed];
            
            return;
        }
        
        if ([[[RYTLoginManager shareInstance] takeUser].ID isEqualToString:weakself.userId]) {
            
            //从我的跳过去的userId就是当前登录的用户
            FansMyViewController *fansVC = [[FansMyViewController alloc] init];
            UserMyModel *model = TakeLoginUserModel;
            fansVC.userId =  model.ID;
            [weakself.navigationController pushViewController:fansVC animated:YES];
            
        }else{
            
            //从其他用户跳过去
             FansMyViewController *fansVC = [[FansMyViewController alloc] init];
            fansVC.userId =  weakself.userId;
            [weakself.navigationController pushViewController:fansVC animated:YES];
            
        }
    };
    
    self.HeaderView.fansBlcok = ^{
        
        RYTLoginManager *manger = [RYTLoginManager shareInstance];
        
        if ([manger isVisitor]) {
            
            [manger showLoginViewIfNeed];
            
            return;
        }
        
        if ([[[RYTLoginManager shareInstance] takeUser].ID isEqualToString:weakself.userId]) {
            
            //从我的跳过去的userId就是当前登录的用户
            FansMyViewController *fansVC = [[FansMyViewController alloc] init];
            UserMyModel *model = TakeLoginUserModel;
            fansVC.userId =  model.ID;
            [weakself.navigationController pushViewController:fansVC animated:YES];
            
        }else{
            
            ///从其他用户跳过去
            FansMyViewController *fansVC = [[FansMyViewController alloc] init];
            fansVC.userId =  weakself.userId;
            [weakself.navigationController pushViewController:fansVC animated:YES];
            
        }
    };
    
}

-(void)loadNewData{
    //参数
    UserMyModel *model = [[RYTLoginManager shareInstance] takeUser];
    NSString *currentId = model.ID;
    NSString *userId = self.userId;
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

-(void)postPrivateLetter{
    // 拿到当前用户的ID，如果为空，提醒用户进行登录
    RYTLoginManager *manager = [RYTLoginManager shareInstance];
    if (![manager showLoginViewIfNeed]) {
        //用户登录成功，获取用户的ID
        // targetUserId : 私信接受者,当前被查看的用户
        // fromUserId : 私信发送者,当前登录的用户
        NSString *fromUserId = self.model.user.ID;
        NSString *targetUserId = [manager takeUser].ID;
        if (![fromUserId isEqualToString:targetUserId]){
            
            PrivateLetterViewController *letterController = [[PrivateLetterViewController alloc] init];
            letterController.fromUserId = fromUserId;
            letterController.userId = targetUserId;
            [self.navigationController pushViewController:letterController animated:YES];
        }
    }
}

// 添加关注
-(void)addConcern{
    //判断当前用户是否登录
    RYTLoginManager *manager = [RYTLoginManager shareInstance];
    if (![manager showLoginViewIfNeed]) {
        
        // 如果用户登录了，获取当前用户的ID
        NSString *userId = [manager takeUser].ID;
        // 获取当前将要被关注的用户ID
        NSString *followId = self.model.user.ID;
        
//        NSString *identifier 0 为关注，1 为取消关注
        NSString *identifier = self.model.followed ? @"1" : @"0";
        
        // followType 1:普通用户 2:艺术家
        NSString *followType = self.model.user.master ? @"2" : @"1";
        NSDictionary *json = [ NSDictionary dictionary];
        if (![userId isEqualToString:followId]) {
            
            json = @{
                     @"userId" : userId,
                     @"followId" : followId,
                     @"identifier" :identifier,
                     @"followType" : followType,
                     };
            
            [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"changeFollowStatus.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
                NSString *str = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
                NSLog(@"%@",str);
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
                NSString *resultCode = result[@"resultCode"];
                if ([resultCode isEqualToString:@"0"]) {
                    self.HeaderView.focusBtn.selected = !self.HeaderView.focusBtn.selected;
                    NSString *flag = result[@"flag"];
                    self.model.followed = [flag isEqualToString:@"1"] ? YES : NO;
                }
            }];
        }
    }
}

-(void)addControllersToCycleView{
    
    //添加控制器view
    TouGuoViewController *record1 = [[TouGuoViewController alloc] init];
    record1.topHeight = self.topview.height - 64;
    record1.model = self.model;
    record1.userId = self.userId;
    
    SSLog(@"%@",self.userId);
    
    [self.controllersView addObject:record1.view];
    [self addChildViewController:record1];

    ZanGuoViewController *record2 = [[ZanGuoViewController alloc] init];
     record2.topHeight = self.topview.height - 64;
    record2.userId = self.userId;
    SSLog(@"%@",self.userId);
    [self.controllersView addObject:record2.view];
    [self addChildViewController:record2];

    JianjieViewController *record3 = [[JianjieViewController alloc] init];
    record3.userModel = self.model;
    record3.userId = self.userId;
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

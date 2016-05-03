//
//  MeViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MeViewController.h"

#import "LognController.h"
#import "RegViewController.h"
#import "ForgetPasswordViewController.h"
#import "CompleteUserInfoController.h"

#import "SettingTableViewController.h"

#import <WechatShortVideoController.h>

#import "ReleaseProjectViewController.h"

#import "ArtistViewController.h"

#import "ApplyforArtViewController.h"


#import "EditingInfoViewController.h"

#import "ArtistMyViewController.h"

#import "WalletViewController.h"

#import "IdeaRetroactionViewController.h"

#import "ReleaseViewController.h"

#import "FocusMyViewController.h"

#import "MeHeaderView.h"



#import "OtherHomeViewController.h"

@interface MeViewController ()


@property (strong, nonatomic) MeHeaderView *meheaderView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   
    //设置导航条
    [self setUpNavBar];
    
    
    //设置头部视图
    MeHeaderView *meheaderView = [MeHeaderView meHeaderView];
    self.meheaderView = meheaderView;
    self.tableView.tableHeaderView = meheaderView;
    
    //点击头像跳转编辑资料视图
    [self jumpeditingInfoVc];
    
    //点击关注跳转关注视图
    [self jumpFocusVc];
    
    //点击跳转粉丝界面
    [self jumpFansVc];
}

-(void)jumpeditingInfoVc{
    
    __weak MeViewController *weakself=self;
    
    self.meheaderView.editingInfoBlcok = ^{
        
        UIStoryboard *editingInfoStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([EditingInfoViewController class]) bundle:nil];
        EditingInfoViewController *editingInfoVC = [editingInfoStoryBoard instantiateInitialViewController];
        
        [weakself.navigationController pushViewController:editingInfoVC animated:YES];
        
    };
    
}

-(void)jumpFocusVc{
    
    __weak MeViewController *weakself=self;
    
    self.meheaderView.focusBlcok = ^{
        
        FocusMyViewController *focusVC = [[FocusMyViewController alloc] init];
        
        [weakself.navigationController pushViewController:focusVC animated:YES];
        
    };
    
}

-(void)jumpFansVc{
    
    __weak MeViewController *weakself=self;
    
    self.meheaderView.fansBlcok = ^{
        
//        FocusViewController *focusVC = [[FocusViewController alloc] init];
//        [weakself.navigationController pushViewController:focusVC animated:YES];
        
    };
    
}



// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"我的";
    
    //设置导航条按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [leftButton setTitle:@"申请为艺术家" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [leftButton sizeToFit];
    
    [leftButton addTarget:self action:@selector(applyforArt) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)applyforArt{
    
    ApplyforArtViewController *applyforArt = [[ApplyforArtViewController alloc] init];
    
    [self.navigationController pushViewController:applyforArt animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) { //第0组
        cell.imageView.image = [UIImage imageNamed:@"wodezhuye"];
        cell.textLabel.text = @"我的主页";
        
    }else if (indexPath.row == 1){
        
        cell.imageView.image = [UIImage imageNamed:@"qianbao"];
        cell.textLabel.text = @"钱包";
        
    }else if (indexPath.row == 2){
        
        cell.imageView.image = [UIImage imageNamed:@"paimaipaihang"];
        cell.textLabel.text = @"拍卖订单";
        
    }else if (indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"shezhi"];
        cell.textLabel.text = @"设置";
    }else if (indexPath.row == 4){
        
        cell.imageView.image = [UIImage imageNamed:@"yijianfankui"];
        cell.textLabel.text = @"意见反馈";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) { //第0组
        
//        ArtistViewController *artistVC = [[ArtistViewController alloc] init];
//        [self.navigationController pushViewController:artistVC animated:YES];
        
        OtherHomeViewController *myHomeVC = [[OtherHomeViewController alloc] init];
        [self.navigationController pushViewController:myHomeVC animated:YES];
        
        
    }else if (indexPath.row == 1){
        
        UIStoryboard *walletStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([WalletViewController class]) bundle:nil];
        WalletViewController *walletVC = [walletStoryBoard instantiateInitialViewController];
        [self.navigationController pushViewController:walletVC animated:YES];
        
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 3){
        
        
        UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([SettingTableViewController class]) bundle:nil];
        SettingTableViewController *settingVC = [settingStoryBoard instantiateInitialViewController];
        [self.navigationController pushViewController:settingVC animated:YES];
        
        //    SettingTableViewController *settingVC = [[SettingTableViewController alloc] init];
        //    [self.navigationController pushViewController:settingVC animated:YES];
        
        
    }else if (indexPath.row == 4){
        
        IdeaRetroactionViewController *ideaRetroactionVC = [[IdeaRetroactionViewController alloc] init];
        [self.navigationController pushViewController:ideaRetroactionVC animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 49;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

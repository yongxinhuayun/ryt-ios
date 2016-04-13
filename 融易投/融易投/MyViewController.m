//
//  MyViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MyViewController.h"

#import "LognController.h"
#import "RegViewController.h"
#import "ForgetPasswordViewController.h"
#import "CompleteUserInfoController.h"

#import "SettingTableViewController.h"

#import <WechatShortVideoController.h>

#import "ReleaseProjectViewController.h"

#import "ArtistViewController.h"


//#import "WeiXinController.h"
//#import "ALiController.h"

@interface MyViewController () <WechatShortVideoDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *subTableView;



@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航条
    [self setUpNavBar];
    
    //设置详细视图
    [self setUpTableView];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"我的";
    
//    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(settting)];
    
//    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    //运行程序,发现点击还是不能实现保持选中状态
    // 按钮达到选中状态,必须通过代码实现,所以我们在按钮的点击方法中进行设置
    
    
//    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
}

-(void)setUpTableView{

    self.subTableView.scrollEnabled = NO;
    
    self.subTableView.dataSource = self;
    self.subTableView.delegate = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) { //第0组
       
            cell.textLabel.text = @"我的主页";

    }else if (indexPath.section == 1){
    cell.textLabel.text = @"钱包";
    }else if (indexPath.section == 2){
        cell.textLabel.text = @"拍卖订单";
    }else if (indexPath.section == 3){
        cell.textLabel.text = @"设置";
    }else if (indexPath.section == 4){
        cell.textLabel.text = @"意见反馈";
    }
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) { //第0组
        

        
    }else if (indexPath.section == 1){

    }else if (indexPath.section == 2){

    }else if (indexPath.section == 3){
        
        
        UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([SettingTableViewController class]) bundle:nil];
        SettingTableViewController *settingVC = [settingStoryBoard instantiateInitialViewController];
        [self.navigationController pushViewController:settingVC animated:YES];
        
        //    SettingTableViewController *settingVC = [[SettingTableViewController alloc] init];
        //    [self.navigationController pushViewController:settingVC animated:YES];


    }else if (indexPath.section == 4){

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;//section头部高度
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)loginBtnClick:(id)sender {
    
    LognController *login = [[LognController alloc] init];
    
    [self.navigationController pushViewController:login animated:YES];
}


- (IBAction)CompleteUserInfoBtnClick:(id)sender {
    
    CompleteUserInfoController *userInfo  = [[CompleteUserInfoController alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
}


- (IBAction)WeiXinPayBtnThings:(id)sender {
//    WeiXinController *weiXinController = [[WeiXinController alloc]init];
//    [self.navigationController pushViewController:weiXinController animated:YES];
}

- (IBAction)ALiPayBtnThings:(id)sender {
//    ALiController *aLiPayController = [[ALiController alloc]init];
//    [self.navigationController pushViewController:aLiPayController animated:YES];
}

- (IBAction)shortVideo:(id)sender {
    
    WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
    wechatShortVideoController.delegate = self;
    [self presentViewController:wechatShortVideoController animated:YES completion:^{}];

}
- (IBAction)releaseProject:(id)sender {

    // 弹出发微博控制器
    ReleaseProjectViewController *releaseProject = [[ReleaseProjectViewController alloc] init];
   
    [self.navigationController pushViewController:releaseProject animated:YES];

}
- (IBAction)artistBtnClick:(id)sender {
    
    // 弹出发微博控制器
    ArtistViewController *releaseProject = [[ArtistViewController alloc] init];
    
    [self.navigationController pushViewController:releaseProject animated:YES];
}

@end

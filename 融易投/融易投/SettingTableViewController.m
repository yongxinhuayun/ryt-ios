//
//  SettingTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "SettingTableViewController.h"

#import "UIImageView+WebCache.h"

#import "NSObject+FileManager.h"

#import <SVProgressHUD/SVProgressHUD.h>

#import "SettingFooterView.h"

#import "RYTLoginManager.h"

@interface SettingTableViewController ()

/** 缓存尺寸*/
@property(nonatomic ,assign) NSInteger total;

@property (weak, nonatomic) IBOutlet UILabel *cachesTotalLabel;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    [SVProgressHUD showWithStatus:@"正在计算缓存尺寸..."];
    
    // 获取cachePath文件缓存
    [self getFileCacheSizeWithPath:self.cachePath completion:^(NSInteger total) {
        
        _total = total;
        
        [SVProgressHUD dismiss];
        
        self.cachesTotalLabel.text = [self getSizeStr];
        
        // 计算完成就会调用
        [self.tableView reloadData];
        
    }];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"设置";
}


- (NSString *)getSizeStr
{
    NSString *cacheStr = @"";
    if (_total) {
        CGFloat totalF = _total;
        NSString *unit = @"B";
        if (_total > 1000 * 1000) { // MB
            totalF = _total / 1000.0 / 1000.0;
            unit = @"MB";
        }else if (_total > 1000){ // KB
            unit = @"KB";
            totalF = _total / 1000.0 ;
        }
        
//        cacheStr = [NSString stringWithFormat:@"%@(%.1f%@)",cacheStr,totalF,unit];
        cacheStr = [NSString stringWithFormat:@"%.1f%@",totalF,unit];
    }
    
    return cacheStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        
        
    } else if (indexPath.section == 1) {
        
        
        
    } else if (indexPath.section == 2) {
        
        [SVProgressHUD showWithStatus:@"正在删除..."];
        
        // 清空缓存,就是把Cache文件夹直接删掉
        // 删除比较耗时
        [self removeCacheWithCompletion:^{
            
            _total = 0;
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
            
            self.cachesTotalLabel.text = @"";
            
        }];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    SettingFooterView *footerView = [SettingFooterView settingFooterView];
    
    [footerView.tuiChuBtn addTarget:self action:@selector(tuiChuLogn) forControlEvents:UIControlEventTouchUpInside];

    if (section == 2) {
        
        return footerView;
        
    }else{

        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 2) {
        return 92;
    }
    
    return 0;
}

-(void)tuiChuLogn{

    SSLog(@"退出登录");
    
    RYTLoginManager *manager = [RYTLoginManager shareInstance];
    [manager doLogout];
    
    //发送通知,修改我的界面的数据
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMeViewDataControllerNotification object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end

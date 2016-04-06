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

@interface SettingTableViewController ()

/** 缓存尺寸*/
@property(nonatomic ,assign) NSInteger total;

@property (weak, nonatomic) IBOutlet UILabel *cachesTotalLabel;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNavBar];
    

//    [SVProgressHUD showWithStatus:@"正在计算缓存尺寸..."];
    
    // 获取cachePath文件缓存
    [self getFileCacheSizeWithPath:self.cachePath completion:^(NSInteger total) {
        
        _total = total;
        

//        
//        [SVProgressHUD dismiss];
        
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
    NSString *cacheStr = @"清除缓存";
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
        
        cacheStr = [NSString stringWithFormat:@"%@(%.1f%@)",cacheStr,totalF,unit];
    }
    
    return cacheStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        [self removeCacheBtnClick:nil];
    }

}

- (IBAction)removeCacheBtnClick:(id)sender {
    
    [SVProgressHUD showWithStatus:@"正在删除..."];
    
    // 清空缓存,就是把Cache文件夹直接删掉
    // 删除比较耗时
    [self removeCacheWithCompletion:^{
        
        _total = 0;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
    
}


@end

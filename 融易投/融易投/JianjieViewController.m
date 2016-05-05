//
//  JianjieViewController.m
//  融易投
//
//  Created by efeiyi on 16/5/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "JianjieViewController.h"

#import "BianJiJianJieViewController.h"

@interface JianjieViewController ()

@end

@implementation JianjieViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)bianJiJianJieBtnClick:(id)sender {
    
    BianJiJianJieViewController *vc = [[BianJiJianJieViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

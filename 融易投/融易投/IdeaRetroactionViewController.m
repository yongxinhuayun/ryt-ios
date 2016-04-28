//
//  IdeaRetroactionViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "IdeaRetroactionViewController.h"

@interface IdeaRetroactionViewController ()

@end

@implementation IdeaRetroactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"意见反馈";
    
    
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(void)send{


    SSLog(@"111");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end

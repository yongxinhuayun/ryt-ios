//
//  ZhiFuViewController.m
//  融易投
//
//  Created by efeiyi on 16/6/2.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "ZhiFuViewController.h"

@interface ZhiFuViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ZhiFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWebView];
    
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"支付";
    
    //右边
    UIImage *image = [UIImage imageNamed:@"denglu_guanbi"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:0 target:self action:@selector(btnClick)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)btnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupWebView{
    
    NSURL *url = [NSURL URLWithString:self.url];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

    //让webView 自适应
    self.webView.scalesPageToFit = YES;
    self.webView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

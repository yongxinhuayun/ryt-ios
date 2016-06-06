//
//  ZhiFuViewController.m
//  融易投
//
//  Created by efeiyi on 16/6/2.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "ZhiFuViewController.h"

@interface ZhiFuViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *displayView;
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
}

-(void)setupWebView{
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];

    //让webView 自适应
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.scrollEnabled = NO;
//    self.webView.hidden = YES;
    
//    self.webView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

//
//  UserprotocolViewController.m
//  融易投
//
//  Created by efeiyi on 16/6/3.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "ProtocolWebViewController.h"

@interface ProtocolWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ProtocolWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航条标题
    self.navigationItem.title = self.title;
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.URLForResource withExtension:nil];
    
    //创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

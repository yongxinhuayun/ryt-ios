//
//  DetailCreationH5WebController.m
//  融易投
//
//  Created by efeiyi on 16/5/30.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "DetailCreationH5WebController.h"
#import <WebKit/WebKit.h>

@interface DetailCreationH5WebController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation DetailCreationH5WebController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    [self setupWebView];
}

-(void)setupWebView{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"src-H5" ofType:@".bundle"];
    NSString *htmlPath = [bundlePath stringByAppendingPathComponent:@"A2.html"];
    NSString *jsPath = [bundlePath stringByAppendingPathComponent:@"shop2016"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:jsPath]];
    //让webView 自适应
    self.webView.scalesPageToFit = YES;
    //设置webView的代理
    self.webView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end

//
//  testController.m
//  融易投
//
//  Created by 李鹏飞 on 16/6/1.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "testController.h"

@interface testController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation testController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    NSString *bundle = [[NSBundle mainBundle] bundlePath];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"src-H5" ofType :@"bundle"];
    NSString *Path= [bundlePath stringByAppendingPathComponent :@"A2.html"];
    NSString *jsPath = [bundlePath stringByAppendingPathComponent:@"shop2016"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:Path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:bundle]];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scrollView.bounces = NO;
}

-(void)test{


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

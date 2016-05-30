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

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"A2创作详情.html" withExtension:nil];
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    //创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
    //让webView 自适应
    self.webView.scalesPageToFit = YES;
    
    //设置webView的代理
    self.webView.delegate = self;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");
    
    //当点击按钮的时候会调到这个方法
    NSLog(@"%@",request.URL.absoluteString);
    
    NSString *urlStr = request.URL.absoluteString;
    
    NSString *format = @"rongyitou://";
    if ([urlStr hasPrefix:format]) {
        
        
        NSString *str = [urlStr substringFromIndex:format.length];
        
        
        NSArray *subStrArray = [str componentsSeparatedByString:@"?"];
        NSLog(@"%@",subStrArray);
        
        //9.1 此时的方法名是正确的
        //        (
        //         "callWithNumber_andContext_",
        //         "18681537032&love"
        //         )
        
        NSString *methodStr = [[subStrArray firstObject] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        
        //把方法名封装成方法
        SEL selector = NSSelectorFromString(methodStr);
        
        //9.2 修改参数,因为中间有&符号,所以根据这个符号分离参数
        
        NSString *paramStr = [subStrArray lastObject];
        NSArray *subParamArray = [paramStr componentsSeparatedByString:@"&"];
        NSLog(@"%@",subParamArray);
        //        (
        //        18681537032,
        //        love
        //        )
        
        //        [self performSelector:selector withObject:[subParamArray firstObject] withObject:[subParamArray lastObject]];
        
        //9.3 运行程序,发现能传递2个参数,并且执行额方法
        //但是当html中传递的是---方法名是传递2个参数的方法,后面传递的是一个参数,不能运行成功
        //所以添加容错处理
        
        if (subParamArray.count == 2) {
            [self performSelector:selector withObject:[subParamArray firstObject] withObject:[subParamArray lastObject]];
        }else{
            [self performSelector:selector withObject:[subParamArray firstObject] withObject:nil];
        }
        
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end

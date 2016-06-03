//
//  DetailCreationH5WebController.m
//  融易投
//
//  Created by efeiyi on 16/5/30.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "DetailCreationH5WebController.h"
#import "NSObject+Extension.h"
#import "PageInfoModel.h"
#import <MJExtension.h>
#import "ArtistUserHomeViewController.h"
#import "CommonUserHomeViewController.h"

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

//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"A2创作详情.html" withExtension:nil];
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sH5/A2.html" withExtension:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"H5" ofType :@""];
//    NSString *Path= [bundlePath stringByAppendingPathComponent :@"A2.html"];
//    NSString *jsPath = [bundlePath stringByAppendingPathComponent:@"H5/shop2016"];
//    NSString *htmlStr = [NSString stringWithContentsOfFile:Path encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:jsPath]];
    
    //让webView 自适应
    self.webView.scalesPageToFit = YES;
//    self.webView.scrollView.scrollEnabled = NO;
    
    //设置webView的代理
    self.webView.delegate = self;
}
#pragma mark -<UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    UserMyModel *model = TakeLoginUserModel;
    NSString *currentUserId = model.ID;
    NSString *artWorkId = self.artWorkId;
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&currentUserId=%@&timestamp=%@&key=%@",artWorkId,currentUserId,timestamp,appkey];
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    
//    //方式一:给JS传递参数
//    NSDictionary *json = @{
//                           @"currentUserId" : currentUserId,
//                           @"artWorkId" : artWorkId,
//                           @"timestamp" : timestamp,
//                           @"signmsg"   : signmsgMD5
//                           };
//    NSString *js1 = [NSString stringWithFormat:@"getParamObject1('%@')",json];
//    [self.webView stringByEvaluatingJavaScriptFromString:js1];
    
    //方式二:给JS传递参数
    NSString *js2 = [NSString stringWithFormat:@"initPage('%@','%@','%@','%@');",artWorkId,currentUserId,signmsgMD5,timestamp];
    [self.webView stringByEvaluatingJavaScriptFromString:js2];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");
    
    //当点击按钮的时候会调到这个方法
    NSLog(@"%@",request.URL.absoluteString);
    
    NSString *urlStr = request.URL.absoluteString;
    //rongyitou://jumpToUserHome_?skldjflksdjflk
    
    NSString *format = @"rongyitou://";
    if ([urlStr hasPrefix:format]) {
        NSString *str = [urlStr substringFromIndex:format.length];
        NSArray *subStrArray = [str componentsSeparatedByString:@"?"];
        NSLog(@"%@",subStrArray);
        /*
         (
         "jumpToUserHome_",
         skldjflksdjflk
         )
         */
        
        NSString *methodStr = [[subStrArray firstObject] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        
        //把方法名封装成方法
        SEL selector = NSSelectorFromString(methodStr);
        
        NSString *paramStr = [subStrArray lastObject];
        NSLog(@"%@",paramStr);
        
        //skldjflksdjflk
        
        //分类中可以传递多个参数,这里不需要,因为主需要传递一个参数
//        [self performSelector:selector withObjects:subParamArray];
        [self performSelector:selector withObject:paramStr withObject:nil];
        
        return NO;
    }
    
    return YES;
}

-(void)jumpToUserHome:(NSString *)userId
{
    NSLog(@"跳转到%@主页",userId);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId
                           };
    
    NSString *url = @"user.do";
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        PageInfoModel *model = [PageInfoModel mj_objectWithKeyValues:modelDict[@"data"]];
        

        
        //保存模型,赋值给控制器
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //艺术家用户
            if (model.user.master) {
                
                ArtistUserHomeViewController *artistHomeVC = [[ArtistUserHomeViewController alloc] init];
                
                artistHomeVC.userId = userId;
                artistHomeVC.title = model.user.name;
                
                [self.navigationController pushViewController:artistHomeVC animated:YES];
                
            }else{ //普通用户
                
                CommonUserHomeViewController *myHomeVC = [[CommonUserHomeViewController alloc] init];
                
                myHomeVC.userId = userId;
                myHomeVC.title = model.user.name;
                
                [self.navigationController pushViewController:myHomeVC animated:YES];
            }
            
        }];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end

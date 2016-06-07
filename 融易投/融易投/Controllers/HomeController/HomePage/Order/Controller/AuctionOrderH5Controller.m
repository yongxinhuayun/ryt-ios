//
//  AuctionOrderH5Controller.m
//  融易投
//
//  Created by efeiyi on 16/6/6.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "AuctionOrderH5Controller.h"
#import "PageInfoModel.h"

@interface AuctionOrderH5Controller () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AuctionOrderH5Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self setupWebView];
}

-(void)setupWebView{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sH5/A5-3.html" withExtension:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //让webView 自适应
    self.webView.scalesPageToFit = YES;
    
    
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
    
    /*
     //方式一:给JS传递参数
     NSDictionary *json = @{
     @"currentUserId" : currentUserId,
     @"artWorkId" : artWorkId,
     @"timestamp" : timestamp,
     @"signmsg"   : signmsgMD5
     };
     NSString *js1 = [NSString stringWithFormat:@"getParamObject1('%@')",json];
     [self.webView stringByEvaluatingJavaScriptFromString:js1];
     */
    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

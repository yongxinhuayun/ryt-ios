//
//  DetailAuctionH5Controller.m
//  融易投
//
//  Created by efeiyi on 16/6/6.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "DetailAuctionH5Controller.h"
#import "NSObject+Extension.h"
#import "PageInfoModel.h"
#import <MJExtension.h>
#import "ArtistUserHomeViewController.h"
#import "CommonUserHomeViewController.h"
#import "PostCommentController.h"
#import "ZhiFuViewController.h"

@interface DetailAuctionH5Controller () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;
@end

@implementation DetailAuctionH5Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self setupWebView];
}

-(void)setupWebView{
    
//    if ([self.step isEqualToString:@"30"]) {
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"sH5/A3-1.html" withExtension:nil];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    }else if([self.step isEqualToString:@"30"]){
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"sH5/A3-2.html" withExtension:nil];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    }else{
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"sH5/A3-3.html" withExtension:nil];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//        
//    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sH5/A3-1.html" withExtension:nil];
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
//    NSString *artWorkId = @"qydeyugqqiugd2";
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
    
    //"comment://jumpToCommentUser_andCommentArtWorkId_?"+userid + "&qydeyugqqiugd2"
    NSString *href = @"comment://";
    if ([urlStr hasPrefix:href]) {
        
        NSString *str = [urlStr substringFromIndex:href.length];
        
        NSArray *subStrArray = [str componentsSeparatedByString:@"?"];
        NSLog(@"%@",subStrArray);
        
        NSString *methodStr = [[subStrArray firstObject] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        
        //把方法名封装成方法
        SEL selector = NSSelectorFromString(methodStr);
        
        
        NSString *paramStr = [subStrArray lastObject];
        NSArray *subParamArray = [paramStr componentsSeparatedByString:@"&"];
        NSLog(@"%@",subParamArray);        
        
        [self performSelector:selector withObjects:subParamArray];
        
        return NO;
    }
    
    //"comment://jumpToCommentUser_andCommentArtWorkId_?"+userid + "&qydeyugqqiugd2"
    NSString *pay = @"pay://";
    if ([urlStr hasPrefix:pay]) {
        
        NSString *str = [urlStr substringFromIndex:pay.length];
        
        NSArray *subStrArray = [str componentsSeparatedByString:@"?"];
        NSLog(@"%@",subStrArray);
        
        NSString *methodStr = [[subStrArray firstObject] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        
        //把方法名封装成方法
        SEL selector = NSSelectorFromString(methodStr);
        
        
        NSString *paramStr = [subStrArray lastObject];
        NSArray *subParamArray = [paramStr componentsSeparatedByString:@"&"];
        NSLog(@"%@",subParamArray);
        
        [self performSelector:selector withObjects:subParamArray];
        
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

-(void)jumpToCommentUser:(NSString *)userId andCommentArtWorkId:(NSString *)artWorkId {

    NSLog(@"跳转到%@评论界面",artWorkId);
    
    RYTLoginManager *manager =  [RYTLoginManager shareInstance];
    if ([manager showLoginViewIfNeed]) {
    }else{
        PostCommentController * postComment = [[PostCommentController alloc] init];
        postComment.title = @"评论";
        postComment.artworkId = artWorkId;
        postComment.currentUserId = userId;
        [self.navigationController pushViewController:postComment animated:YES];
    }
    
}

-(void)jumpToPayUser:(NSString *)userId andPayArtWorkId:(NSString *)artWorkId andPayMoney:(NSString *)money  andPayAction:(NSString *)action andPayType:(NSString *)type{
    
    NSLog(@"跳转到支付界面支付");
    
    NSLog(@"%@---%@----%@-----%@-----%@",userId,artWorkId,money,action,type);
    
    RYTLoginManager *manager =  [RYTLoginManager shareInstance];
    if ([manager showLoginViewIfNeed]) {
    }else{
        
        //参数
        NSString *url = @"pay/main.do";
        
        NSDictionary *json = @{
                               @"userId":userId,
                               @"money": money,
                               @"action" : action,
                               @"type" : type,
                               @"artWorkId":artWorkId
                               };
        
        // 创建一个组
        dispatch_group_t group = dispatch_group_create();
        // 添加当前操作到组中
        dispatch_group_enter(group);
        
        [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
            
            NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
            NSLog(@"返回结果:%@",jsonStr);
            
            NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
            NSString *url = modelDict[@"url"];
            
            NSArray *subStrArray = [url componentsSeparatedByString:@"pay="];
            NSString *preStr = [subStrArray firstObject];
            NSString *lastStr = [subStrArray lastObject]; //这个需要转义
            NSString *str = [lastStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *preUrl = [NSString stringWithFormat:@"%@pay=%@",preStr,str];
            NSURL *zhifubaourl = [NSURL URLWithString:preUrl];
            
            self.url = zhifubaourl;
            
            //// 从组中移除一个操作
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            // 6.回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ZhiFuViewController *zhifuVC = [[ZhiFuViewController alloc] init];
                zhifuVC.url = self.url;
                
                [self.navigationController pushViewController:zhifuVC animated:YES];
            });
        });

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

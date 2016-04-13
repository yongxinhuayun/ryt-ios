//
//  ArtistViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/12.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistViewController.h"

#import "SettingTableViewController.h"


#import <WechatShortVideoController.h>

#import "ReleaseViewController.h"

@interface ArtistViewController ()<WechatShortVideoDelegate>
{
    NSURL *urlVideo;
}


@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"我的";
    
    
}


- (IBAction)shortVideo:(id)sender {
    
    WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
    wechatShortVideoController.delegate = self;
    [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
    
}
- (IBAction)updataPic:(id)sender {
    
    UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([ReleaseViewController class]) bundle:nil];
    ReleaseViewController *settingVC = [settingStoryBoard instantiateInitialViewController];
    [self presentViewController:settingVC animated:YES completion:nil];
}


- (IBAction)updata:(id)sender {
    
    [self loadData];
}

-(void)loadData
{
    //参数
    
    NSString *projectTitle = @"你妹";
    
    NSString *title = [projectTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *userId = @"imhfp1yr4636pj49";
    NSString *picture_url = urlVideo;
    
    NSLog(@"%@",picture_url);
    
    NSString *artworkId = @"imyj2dw936qyh35t";
    
    NSString *timestamp = [MyMD5 timestamp];
    
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artworkId=%@&timestamp=%@&key=%@",artworkId,timestamp,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.69:8001/app/releaseArtworkDynamic.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"content" : title,
                           @"file" : picture_url,
                           @"type": @"1",
                           @"artworkId"   : artworkId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manger POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        //_fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
        
        // [formData appendPartWithFileURL:_filePathURL name:@"file" fileName:_fileName mimeType:dict[@"contenttype"] error:nil];
        
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        NSString*_fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
        //NSURL *urlStr = [NSURL URLWithString:]
        
        [formData appendPartWithFileURL:urlVideo name:@"file" fileName:@"ii.mov" mimeType:@"application/octet-stream" error:nil];
        
        
        
        //          [formData appendPartWithFileURL:[NSURL URLWithString:picture_url] name:@"file" fileName:@"ii.mov" mimeType:@"application/octet-stream" error:nil];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        SSLog(@"%@---%@",[responseObject class],aString);
        
        //        [SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:SVProgressHUDMaskTypeBlack];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"%@",error);
        
        //        [SVProgressHUD showSuccessWithStatus:@"发布失败 " maskType:SVProgressHUDMaskTypeBlack];
    }];
    
    
}

-(void)finishWechatShortVideoCapture:(NSURL *)filePath{
    urlVideo = filePath;
    NSLog(@"urlVideo%@ ",urlVideo);
    NSLog(@"1111111111$%@",filePath);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

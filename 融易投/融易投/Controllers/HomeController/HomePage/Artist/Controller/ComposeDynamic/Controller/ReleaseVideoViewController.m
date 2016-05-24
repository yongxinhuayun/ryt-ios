//
//  ReleaseVideoViewCellViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/15.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ReleaseVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XMGPlayerView.h"

#import <WechatShortVideoController.h>

@interface ReleaseVideoViewController ()<WechatShortVideoDelegate,UITextViewDelegate>
{
    NSURL *urlVideo;
}

@property (weak, nonatomic) IBOutlet UIView *videoView;

/** 播放器 */
@property (nonatomic ,strong) AVPlayer *player;

@property (nonatomic, weak) AVPlayerLayer *layer;

@property (nonatomic, weak) XMGPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *addVideoBtn;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation ReleaseVideoViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    [self setUpTextView];
    
//    [self.videoView.layer addSublayer:self.layer];
    
//    NSLog(@"%@",urlVideo);

//    NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4"];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];

}

-(void)setUpTextView{

    //让textView在左上角出现光标
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //设置placeholderLabel隐藏
    self.placeholderLabel.hidden = [self.textView.text length];
        
    self.textView.delegate = self;
    
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [leftButton sizeToFit];
    
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;

    
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)send {
    
     SSLog(@"111");
    
    //参数
    NSString *title = self.textView.text;
    
    NSString *picture_url = urlVideo.absoluteString;
    
    NSLog(@"%@",picture_url);
    
    NSString *artworkId = @"qydeyugqqiugd6";
    
    NSString *timestamp = [MyMD5 timestamp];
    
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artworkId=%@&timestamp=%@&key=%@",artworkId,timestamp,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求
    NSString *url = @"http://192.168.1.41:8080/app/releaseArtworkDynamic.do";
    
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
        
//        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//        [formater setDateFormat:@"yyyyMMddHHmmss"];
//        NSString *_fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
        //NSURL *urlStr = [NSURL URLWithString:]
        
        [formData appendPartWithFileURL:urlVideo name:@"file" fileName:@"video.mov" mimeType:@"application/octet-stream" error:nil];
        
        
        
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




-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSLog(@"%@",urlVideo);
    
    if (urlVideo == nil) {
        
        return;
        
    }else{
        
        self.addVideoBtn.hidden = YES;
        
//        [self player];
        
//        [self.videoView removeFromSuperview];
        
        XMGPlayerView *playerView = [XMGPlayerView playerView];
        playerView.frame = CGRectMake(0, 0, 120, 120);
        
        [self.videoView insertSubview:playerView atIndex:0];
        self.playerView = playerView;
        
       
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:urlVideo];
        
//        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4"];
//        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        
        self.playerView.playerItem = item;

    }

}


- (IBAction)recordVideo:(id)sender {
    
        WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
        wechatShortVideoController.delegate = self;
        [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
 
}

-(void)finishWechatShortVideoCapture:(NSURL *)filePath{
    
    
    urlVideo = filePath;

}

#pragma mark - Text View Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = [textView.text length];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text])
    {
        if ([self.textView.text length]) {
            [self.textView resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}


//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
//    self.layer.frame = self.videoView.bounds;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//
//    
//}



@end

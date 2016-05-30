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
#import <UIKit/UIKit.h>
@interface ReleaseVideoViewController ()<WechatShortVideoDelegate,UITextViewDelegate,MBProgressHUDDelegate,XMGPlayerViewDelegate>
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
@property(nonatomic,strong) MBProgressHUD *progressHUD;
@property (nonatomic,strong) UIView *preView;

@end

@implementation ReleaseVideoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTextView];
}

-(UIView *)preView{
    if (!_preView) {
        _preView = [[UIView alloc] init];
    }
    return _preView;
}

-(MBProgressHUD *)progressHUD{
    if (!_progressHUD) {
        _progressHUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        self.progressHUD.delegate = self;
        _progressHUD.mode = MBProgressHUDModeDeterminate;
    }
    return _progressHUD;
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
    //参数
    NSString *title = self.textView.text;
    NSString *picture_url = urlVideo.absoluteString;
    NSLog(@"%@",picture_url);
    NSString *artworkId = self.artworkId;
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    NSString *signmsg = [NSString stringWithFormat:@"artworkId=%@&timestamp=%@&key=%@",artworkId,timestamp,appkey];
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    NSDictionary *json = @{
                           @"content" : title,
                           @"file" : picture_url,
                           @"type": @"1",
                           @"artworkId"   : artworkId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    /*
    NSString *url = @"http://192.168.1.75:8001/app/releaseArtworkDynamic.do";
    
    
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
     */
    
    NSString *url = @"releaseArtworkDynamic.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json constructingBodyWithBlock:^(id formData) {
        //_fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
        
        // [formData appendPartWithFileURL:_filePathURL name:@"file" fileName:_fileName mimeType:dict[@"contenttype"] error:nil];
        
        //        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        //        [formater setDateFormat:@"yyyyMMddHHmmss"];
        //        NSString *_fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
        //NSURL *urlStr = [NSURL URLithString:]
        
        [formData appendPartWithFileURL:urlVideo name:@"file" fileName:@"video.mov" mimeType:@"application/octet-stream" error:nil];
        //          [formData appendPartWithFileURL:[NSURL URLWithString:picture_url] name:@"file" fileName:@"ii.mov" mimeType:@"application/octet-stream" error:nil];

    } showHUDView:nil progress:^(id progress) {
        NSProgress *p = (NSProgress *)progress;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            float total = p.totalUnitCount;
            float completed = p.completedUnitCount;
            float i = completed / total;
        self.progressHUD.progress = i;
            if (i == 1) {
                self.progressHUD.labelText = [NSString stringWithFormat:@"发布成功"];
                self.progressHUD.mode = MBProgressHUDModeCustomView;
                [self.progressHUD hide:YES afterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    } success:^(id respondObj) {
        //        NSString *aString = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        SSLog(@"---%@---%@",[respondObj class],aString);
//        [MBProgressHUD showSuccess:@"发布成功"];
        //保存模型,赋值给控制器
    }];
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (urlVideo == nil) {
        return;
    }else{
        self.addVideoBtn.hidden = YES;
        XMGPlayerView *playerView = [XMGPlayerView playerView];
        playerView.frame = CGRectMake(0, 0, 120, 120);
        [self.videoView insertSubview:playerView atIndex:0];
        self.playerView = playerView;
        self.playerView.delegate = self;
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:urlVideo];
        self.playerView.playerItem = item;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)playerViewDidClickFullScreen:(BOOL)isFull{
    if (isFull) {
        self.preView = self.view;
        
        self.view = self.playerView;
        self.navigationController.navigationBar.hidden = YES;
        self.playerView.width = SSScreenW;
        self.playerView.height = SSScreenH;
        [self prefersStatusBarHidden];
    }else{
        [UIApplication sharedApplication].statusBarHidden = NO;
        self.navigationController.navigationBar.hidden = NO;
        
        self.view = self.preView;
        [self.videoView insertSubview:self.playerView atIndex:0];
        self.preView = self.view;
        self.playerView.width = 120;
        self.playerView.height = 120;
//        self.playerView.frame = CGRectMake(0, 0,120 , 120);
//        self.playerView.transform = CGAffineTransformMakeRotation(M_PI_2);
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

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud = nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self.playerView];
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

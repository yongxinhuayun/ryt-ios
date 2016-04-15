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

@interface ReleaseVideoViewController ()<WechatShortVideoDelegate>
{
    NSURL *urlVideo;
}

@property (weak, nonatomic) IBOutlet UIView *videoView;

/** 播放器 */
@property (nonatomic ,strong) AVPlayer *player;

@property (nonatomic, weak) AVPlayerLayer *layer;

@property (nonatomic, weak) XMGPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *addVideoBtn;

@end

@implementation ReleaseVideoViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.videoView.layer addSublayer:self.layer];
    
    NSLog(@"%@",urlVideo);

//    NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4"];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];

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

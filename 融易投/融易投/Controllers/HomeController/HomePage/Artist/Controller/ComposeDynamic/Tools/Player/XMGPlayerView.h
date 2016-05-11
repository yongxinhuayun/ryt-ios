//
//  XMGPlayerView.h
//  02-播放远程视频-封装播放器
//
//  Created by 王顺子 on 15/10/10.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol XMGPlayerViewDelegate <NSObject>

@optional
- (void)playerViewDidClickFullScreen:(BOOL)isFull;

@end

@interface XMGPlayerView : UIView

+ (instancetype)playerView;


@property (weak, nonatomic) id<XMGPlayerViewDelegate> delegate;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

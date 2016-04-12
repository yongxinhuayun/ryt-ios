//
//  HMEmotionTextView.h
//  黑马微博
//
//  Created by apple on 14-7-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMTextView.h"
@class HMEmotion;

@interface HMEmotionTextView : HMTextView
/**
 *  拼接表情到最后面
 */
- (void)appendEmotion:(HMEmotion *)emotion;

/**
 *  具体的文字内容
 */
- (NSString *)realText;
@end

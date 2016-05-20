//
//  UIImageView+Header.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UIImageView+Header.h"

#import "UIImageView+WebCache.h"

@implementation UIImageView (Header)


- (void)ss_setHeader:(NSURL *)url
{
    // 占位图片
    UIImage *placeholder = [UIImage bs_circleImageNamed:@"jibenziliao_touxiang"];
    
    // 下载图片
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) return;
        
        self.image = [image bs_circleImage];
    }];
    
}

@end

//
//  UIImageView+Header.m
//  百思不得姐
//
//  Created by 王梦思 on 15/12/26.
//  Copyright © 2015年 王梦思. All rights reserved.
//

#import "UIImageView+Header.h"

#import "UIImageView+WebCache.h"

@implementation UIImageView (Header)


- (void)bs_setHeader:(NSString *)url
{
    // 占位图片
    UIImage *placeholder = [UIImage bs_circleImageNamed:@"defaultUserIcon"];
    
    // 下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) return;
        
        self.image = [image bs_circleImage];
    }];
    
}

@end

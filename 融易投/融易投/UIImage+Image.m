//
//  UIImage+Image.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UIImage+Image.h"
//111
@implementation UIImage (Image)


+ (instancetype)imageNamedWithOriganlMode:(NSString *)imageName
{
    // 加载原始图片
    UIImage *selImage = [UIImage imageNamed:imageName];
    
    // imageWithRenderingMode:返回每一个没有渲染图片给你
    return [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end

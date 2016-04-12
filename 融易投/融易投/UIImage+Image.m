//
//  UIImage+Image.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)


+ (instancetype)imageNamedWithOriganlMode:(NSString *)imageName
{
    // 加载原始图片
    UIImage *selImage = [UIImage imageNamed:imageName];
    
    // imageWithRenderingMode:返回每一个没有渲染图片给你
    return [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


-(instancetype)stretchableImage
{
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}


- (instancetype)bs_circleImage
{
    // 利用self生成一张圆形图片
    
    // 1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    // 2.描述圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域
    [path addClip];
    
    // 4.画图
    [self drawAtPoint:CGPointZero];
    
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)bs_circleImageNamed:(NSString *)name
{
    return [[UIImage imageNamed:name] bs_circleImage];
}


+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
    if (iOS7) { // 处理iOS7的情况
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}





@end

//
//  UIImage+Image.h
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

// 提供一个加载原始图片方法
+ (instancetype)imageNamedWithOriganlMode:(NSString *)imageName;

// 加载拉伸中间1个像素图片
- (instancetype)stretchableImage;

//生成圆形图片
- (instancetype)bs_circleImage;

+ (instancetype)bs_circleImageNamed:(NSString *)name;



/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

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


@end

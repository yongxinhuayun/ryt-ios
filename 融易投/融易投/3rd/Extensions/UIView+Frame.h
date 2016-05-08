//
//  UIView+Frame.h
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

//直接使用@property生成带下划线属性和set/get方法的生命,注意没有定义
//@property后面修饰的属性,只是修饰方法的,所以我们不需要写了
// width
@property CGFloat width;
// height
@property CGFloat height;

@property CGFloat x;

@property CGFloat y;

@property CGFloat centerX;

@property CGFloat centerY;

@end

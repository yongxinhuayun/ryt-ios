//
//  Progress.m
//  progess
//
//  Created by 李鹏飞 on 16/5/13.
//  Copyright © 2016年 lipengfei. All rights reserved.
//

#import "Progress.h"

@interface Progress()
@end

@implementation Progress

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:191.0 / 255.0 green:193.0 / 255.0 blue:194.0 / 255.0 alpha:0.5];
    }
    return self;
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // 需要五个点的坐标，连接这五个点 形成一个闭环。
    // 绘制图形
    // 获取上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 1.起始点 (0,0)
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGContextMoveToPoint(ref, startX, startY);
    // 2.直线终点 (比率 * 长度,箭头的长度)
    CGFloat endX = self.frame.size.width * self.progress - 3;
    CGFloat endY = startY;
    CGContextAddLineToPoint(ref, endX, endY);
    // 3.转折点坐标
    CGFloat zX = endX + 3;
    CGFloat zY = self.frame.size.height / 2;
    CGContextAddLineToPoint(ref, zX, zY);
    // 4.返回点
    CGFloat fX = endX;
    CGFloat fY = self.frame.size.height;
    CGContextAddLineToPoint(ref, fX, fY);
    // 5. 终点
    CGFloat backX = startX;
    CGFloat backY = fY;
    CGContextAddLineToPoint(ref, backX, backY);

    CGContextSetFillColorWithColor(ref, [UIColor colorWithRed:(239.0/255.0) green:(91.0/255.0) blue:(112.0/255.0) alpha:1].CGColor);
    
//    闭合
    CGContextClosePath(ref);
    CGContextFillPath(ref);
}

@end

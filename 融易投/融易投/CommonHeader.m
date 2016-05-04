//
//  CommonHeader.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonHeader.h"

@interface CommonHeader()

/** logo */
//@property (nonatomic, weak) UIImageView *logo;

@end

@implementation CommonHeader

// 初始化
- (void)prepare
{
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    
    // 设置颜色
    //239, 91, 112
    self.stateLabel.textColor =[UIColor colorWithRed: (239) / 255.0 green:(91) / 255.0 blue:(112) / 255.0 alpha:1];
//    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    

    [self setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    self.stateLabel.font = [UIFont systemFontOfSize:15];
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    

    
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];

    
    //    UIImageView *logo = [[UIImageView alloc] init];
    //    logo.contentMode = UIViewContentModeCenter;
    //    logo.image = [UIImage imageNamed:@"MainTitle"];
    //    [self addSubview:logo];
    //    self.logo = logo;
}

// 摆放子控件
- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat x = [UIApplication sharedApplication].keyWindow.x;
    
    self.frame = CGRectMake(x * 0.5, -61 , self.width, self.height);
    
    //    self.logo.frame = CGRectMake(0, -60, self.width, 60);
}


@end

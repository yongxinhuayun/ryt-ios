//
//  CommonFooter.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonFooter.h"

@interface CommonFooter()

/** logo */
//@property (nonatomic, weak) UIImageView *logo;

@end


@implementation CommonFooter


// 初始化
- (void)prepare
{
    [super prepare];
    
    self.stateLabel.textColor = [UIColor redColor];
    
    //关闭自动显示和隐藏的功能(需要开发者自己去显示和隐藏footer)
    self.automaticallyHidden = YES;
    
    
    [self setTitle:@"加载更多数据 ..." forState:MJRefreshStateRefreshing];
    self.stateLabel.textColor =[UIColor colorWithRed: (239) / 255.0 green:(91) / 255.0 blue:(112) / 255.0 alpha:1];
    
    self.refreshingTitleHidden = YES;
    
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
    
    //    self.stateLabel.font
    //    [self setTitle:@"abc" forState:MJRefreshStateIdle];
    //    [self setTitle:@"ddd" forState:MJRefreshStateRefreshing];
    
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
    
    self.frame = CGRectMake(0, 61 , self.width, self.height);
    
    //    self.logo.frame = CGRectMake(0, self.height, self.width, 60);
}

@end

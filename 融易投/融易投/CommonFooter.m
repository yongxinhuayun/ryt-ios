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
    self.automaticallyChangeAlpha = YES;
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
    

}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.alpha = 0;
        }];
    } else if (state == MJRefreshStatePulling) {
        [self setTitle:@"松开就进行刷新的状态" forState:MJRefreshStatePulling];
        
    }
//    else if (state == MJRefreshStateRefreshing) {
//        //        [self setTitle:@"正在刷新,,," forState:MJRefreshStateRefreshing];
//    }
    else if (state == MJRefreshStateWillRefresh) {
        
    }
}

// 摆放子控件
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.frame = CGRectMake(0, 61 , self.width, self.height);
    
    //    self.logo.frame = CGRectMake(0, self.height, self.width, 60);
}

@end

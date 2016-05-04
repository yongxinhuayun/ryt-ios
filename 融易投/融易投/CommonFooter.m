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
    
    self.stateLabel.textColor = [UIColor blackColor];
    //    self.stateLabel.font
    //    [self setTitle:@"abc" forState:MJRefreshStateIdle];
    //    [self setTitle:@"ddd" forState:MJRefreshStateRefreshing];
    
    //    UIImageView *logo = [[UIImageView alloc] init];
    //    logo.contentMode = UIViewContentModeCenter;
    //    logo.image = [UIImage imageNamed:@"MainTitle"];
    //    [self addSubview:logo];
    //    self.logo = logo;
    
    // 关闭自动显示和隐藏的功能(需要开发者自己去显示和隐藏footer)
    //    self.automaticallyHidden = NO;
}

// 摆放子控件
- (void)placeSubviews
{
    [super placeSubviews];
    
    //    self.logo.frame = CGRectMake(0, self.height, self.width, 60);
}

@end

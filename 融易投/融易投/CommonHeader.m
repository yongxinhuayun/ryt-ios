//
//  BSHeader.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/23.
//  Copyright © 2015年 xiaomage. All rights reserved.
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
    self.stateLabel.textColor = [UIColor blackColor];
    self.lastUpdatedTimeLabel.hidden = NO;
    
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
    
    self.frame = CGRectMake(0, -61 , self.width, self.height);

//    self.logo.frame = CGRectMake(0, -60, self.width, 60);
}


@end

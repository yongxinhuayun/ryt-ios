//
//  WXButton.m
//  融易投
//
//  Created by efeiyi on 16/5/26.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "WXButton.h"

@implementation WXButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 图片
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = 0;
    
    // 文字
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.height = self.height - self.imageView.height;
}


@end

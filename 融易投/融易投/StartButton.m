//
//  StartButton.m
//  融易投
//
//  Created by efeiyi on 16/5/20.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "StartButton.h"

@implementation StartButton

-(void)layoutSubviews
{
    // 会根据xib描述的,计算内部子控件的位置
    [super layoutSubviews];
    
    self.titleLabel.y = 0;
    self.titleLabel.x = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
    self.imageView.centerY = self.titleLabel.centerY + 2;
    self.imageView.height = 6;
    self.imageView.width = 6;
    
    //运行程序,发现标题显示不完全,我们要重新更新一下位置
    [self.titleLabel sizeToFit];
    
}

@end

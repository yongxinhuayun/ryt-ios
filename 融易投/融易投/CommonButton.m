//
//  CommonButton.h
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonButton.h"

@implementation CommonButton

-(void)layoutSubviews
{
    // 会根据xib描述的,计算内部子控件的位置
    [super layoutSubviews];
    
//    self.imageView.y = 0;
////    self.imageView.center.x = self.width * 0.5; //我么要想设置center的X值,需要传递一个CGFloat类型的,所以为了方便,我们在分类中添加centerX属性
//    self.imageView.centerX = self.width * 0.5;
//    
//    
//    self.titleLabel.y = self.imageView.height;
//    self.titleLabel.centerX = self.width * 0.5;
    
    self.titleLabel.y = 0;
    self.titleLabel.x = 0;
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
    self.imageView.centerY = self.titleLabel.centerY;
    
    //运行程序,发现标题显示不完全,我们要重新更新一下位置
    [self.titleLabel sizeToFit];

}

@end

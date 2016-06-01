//
//  PointView.m
//  融易投
//
//  Created by 李鹏飞 on 16/6/1.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "PointView.h"

@interface PointView()



@end

@implementation PointView

- (IBAction)closeBtn:(UIButton *)sender {
    // 关闭
    if ([self.delegate respondsToSelector:@selector(clickClose)]) {
        [self.delegate clickClose];
    }
}

- (IBAction)rechargeBtn:(UIButton *)sender {
    // 跳转到充值页面
    NSLog(@"跳转到充值页面");
    if ([self.delegate respondsToSelector:@selector(clickRecharge)]) {
        [self.delegate clickRecharge];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

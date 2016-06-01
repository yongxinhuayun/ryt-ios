//
//  CoverHUDView.m
//  融易投
//
//  Created by efeiyi on 16/5/12.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "CoverHUDView.h"

@implementation CoverHUDView

+(instancetype)coverHUDView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.subView.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 0.5;
        self.subView.alpha = 1;
        [self removeFromSuperview];
        [self.subView removeFromSuperview];
    }];
}

@end

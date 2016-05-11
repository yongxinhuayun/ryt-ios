//
//  FinanceFooterView.m
//  融易投
//
//  Created by dongxin on 16/5/10.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceFooterView.h"

@interface FinanceFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *TZBtn;

@end

@implementation FinanceFooterView

- (void)drawRect:(CGRect)rect {
//    self.widthConstraint.constant = 0;
//    self.widthConstraint.constant = 170;
}

- (IBAction)clickZan:(UIButton *)sender {
    NSLog(@"点赞");
    if (sender.selected) {
    }else{
        UILabel *num = [[UILabel alloc] initWithFrame:sender.frame];
        num.center = sender.center;
        num.textAlignment = NSTextAlignmentCenter;
        num.text = @"+1";
        num.textColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.7];
        [self addSubview:num];
        [UIView animateWithDuration:0.6 animations:^{
            CGFloat x = num.centerX;
            CGPoint p = CGPointMake(x, 0);
            num.center = p;
            num.alpha = 0;
        } completion:^(BOOL finished) {
            [num removeFromSuperview];
        }];
        if ([self.delegate respondsToSelector:@selector(clickZan:)]) {
            [self.delegate clickZan:sender];
        }
        sender.selected = YES;
        sender.userInteractionEnabled = NO;
    }
    
}
- (IBAction)touzi:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(jumpTZController)]) {
        [self.delegate jumpTZController];
    }
}
- (IBAction)pinglun:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(jumpPLController)]) {
        [self.delegate jumpPLController];
    }
}

@end

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

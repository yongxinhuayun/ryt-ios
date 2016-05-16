//
//  TopView.m
//  融易投
//
//  Created by dongxin on 16/4/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "TopView.h"
@interface TopView()

@end

@implementation TopView
- (IBAction)asdf:(UIButton *)sender {
    NSLog(@"12312312312312312");
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.userInteractionEnabled = YES;
    UIButton *btn =  [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(10, 140, 60, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(asdf:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];    [self bringSubviewToFront:btn];
}


@end

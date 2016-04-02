//
//  MainTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "navTitleButton.h"

@implementation navTitleButton

//创建按钮都会来到这个方法,所以在这里设置选中颜色
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        
        //设置选中颜色
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        //设置正常状态下的颜色
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        //在外界直接根据按钮的状态就能改变按钮标题颜色
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted{}

@end

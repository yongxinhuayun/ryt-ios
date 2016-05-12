//
//  FaBuHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/5/12.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "FaBuHeaderView.h"

@implementation FaBuHeaderView

+(instancetype)faBuHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

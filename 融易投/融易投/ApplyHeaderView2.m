//
//  ApplyHeaderView2.m
//  融易投
//
//  Created by efeiyi on 16/4/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ApplyHeaderView2.h"

@implementation ApplyHeaderView2

+(instancetype)applyHeaderView2
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

@end

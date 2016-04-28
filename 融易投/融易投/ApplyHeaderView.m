//
//  ApplyHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ApplyHeaderView.h"

@implementation ApplyHeaderView

+(instancetype)applyHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

@end

//
//  CommonTextView.m
//  融易投
//
//  Created by efeiyi on 16/5/9.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonTextView.h"

@implementation CommonTextView

+(instancetype) commonTextView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

@end

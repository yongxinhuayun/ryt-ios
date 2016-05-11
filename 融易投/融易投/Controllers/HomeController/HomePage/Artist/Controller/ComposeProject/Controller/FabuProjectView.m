//
//  ComposeProjectView.m
//  融易投
//
//  Created by efeiyi on 16/5/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FabuProjectView.h"

@implementation FabuProjectView

+(instancetype)composeProjectView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


@end

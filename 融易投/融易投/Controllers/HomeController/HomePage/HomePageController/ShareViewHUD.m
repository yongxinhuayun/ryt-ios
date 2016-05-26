//
//  ShareViewHUD.m
//  融易投
//
//  Created by efeiyi on 16/5/26.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "ShareViewHUD.h"

@implementation ShareViewHUD

+(instancetype)shareViewHUD
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self removeFromSuperview];
}

@end

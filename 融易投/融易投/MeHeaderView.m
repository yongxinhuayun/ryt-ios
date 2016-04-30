//
//  MeHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MeHeaderView.h"

@implementation MeHeaderView

+(instancetype)meHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)btnClick:(id)sender {
    
    SSLog(@"111");
}

@end

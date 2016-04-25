//
//  ArtistMyHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistMyHeaderView.h"

@implementation ArtistMyHeaderView

+(instancetype)artistMyHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

@end

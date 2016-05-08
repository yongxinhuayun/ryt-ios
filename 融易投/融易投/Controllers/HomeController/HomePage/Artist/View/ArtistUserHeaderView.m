//
//  ArtistMyHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistUserHeaderView.h"

@implementation ArtistUserHeaderView

+(instancetype)artistUserHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

@end

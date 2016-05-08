//
//  ArtistViewHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/22.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistViewHeaderView.h"

@implementation ArtistViewHeaderView


+(instancetype)artistViewHeaderView
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

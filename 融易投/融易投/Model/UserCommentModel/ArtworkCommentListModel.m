//
//  ArtworkCommentListModel.m
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtworkCommentListModel.h"

@implementation ArtworkCommentListModel

-(CGFloat)cellHeight{
    CGFloat margin = 10;
    CGFloat userIconY = 50;
    CGFloat maxY = userIconY + margin * 2;
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * 10;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGFloat textH = [self.content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15] } context:nil].size.height;
    maxY = maxY + textH + margin;
    return  maxY;
}
@end

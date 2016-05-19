//
//  UserCommentListModel.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "UserCommentListModel.h"

@implementation UserCommentListModel
-(CGFloat)cellHeight{
    CGFloat margin = 12;
    CGFloat userIcon = 35;
    // 计算textView的高度
    CGFloat maxY = [self getTextViewHeight:self.content margin:14];
    maxY = maxY + 2 * margin + userIcon;
    if (self.fatherArtworkCommentBean) {
        maxY = maxY + [self getTextViewHeight:self.fatherArtworkCommentBean.content margin:14];
    }
    CGFloat artIcon = 60;
    maxY = maxY + artIcon + 2 * margin;
    return maxY;
}
-(CGFloat)getTextViewHeight:(NSString *)text margin:(CGFloat)margin {
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * margin;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGFloat textH = [text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15] } context:nil].size.height;
    return textH;
}
@end

//
//  ProjectDetailsModel.m
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ProjectDetailsModel.h"
#import "ArtworkModel.h"
#import "ArtworkdirectionModel.h"

@implementation ProjectDetailsModel
// 获取cell 的高度
-(CGFloat)cellHeight:(CellType)Type{
    CGFloat tWidth = [UIScreen mainScreen].bounds.size.height - 2 * 10;
    CGFloat textH = 0;
    if (Type == cellBrief) {
        textH = [self TextHeight:self.artWork.brief andTextWidth:tWidth];
        NSInteger count = self.artworkAttachmentList.count;
        if (count > 0) {
            textH = textH + count * 200 + count * 10 + 30;
        }
    }else if(Type == cellInstru){
        textH = [self TextHeight:self.artworkdirection.make_instru andTextWidth:tWidth];
    }else{
        textH = [self TextHeight:self.artworkdirection.financing_aq andTextWidth:tWidth];
    }
    textH += 40;
    return textH;
}

-(CGFloat)TextHeight:(NSString *)text andTextWidth:(CGFloat)textWidth{
    CGFloat textW = textWidth;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGFloat textH = [text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15] } context:nil].size.height;
    return textH;
}

@end

//
//  ProjectDetailsModel.m
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ProjectDetailsModel.h"

@implementation ProjectDetailsModel



-(CGFloat)cellHeight{
    
    //我们早这里直接使用下划线属性,就不用在创建一个了
    //     CGFloat cellHeight = 0;
    
    //4. 因为get方法会在tableView滚动的时候会来多次,所以为了节省系统资源,我们可以在加载数据完成的时候调用一次
    if (_cellHeight) return _cellHeight;
    
//    // 项目介绍
//    CGFloat textMaxW = SSScreenW - 2 * SSMargin;
//    _cellHeight = SSMargin + [self.labelInfo.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height + SSMargin;
//    
//    // 文字
//    _cellHeight += [self.label.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
//    
//    // 照片
//    if (imagesCount > 4) {
//        
//        _cellHeight += CGRectGetHeight(self.collectionView.frame);
//    }else {
//        
//        _cellHeight += (CGRectGetHeight(self.collectionView.frame) + margin * 4 )* 2 + margin;
//    }
    
    
    return _cellHeight;
}

@end

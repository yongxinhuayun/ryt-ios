//
//  ArtworkListModel.m
//  融易投
//
//  Created by efeiyi on 16/5/9.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtworkListModel.h"

@implementation ArtworkListModel


-(CGFloat)cellHeight{
    CGFloat margin = 10;
    CGFloat iconImageViewY = 233;
    CGFloat maxY = iconImageViewY + margin;
    
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * 10;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGFloat titleH = [self.title boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil].size.height;
    
    maxY = maxY + titleH + margin;
    
    CGFloat projectMoneyH = [[NSString stringWithFormat:@"%zd",self.investGoalMoney] boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12] } context:nil].size.height;
    
    maxY = maxY + projectMoneyH + margin;
    
    CGFloat briefH = [self.brief boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12] } context:nil].size.height;
    
     maxY = maxY + briefH + margin * 2;
    
    //判断当前项目处于什么状态
    UserMyModel *userModel = TakeLoginUserModel;
    CGFloat bottomViewY = 50;
    //自己看自己
    if ([self.author.ID isEqualToString:userModel.ID]) {
        
        if ([self.step isEqualToString:@"100"]){ //可以编辑项目
            
            return maxY + bottomViewY + margin;
            
        }else if ([self.step isEqualToString:@"21"]||[self.step isEqualToString:@"22"]){//可以点击创作完成和发布动态
            
            return maxY + bottomViewY + margin;
            
        }else {//其他什么也不显示
            
            return maxY + margin;
        }
        
    }else {  //别人看自己
    
         return maxY + margin;
    }
}

@end

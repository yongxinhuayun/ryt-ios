//
//  AuctionModel.m
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "AuctionModel.h"

@implementation AuctionModel


-(CGFloat)cellH{
    
    CGFloat margin = 12;
    CGFloat iconImageViewY = 252;
    CGFloat maxY = margin + iconImageViewY + 10;
    
    CGFloat userIconY = 64;
    maxY = maxY + userIconY + 10 + 10;
    
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * 20;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSString *title = @"拍卖时间";

    if ([self.step isEqualToString:@"30"]) {

        title = @"拍卖时间";
        CGFloat titleH = [title boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil].size.height;
        
        maxY = maxY + titleH + 15 + 10;
        
        return maxY + 10;
        
    }else if ([self.step isEqualToString:@"31"]){
        
        title = @"当前出价";
        CGFloat titleH1 = [title boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil].size.height;
        
        maxY = maxY + titleH1 + 15;
        

        title = @"出价次数";
        CGFloat titleH2 = [title boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil].size.height;
        
        maxY = maxY + titleH2 + 10;
        
        return maxY;
        
    }else if ([self.step isEqualToString:@"32"]) {
        
        title = @"拍卖得主";
        CGFloat titleH1 = [title boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil].size.height;
        
        maxY = maxY + titleH1 + 15;
        
        title = @"成交价格";
        CGFloat titleH2 = [title boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil].size.height;
        
        maxY = maxY + titleH2 + 8;
        
        title = @"出价次数";
        CGFloat titleH3 = [title boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14] } context:nil].size.height;
        
        maxY = maxY + titleH3 + 10;
     
        return maxY;
    }else {
        
        SSLog(@"%f",maxY);
        
        return maxY + margin * 2;
    }
}


@end

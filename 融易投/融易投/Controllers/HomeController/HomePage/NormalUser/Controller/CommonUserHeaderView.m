//
//  OtherHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonUserHeaderView.h"

#import "PageInfoModel.h"

@interface CommonUserHeaderView ()


@end

@implementation CommonUserHeaderView

-(void)awakeFromNib{

//    self.otherView.hidden = YES;
//    self.otherView.height = 0;
//    self.otherViewTopCons = 0;
//    self.otherViewBottomCons = 0;
}

-(void)setModel:(PageInfoModel *)model{

    _model = model;
    //用户头像
    NSString *iconUrlStr = [[NSString stringWithFormat:@"%@",self.model.user.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *iconUrlURL = [NSURL URLWithString:iconUrlStr];
    
    [self.iconImageView  ss_setHeader:iconUrlURL];
    
    //用户名
    self.userLabel.text = self.model.user.name;
    //用户签名
    self.userNickNameLabel.text = self.model.user.username;
    //用户关注数
    self.guanzhuLabel.text = [NSString stringWithFormat:@"%zd",self.model.num];
    //用户粉丝数
    self.fansLabel.text = [NSString stringWithFormat:@"%zd",self.model.followNum];
    //投资金额
    self.inverstMoneyLabel.text = [NSString stringWithFormat:@"%zd",self.model.sumInvestment];
    //投资收益
    self.inverstProfitLabel.text = [NSString stringWithFormat:@"%zd",self.model.yield];
    //投资回报率
    CGFloat sumInvestmentFloat = self.model.sumInvestment;
    CGFloat yieldFloat = self.model.yield;
    self.InvestRateLabel.text = [NSString stringWithFormat:@"%zd%%",((sumInvestmentFloat /yieldFloat) * 100)];

    
}

@end

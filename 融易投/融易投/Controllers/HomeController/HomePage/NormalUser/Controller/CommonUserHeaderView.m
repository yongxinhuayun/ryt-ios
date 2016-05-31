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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InverstConstraint;



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
    self.userNickNameLabel.text = self.model.user.userBrief.signer;
    //用户关注数
    self.guanzhuLabel.text = [NSString stringWithFormat:@"%zd",self.model.num];
    //用户粉丝数
    self.fansLabel.text = [NSString stringWithFormat:@"%zd",self.model.followNum];
    //投资金额
    self.inverstMoneyLabel.text = [NSString stringWithFormat:@"%zd",self.model.sumInvestment];
    //投资收益
    self.inverstProfitLabel.text = [NSString stringWithFormat:@"%zd",self.model.yield];
    self.focusBtn.selected = self.model.followed;
    //投资回报率
    //投资回报率
    float sumInvestmentFloat = NAN;
    float yieldFloat = NAN;
    
    if (!isnan(sumInvestmentFloat)&&!isnan(yieldFloat)) {
        
        sumInvestmentFloat = [self.inverstMoneyLabel.text doubleValue];
        yieldFloat = [self.inverstProfitLabel.text doubleValue];
        
    }else {
        
        sumInvestmentFloat = 0.00;
        yieldFloat = 0.00;
    }
    
    
    NSLog(@"%f----%f",sumInvestmentFloat,yieldFloat);
    
    float investRate = NAN;
    
    if (!isnan(investRate)) {
        
        self.InvestRateLabel.text = [NSString stringWithFormat:@"%.2f%%",((yieldFloat / sumInvestmentFloat) * 100)];
        
    }else {
        
        self.InvestRateLabel.text = @"0.00%";
    }
}

- (IBAction)clickLetter:(UIButton *)sender {
    // 点击发送私信
    if ([self.delegate respondsToSelector:@selector(postPrivateLetter)]) {
        [self.delegate postPrivateLetter];
    }
}

- (IBAction)clickConcern:(UIButton *)sender {
    //加关注
    if ([self.delegate respondsToSelector:@selector(addConcern)]) {
        [self.delegate addConcern];
    }
}



@end

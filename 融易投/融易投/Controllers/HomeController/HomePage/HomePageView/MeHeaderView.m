//
//  MeHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MeHeaderView.h"




#import "UIImageView+WebCache.h"




@interface MeHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuNum;

@property (weak, nonatomic) IBOutlet UILabel *fansNum;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UILabel *sumInvestment;
@property (weak, nonatomic) IBOutlet UILabel *investmentIncome;
@property (weak, nonatomic) IBOutlet UILabel *investRate;


@end

@implementation MeHeaderView

+(instancetype)meHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    
    //设置图片能够点击
    //记住:UIImageView默认情况下是不能接收事件的,如果要执行点击方法,必须把默认的User interaction Enable 改成yes
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.iconImageView addGestureRecognizer:tapGesture];
    
    [self FocusBtnClick:nil];
}

-(void)setModel:(PageInfoModel *)model{

    _model = model;
    
    if (!model) {
        //头像
        self.iconImageView.image = [UIImage imageNamed:@"jibenziliao_touxiang"];
        //用户名
        self.userName.text = @"游客";
        //用户签名
        self.signature.text = @"个性签名:一句话20字以内";
        //用户关注数
        self.guanzhuNum.text = @"0";
        //用户粉丝数
        self.fansNum.text = @"0";
        //投资金额
        self.sumInvestment.text = @"0";
        //投资收益
        self.investmentIncome.text = @"0";
        //投资回报率
        self.investRate.text = @"0.00%";
        
        return;
    }
    
    //用户头像
    NSString *iconUrlStr = [[NSString stringWithFormat:@"%@",model.user.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *iconUrlURL = [NSURL URLWithString:iconUrlStr];
    
    SSLog(@"%@",iconUrlURL);
    //pictureUrl":"http://rongyitou2.efeiyi.com/headPortrait/18513234278headPortrait.jpg"
    
    [self.iconImageView  ss_setHeader:iconUrlURL];
    
    //用户名
    self.userName.text = model.user.name;
    //用户签名
    self.signature.text = model.user.userBrief.signer;
    //用户关注数
    self.guanzhuNum.text = [NSString stringWithFormat:@"%zd",model.num];
    //用户粉丝数
    self.fansNum.text = [NSString stringWithFormat:@"%zd",model.followNum];
    //投资金额
    self.sumInvestment.text = [NSString stringWithFormat:@"%zd",model.sumInvestment];
    //投资收益
    self.investmentIncome.text = [NSString stringWithFormat:@"%zd",model.yield];

    //投资回报率
    float sumInvestmentFloat = NAN;
    float yieldFloat = NAN;
    
    if (!isnan(sumInvestmentFloat)&&!isnan(yieldFloat)) {
        
        sumInvestmentFloat = [self.sumInvestment.text doubleValue];
        yieldFloat = [self.investmentIncome.text doubleValue];
        
    }else {
    
        sumInvestmentFloat = 0.00;
        yieldFloat = 0.00;
    }
    

    NSLog(@"%f----%f",sumInvestmentFloat,yieldFloat);
    
    float investRate = NAN;
    
    if (!isnan(investRate)) {
        
       self.investRate.text = [NSString stringWithFormat:@"%.2f%%",((yieldFloat / sumInvestmentFloat) * 100)];
        
    }else {
        
       self.investRate.text = @"0.00%";
    }
}


-(void)tap {
    
    if (_editingInfoBlcok != nil) {
        _editingInfoBlcok();
    }
    
}

- (IBAction)FocusBtnClick:(id)sender {
    
    if (_focusBlcok != nil) {
        _focusBlcok();
    }
    
}

- (IBAction)FansBtnClick:(id)sender {
    
    if (_fansBlcok != nil) {
        _fansBlcok();
    }
    
}

@end

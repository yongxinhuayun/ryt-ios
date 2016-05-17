//
//  FinanceDetailFirstCell.m
//  融易投
//
//  Created by efeiyi on 16/4/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceDetailFirstCell.h"

#import "FinanceModel.h"

#import "UIImageView+WebCache.h"

@interface FinanceDetailFirstCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *financeTitle;
@property (weak, nonatomic) IBOutlet UILabel *financeIntroductionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;

@property (weak, nonatomic) IBOutlet UILabel *targetMoney;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *investNum;

@end

@implementation FinanceDetailFirstCell

-(void)setModel:(FinanceModel *)model{
    
    _model= model;
    
    NSString *picture_urlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *picture_urlURL = [NSURL URLWithString:picture_urlStr];
    
    //    NSLog(@"%@",picture_urlURL);
    
    [self.bgImageView sd_setImageWithURL:picture_urlURL];
    
    self.targetMoney.text = [NSString stringWithFormat:@"%ld元",model.investGoalMoney];
    
    //设置融资剩余时间
    float begainTime= model.investStartDatetime;
    float endTime = model.investEndDatetime;
    float investInteral = endTime - begainTime;
    
    NSDate *newCreationEmdTimesp = [NSDate dateWithTimeIntervalSince1970:investInteral];
    
    //设置时间格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH时mm分ss秒"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:newCreationEmdTimesp];
    //添加时间
    self.endTime.text = timeStr;
    
    //设置投资人数
    self.investNum.text = [NSString stringWithFormat:@"%ld",model.investNum];
    
    //设置投资标题
    self.financeTitle.text = model.title;
    //设置投资描述
    self.financeIntroductionLabel.text = model.brief;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    //    NSLog(@"%@",pictureUrlURL);
    
    [self.userIcon ss_setHeader:pictureUrlURL];
    
    self.userName.text = model.author.name;
    self.userInfo.text = model.author.username;

}

@end

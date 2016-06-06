//
//  ZanguoProjectCell.m
//  融易投
//
//  Created by efeiyi on 16/5/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ZanguoProjectCell.h"

#import "PageInfoListModel.h"
#import "ZanguoArtworkModel.h"
#import "CommonButton.h"
#import "CommonBtn.h"
#import "UIImageView+WebCache.h"
#import "ArtworkModel.h"
#import "authorModel.h"
#import "MasterModel.h"

@interface ZanguoProjectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;

@property (weak, nonatomic) IBOutlet UIButton *projectStepBtn;
//@property (weak, nonatomic) IBOutlet CommonButton *praiseBtn;

@property (weak, nonatomic) IBOutlet CommonBtn *praiseBtn;

@end

@implementation ZanguoProjectCell

-(void)setModel:(ArtworkModel *)model{
    
    _model = model;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.backgroundImage sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    
    self.title.text = model.title;
    
    self.totalMoney.text = [NSString stringWithFormat:@"%ld",model.investGoalMoney];
    
    //判断当前项目处于什么状态
    UserMyModel *userModel = TakeLoginUserModel;
    
    //自己看自己
    if ([model.author.ID isEqualToString:userModel.ID]) {
        
        //当艺术家看自己的项目时
        if ([model.step isEqualToString:@"10"]) {
            [self.projectStepBtn setTitle:@"项目待审核" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"11"]){
            [self.projectStepBtn setTitle:@"项目审核中" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"13"]) {
            [self.projectStepBtn setTitle:@"审核未通过" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"14"]) {
            [self.projectStepBtn setTitle:@"融资中" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"21"]) {
            [self.projectStepBtn setTitle:@"创作中" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"22"]) {
            [self.projectStepBtn setTitle:@"创作延时" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"24"]) {
            [self.projectStepBtn setTitle:@"创作完成审核中" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"25"]) {
            [self.projectStepBtn setTitle:@"创作完成被驳回" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"100"]){
            [self.projectStepBtn setTitle:@"编辑阶段,尚未提交" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"30"]) {
            [self.projectStepBtn setTitle:@"拍卖前" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"32"]) {
            [self.projectStepBtn setTitle:@"拍卖中" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"32"]) {
            [self.projectStepBtn setTitle:@"拍卖结束" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"33"]) {
            [self.projectStepBtn setTitle:@"流拍" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"34"]) {
            [self.projectStepBtn setTitle:@"待支付尾款" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"35"]) {
            [self.projectStepBtn setTitle:@"待发放" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"36"]) {
            [self.projectStepBtn setTitle:@"已发送" forState:UIControlStateNormal];
        }else {
            //            [self.projectStepBtn setTitle:@"" forState:UIControlStateNormal];
            self.projectStepBtn.hidden = YES;
        }
    }else{ //别人看自己
        
        //当其他用户看艺术家主页项目时
        if ([model.step isEqualToString:@"10"]||[model.step isEqualToString:@"11"]){
            [self.projectStepBtn setTitle:@"审核阶段" forState:UIControlStateNormal];
            
        }else if ([model.step isEqualToString:@"12"]||[model.step isEqualToString:@"14"]||[model.step isEqualToString:@"15"]){
            
            [self.projectStepBtn setTitle:@"融资阶段" forState:UIControlStateNormal];
            
        }else if ([model.step isEqualToString:@"21"]||[model.step isEqualToString:@"22"]||[model.step isEqualToString:@"23"]||[model.step isEqualToString:@"24"]||[model.step isEqualToString:@"25"]){
            [self.projectStepBtn setTitle:@"创作阶段" forState:UIControlStateNormal];
        }else {
            [self.projectStepBtn setTitle:@"拍卖阶段" forState:UIControlStateNormal];
        }
    }
    
    
    //作者信息
    NSString *iconUrlStr = [[NSString stringWithFormat:@"%@",model.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *iconUrlURL = [NSURL URLWithString:iconUrlStr];
    
    [self.userIcon ss_setHeader:iconUrlURL];
    
    self.userName.text = model.author.name;
    self.userTitle.text = model.author.master.title;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",model.praiseNUm] forState:(UIControlStateNormal)];
    [self.praiseBtn setTitleColor:[UIColor colorWithRed:240.0 / 255.0 green:90.0 / 255.0 blue:72.0 / 255.0 alpha:1.0] forState:(UIControlStateSelected)];
    self.praiseBtn.selected = YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

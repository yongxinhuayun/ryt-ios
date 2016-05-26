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

#import "UIImageView+WebCache.h"

@interface ZanguoProjectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;

@property (weak, nonatomic) IBOutlet UIButton *projectStepBtn;

@end

@implementation ZanguoProjectCell


-(void)setModel:(PageInfoListModel *)model{
    
    _model = model;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.artwork.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.backgroundImage sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    
    self.title.text = model.artwork.title;
    
    self.totalMoney.text = [NSString stringWithFormat:@"%ld",model.artwork.investGoalMoney];
    
    //判断当前项目处于什么状态
    UserMyModel *userModel = TakeLoginUserModel;
    
    //自己看自己
    if ([model.user.ID isEqualToString:userModel.ID]) {
        
        //当艺术家看自己的项目时
        if ([model.artwork.step isEqualToString:@"10"]) {
            [self.projectStepBtn setTitle:@"项目待审核" forState:UIControlStateNormal];
        }else if ([model.artwork.step isEqualToString:@"11"]){
            [self.projectStepBtn setTitle:@"项目审核中" forState:UIControlStateNormal];
        }else if ([model.artwork.step isEqualToString:@"13"]) {
            [self.projectStepBtn setTitle:@"审核未通过" forState:UIControlStateNormal];
        }else if ([model.artwork.step isEqualToString:@"14"]) {
            [self.projectStepBtn setTitle:@"融资中" forState:UIControlStateNormal];
        }else if ([model.artwork.step isEqualToString:@"21"]) {
            [self.projectStepBtn setTitle:@"创作中" forState:UIControlStateNormal];
        }else if ([model.artwork.step isEqualToString:@"22"]) {
            [self.projectStepBtn setTitle:@"创作延时" forState:UIControlStateNormal];
        }else if ([model.artwork.step isEqualToString:@"24"]) {
            [self.projectStepBtn setTitle:@"创作完成审核中" forState:UIControlStateNormal];
        }else if ([model.artwork.step isEqualToString:@"25"]) {
            [self.projectStepBtn setTitle:@"创作完成被驳回" forState:UIControlStateNormal];
        }else if ([model.artwork.step isEqualToString:@"100"]){
            [self.projectStepBtn setTitle:@"编辑阶段,尚未提交" forState:UIControlStateNormal];
        }else {
            [self.projectStepBtn setTitle:@"" forState:UIControlStateNormal];
        }
        
        /*
         else if ([model.step isEqualToString:@"30"]) {
         
         self.stepBtn.hidden = NO;
         [self.stepBtn setTitle:@"拍卖前" forState:UIControlStateNormal];
         }else if ([model.step isEqualToString:@"32"]) {
         
         self.stepBtn.hidden = NO;
         [self.stepBtn setTitle:@"拍卖中" forState:UIControlStateNormal];
         }else if ([model.step isEqualToString:@"32"]) {
         
         self.stepBtn.hidden = NO;
         [self.stepBtn setTitle:@"拍卖结束" forState:UIControlStateNormal];
         }else if ([model.step isEqualToString:@"33"]) {
         
         self.stepBtn.hidden = NO;
         [self.stepBtn setTitle:@"流拍" forState:UIControlStateNormal];
         }else if ([model.step isEqualToString:@"34"]) {
         
         self.stepBtn.hidden = NO;
         [self.stepBtn setTitle:@"待支付尾款" forState:UIControlStateNormal];
         }else if ([model.step isEqualToString:@"35"]) {
         
         self.stepBtn.hidden = NO;
         [self.stepBtn setTitle:@"待发放" forState:UIControlStateNormal];
         }else if ([model.step isEqualToString:@"36"]) {
         
         self.stepBtn.hidden = NO;
         [self.stepBtn setTitle:@"已发送" forState:UIControlStateNormal];
         }else{
         
         self.stepBtn.hidden = YES;
         [self.stepBtn setTitle:@"" forState:UIControlStateNormal];
         }
         */
    }else{ //别人看自己
        
        //当其他用户看艺术家主页项目时
        if ([model.artwork.step isEqualToString:@"10"]||[model.artwork.step isEqualToString:@"11"]){
            [self.projectStepBtn setTitle:@"审核阶段" forState:UIControlStateNormal];
            
        }else if ([model.artwork.step isEqualToString:@"12"]||[model.artwork.step isEqualToString:@"14"]||[model.artwork.step isEqualToString:@"15"]){
            
            [self.projectStepBtn setTitle:@"融资阶段" forState:UIControlStateNormal];
            
        }else if ([model.artwork.step isEqualToString:@"21"]||[model.artwork.step isEqualToString:@"22"]||[model.artwork.step isEqualToString:@"23"]||[model.artwork.step isEqualToString:@"24"]||[model.artwork.step isEqualToString:@"25"]){
            [self.projectStepBtn setTitle:@"创作阶段" forState:UIControlStateNormal];
        }else {
            [self.projectStepBtn setTitle:@"拍卖阶段" forState:UIControlStateNormal];
        }
    }
    
        
    //作者信息
    NSString *iconUrlStr = [[NSString stringWithFormat:@"%@",model.artwork.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *iconUrlURL = [NSURL URLWithString:iconUrlStr];
    
    [self.userIcon ss_setHeader:iconUrlURL];
    
    self.userName.text = model.artwork.author.name;
    self.userTitle.text = model.artwork.author.master.title;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

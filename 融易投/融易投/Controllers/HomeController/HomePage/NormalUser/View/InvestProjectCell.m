//
//  InvestProjectCell.m
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "InvestProjectCell.h"
#import "PageInfoModel.h"
#import "ArtworksModel.h"

#import "UIImageView+WebCache.h"
#import "CommonButton.h"

@interface InvestProjectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;

@property (weak, nonatomic) IBOutlet UIButton *projectStepBtn;
@property (weak, nonatomic) IBOutlet CommonButton *dianzanBtn;

@end

@implementation InvestProjectCell


-(void)setModel:(ArtworksModel *)model{
    
    _model = model;
        
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.backgroundImage sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    
    self.title.text = model.title;
    
    self.totalMoney.text = [NSString stringWithFormat:@"%ld",model.goalMoney];
    
    //判断当前项目处于什么状态
    UserMyModel *userModel = TakeLoginUserModel;
    
    //自己看自己
    if ([model.user.ID isEqualToString:userModel.ID]) {
        
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
    NSString *iconUrlStr = [[NSString stringWithFormat:@"%@",model.user.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *iconUrlURL = [NSURL URLWithString:iconUrlStr];
    
    [self.userIcon ss_setHeader:iconUrlURL];
    
    self.userName.text = model.user.name;
    self.userTitle.text = model.user.master.title;
    
//    NSLog(@"%@",[NSString stringWithFormat:@"%zd",self.model.num.integerValue]);
//    
//    NSLog(@"%@",self.model.num);
    
    if ([[NSString stringWithFormat:@"%ld",self.model.praise] isEqualToString:@""]) {
         [self.dianzanBtn setTitle:@"0" forState:UIControlStateNormal];
    }
    [self.dianzanBtn setTitle:[NSString stringWithFormat:@"%ld",self.model.praise] forState:UIControlStateNormal];

}

/****************************************实现点赞功能***************************************** */

//实现点赞功能
- (IBAction)dianZanClick:(UIButton *)button {
    
    //当我们还要想取消赞的时候还要进行一下取消赞
    if (self.model.is_zan) { //取消赞
        
        //1. 按钮变成选中图片
        [button setImage:[UIImage imageNamed:@"dianzanqian"] forState:UIControlStateNormal];
        //2. 点赞数加一,直接修改模型中的数据,因为模型中的顶是个字符串,所以需要拼接
        self.model.num = [NSString stringWithFormat:@"%zd",self.model.praise - 1];
        self.model.is_zan = NO;
        
    }else{ //赞
        
        UILabel *num = [[UILabel alloc] initWithFrame:button.frame];
        num.center = button.center;
        num.textAlignment = NSTextAlignmentCenter;
        num.text = @"+1";
        num.textColor = [UIColor redColor];
        [self addSubview:num];
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat x = num.centerX;
            CGPoint p = CGPointMake(x, num.y - num.height);
            num.center = p;
            num.alpha = 0;
        } completion:^(BOOL finished) {
            [num removeFromSuperview];
        }];
        
        //1. 按钮变成选中图片
        [button setImage:[UIImage imageNamed:@"dianzanhou"] forState:UIControlStateNormal];
        //2. 点赞数加一,直接修改模型中的数据,因为模型中的顶是个字符串,所以需要拼接
        self.model.num = [NSString stringWithFormat:@"%zd",self.model.num.integerValue + 1];
        
        self.model.is_zan = YES;
    }
    
//    NSLog(@"%@",[NSString stringWithFormat:@"%zd",self.model.num.integerValue]);
    
    [button setTitle:self.model.num forState:UIControlStateNormal];
    

    //3. 发送请求
    [self zanToLoad];
}

-(void)zanToLoad{

    /*
     NSString *userId = @"18701526255";
     NSString *urlStr = @"artworkPraise.do";
     NSDictionary *json = @{
     @"artworkId" : self.artworkId,
     @"currentUserId": userId,
     };
     
     [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:self andBlock:^(id respondObj) {
     
     //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
     //        NSLog(@"返回结果:%@",jsonStr);
     
     NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
     NSString *str = modelDict[@"resultMsg"];
     
     if ([str isEqualToString:@"成功"]) {
     
     UILabel *num = [[UILabel alloc] initWithFrame:button.frame];
     num.center = button.center;
     num.textAlignment = NSTextAlignmentCenter;
     num.text = @"+1";
     num.textColor = [UIColor redColor];
     [self addSubview:num];
     [UIView animateWithDuration:0.5 animations:^{
     CGFloat x = num.centerX;
     CGPoint p = CGPointMake(x, num.y - num.height);
     num.center = p;
     num.alpha = 0;
     } completion:^(BOOL finished) {
     [num removeFromSuperview];
     }];
     
     //1. 按钮变成选中图片
     [button setImage:[UIImage imageNamed:@"dianzanhou"] forState:UIControlStateNormal];
     //2. 点赞数加一,直接修改模型中的数据,因为模型中的顶是个字符串,所以需要拼接
     self.model.num = [NSString stringWithFormat:@"%zd",self.model.num.integerValue + 1];
     
     self.model.is_zan = YES;
     }
     }];
     */
}
/****************************************实现点赞功能***************************************** */

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

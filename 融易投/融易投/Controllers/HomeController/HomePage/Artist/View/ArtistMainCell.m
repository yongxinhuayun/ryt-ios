//
//  MyArtworkCell.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistMainCell.h"
#import "ArtworkListModel.h"

#import "UIImageView+WebCache.h"
#import "SSProgressView.h"

@interface ArtistMainCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *projectTitle;
@property (weak, nonatomic) IBOutlet UILabel *projectTotal;
@property (weak, nonatomic) IBOutlet UILabel *projectDes;

@property (weak, nonatomic) IBOutlet UIButton *stepBtn;

@property (weak, nonatomic) IBOutlet SSProgressView *progressView;

@end



@implementation ArtistMainCell

-(void)setModel:(ArtworkListModel *)model{

    _model = model;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
//    [self.iconImageView sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    
    // 覆盖进度
    self.progressView.progress = model.pictureProgress;
    
    // 下载图片
    [self.iconImageView sd_setImageWithURL:pictureUrlURL placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        self.progressView.progress = 1.0 * receivedSize / expectedSize;
        model.pictureProgress = self.progressView.progress;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        model.pictureProgress = 1.0;
    }];
    
    self.projectTitle.text = model.title;
    self.projectTotal.text = [NSString stringWithFormat:@"%ld",model.investGoalMoney];
    self.projectDes.text = [NSString stringWithFormat:@"项目描述:   %@",model.brief];
    
    //判断当前项目处于什么状态
    UserMyModel *userModel = TakeLoginUserModel;
    
    //自己看自己
    if ([model.author.ID isEqualToString:userModel.ID]) {
        
        //当艺术家看自己的项目时
        if ([model.step isEqualToString:@"10"]) {
            
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"项目待审核" forState:UIControlStateNormal];
            
        }else if ([model.step isEqualToString:@"11"]){
            
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"项目审核中" forState:UIControlStateNormal];
            
        }else if ([model.step isEqualToString:@"13"]) {
            
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"审核未通过" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"14"]) {
            
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"融资中" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"21"]) {
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"创作中" forState:UIControlStateNormal];
            
            self.bottomView.hidden = NO;
            [self.btn1 setTitle:@"创作完成" forState:UIControlStateNormal];
            [self.btn2 setTitle:@"发布动态" forState:UIControlStateNormal];

            
        }else if ([model.step isEqualToString:@"22"]) {
            
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"创作延时" forState:UIControlStateNormal];
            
            self.bottomView.hidden = NO;
            [self.btn1 setTitle:@"创作完成" forState:UIControlStateNormal];
            [self.btn2 setTitle:@"发布动态" forState:UIControlStateNormal];

        }else if ([model.step isEqualToString:@"24"]) {
            
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"创作完成审核中" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"25"]) {
            
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"创作完成被驳回" forState:UIControlStateNormal];
        }else if ([model.step isEqualToString:@"100"]){
            
            self.bottomView.hidden = NO;
            [self.btn1 setTitle:@"提交项目" forState:UIControlStateNormal];
            [self.btn2 setTitle:@"编辑项目" forState:UIControlStateNormal];
            
        }else {
            
            self.bottomView.hidden = YES;
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
            
            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"审核阶段" forState:UIControlStateNormal];
            
        }else if ([model.step isEqualToString:@"12"]||[model.step isEqualToString:@"14"]||[model.step isEqualToString:@"15"]){

            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"融资阶段" forState:UIControlStateNormal];

        }else if ([model.step isEqualToString:@"21"]||[model.step isEqualToString:@"22"]||[model.step isEqualToString:@"23"]||[model.step isEqualToString:@"24"]||[model.step isEqualToString:@"25"]){

            self.stepBtn.hidden = NO;
            [self.stepBtn setTitle:@"创作阶段" forState:UIControlStateNormal];
        }else {

            self.stepBtn.hidden = YES;
            [self.stepBtn setTitle:@"" forState:UIControlStateNormal];   
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

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
    
    if ([model.artwork.step isEqualToString:@"12"]||[model.artwork.step isEqualToString:@"14"]||[model.artwork.step isEqualToString:@"15"]){
        
        [self.projectStepBtn setTitle:@"融资阶段" forState:UIControlStateNormal];
        
    }else if ([model.artwork.step isEqualToString:@"21"]||[model.artwork.step isEqualToString:@"22"]||[model.artwork.step isEqualToString:@"23"]||[model.artwork.step isEqualToString:@"24"]){
        
        [self.projectStepBtn setTitle:@"创作阶段" forState:UIControlStateNormal];
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

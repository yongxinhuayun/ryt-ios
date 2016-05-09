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

@interface ArtistMainCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *projectTitle;
@property (weak, nonatomic) IBOutlet UILabel *projectTotal;
@property (weak, nonatomic) IBOutlet UILabel *projectDes;

@property (weak, nonatomic) IBOutlet UIButton *stepBtn;


@end



@implementation ArtistMainCell

-(void)setModel:(ArtworkListModel *)model{

    _model = model;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.iconImageView sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    
    self.projectTitle.text = model.title;
    self.projectTotal.text = [NSString stringWithFormat:@"%ld",model.investGoalMoney];
    self.projectDes.text = [NSString stringWithFormat:@"项目描述:   %@",model.brief];
    
    //判断当前项目处于什么状态
    if ([model.step isEqualToString:@"12"]||[model.step isEqualToString:@"14"]||[model.step isEqualToString:@"15"]){
        
        self.stepBtn.hidden = NO;
        [self.stepBtn setTitle:@"融资阶段" forState:UIControlStateNormal];

    }else if ([model.step isEqualToString:@"21"]||[model.step isEqualToString:@"22"]||[model.step isEqualToString:@"23"]||[model.step isEqualToString:@"24"]){
        
         self.stepBtn.hidden = NO;
        [self.stepBtn setTitle:@"创作阶段" forState:UIControlStateNormal];
    }else {
        
        self.stepBtn.hidden = YES;
        [self.stepBtn setTitle:@"" forState:UIControlStateNormal];
        
    }
    
    //判断当前项目处于什么状态
    if ([model.step isEqualToString:@"100"]){
        
        self.bottomView.hidden = NO;
        [self.btn1 setTitle:@"提交项目" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"编辑项目" forState:UIControlStateNormal];
    
    }else if ([model.step isEqualToString:@"24"]||[model.step isEqualToString:@"25"]){
        
        self.bottomView.hidden = NO;
        [self.btn1 setTitle:@"创作完成" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"发布动态" forState:UIControlStateNormal];
        
    }else {
        
        self.bottomView.hidden = YES;
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

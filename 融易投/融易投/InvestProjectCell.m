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


@interface InvestProjectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;

@property (weak, nonatomic) IBOutlet UIButton *projectStepBtn;

@end

@implementation InvestProjectCell


-(void)setModel:(ArtworksModel *)model{
    
    _model = model;
    
//    NSLog(@"%@",model.artworks);
    
//    NSMutableArray *array = model.artworks;

//    for (ArtworksModel *model in array) {
//        
//        NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
//        
//        [self.backgroundImage ss_setHeader:pictureUrlURL];
//        
//        self.title.text = model.title;
//        
//        self.totalMoney.text = [NSString stringWithFormat:@"%ld",model.goalMoney];
//        
//        //判断当前项目处于什么状态
//        
//        if ([model.step isEqualToString:@"12"]||[model.step isEqualToString:@"14"]||[model.step isEqualToString:@"15"]){
//            
//            [self.projectStepBtn setTitle:@"融资阶段" forState:UIControlStateNormal];
//            
//        }else if ([model.step isEqualToString:@"21"]||[model.step isEqualToString:@"22"]||[model.step isEqualToString:@"23"]||[model.step isEqualToString:@"24"]){
//            
//             [self.projectStepBtn setTitle:@"创作阶段" forState:UIControlStateNormal];
//        }
    
        /*
        if ([model.step isEqualToString:@"10"]) {
            
            
        }else if ([model.step isEqualToString:@"11"]){
 
        }else if ([model.step isEqualToString:@"12"]) {
            
            
        }else if ([model.step isEqualToString:@"13"]) {
            
            
        }else if ([model.step isEqualToString:@"14"]) {
            
            
        }else if ([model.step isEqualToString:@"15"]) {
            
            
        }else if ([model.step isEqualToString:@"20"]) {
            
            
        }else if ([model.step isEqualToString:@"21"]) {
            
            
        }else if ([model.step isEqualToString:@"22"]) {
            
            
        }else if ([model.step isEqualToString:@"23"]) {
            
            
        }else if ([model.step isEqualToString:@"24"]) {
            
            
        }else if ([model.step isEqualToString:@"25"]) {
            
            
        }
         */
//    }
    
    
    
//    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.user.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
//    
//    [self.userIcon ss_setHeader:pictureUrlURL];
//    
//    self.userName.text = model.user.name;
//    self.userTitle.text = model.user.master.title;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

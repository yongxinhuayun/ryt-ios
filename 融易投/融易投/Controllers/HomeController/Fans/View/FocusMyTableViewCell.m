//
//  FocusMyTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FocusMyTableViewCell.h"
#import "PageInfoListMyModel.h"

@interface FocusMyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@end

@implementation FocusMyTableViewCell

-(void)setModel:(PageInfoListMyModel *)model{
    
    _model = model;
    
    //代表type为1,model.master有值,为艺术家
    if (model.master) {
        
        NSString *pictureUrlStr = [[NSString stringWithFormat:@"http://tenant.efeiyi.com/%@",model.master.favicon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
        
        [self.iconImageView ss_setHeader:pictureUrlURL];
        
        self.userNameLabel.text = model.artUserFollowed.follower.name;
        
        self.descriptionLabel.text = model.master.title;
    }else { //代表type为2,model.master无值,为普通用户
    
        NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.artUserFollowed.follower.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
        
        [self.iconImageView ss_setHeader:pictureUrlURL];
        
        self.userNameLabel.text = model.artUserFollowed.follower.name;
        
        self.descriptionLabel.text = model.userBrief.content;
    }
    
    //flag为1 为已关注
    if ([model.flag isEqualToString:@"1"]) {
        
        self.focusBtn.selected = YES;
        self.focusBtn.userInteractionEnabled = NO;
        
    }else {  //flag为2 为未关注
        
        self.focusBtn.selected = NO;
        self.focusBtn.userInteractionEnabled = YES;
    }
    
    
}
- (IBAction)focusBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

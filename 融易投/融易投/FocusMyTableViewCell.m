//
//  FocusMyTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FocusMyTableViewCell.h"
#import "FocusMyModel.h"

@interface FocusMyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation FocusMyTableViewCell

-(void)setModel:(FocusMyModel *)model{
    
    _model = model;
    
    //   NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    //
    //    [self.iconImageView ss_setHeader:pictureUrlURL];
    
    //    self.userNameLabel.text =
    
    //    self.descriptionLabel.text =
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

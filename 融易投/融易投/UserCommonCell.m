//
//  UserCommonCell.m
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UserCommonCell.h"

#import "UIImageView+WebCache.h"

@interface UserCommonCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commonLabel;

@end

@implementation UserCommonCell


-(void)setModel:(ArtworkCommentListModel *)model{

    _model = model;
    
    NSLog(@"%@",model.creator.pictureUrl);
    
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.creator.pictureUrl] placeholderImage:nil];
//    self.userNameLabel.text = model.creator.name;
//    self.commonLabel.text = model.content;
    
}

- (void)awakeFromNib {
    
    // Initialization code
}



@end

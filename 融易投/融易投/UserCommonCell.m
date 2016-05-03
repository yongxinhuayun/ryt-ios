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

@property (weak, nonatomic) IBOutlet UILabel *commentTime;

@end

@implementation UserCommonCell


-(void)setModel:(ArtworkCommentListModel *)model{

    _model = model;
    
//    NSLog(@"%@",model);
//    
//    NSLog(@"%@",model.content);
    
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.creator.pictureUrl] placeholderImage:nil];
//    self.userNameLabel.text = model.creator.name;
//    self.commonLabel.text = model.content;
    
}

- (void)awakeFromNib {
    
    // Initialization code
}



@end

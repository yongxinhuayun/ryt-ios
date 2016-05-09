//
//  UserCommonCell.m
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UserCommonCell.h"

#import "UIImageView+WebCache.h"

#import "CreatorModel.h"
#import <UIKit/UIKit.h>
@interface UserCommonCell ()<UITextViewDelegate>


@end

@implementation UserCommonCell


-(void)setModel:(ArtworkCommentListModel *)model{

    _model = model;
    NSString *urlStr = [model.creator.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:urlStr];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView ss_setHeader:url];
    [self.userPic setImage:imgView.image forState:(UIControlStateNormal)];
//    self.userName.titleLabel.text = model.creator.name;
    [self.userName setTitle:model.creator.name forState:(UIControlStateNormal)];
//    self.replyTime.text = model.createDatetime;
    self.content.text = model.content;
    
    
    
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

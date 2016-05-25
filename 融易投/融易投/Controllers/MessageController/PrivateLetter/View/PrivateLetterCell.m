//
//  PrivateLetterCell.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/19.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "PrivateLetterCell.h"
#import "PrivateLetterModel.h"
#import "UserMyModel.h"
#import <UIImageView+WebCache.h>

@interface PrivateLetterCell()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *bridge;

@end

@implementation PrivateLetterCell

-(void)setLetterModel:(PrivateLetterModel *)letterModel{
    _letterModel = letterModel;
    NSString *pictStr = [letterModel.fromUser.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:pictStr] placeholderImage:nil];
    self.userName.text =letterModel.fromUser.name;
       NSInteger count = [letterModel.isRead intValue];
    if (count>99) {
        self.bridge.hidden = NO;
        self.bridge.text = @"99+";
    }else if(count < 10 && count > 0){
        self.bridge.hidden = NO;
        self.bridge.text = letterModel.isRead;
    }else{
        self.bridge.hidden = YES;
    }
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userIcon.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

@end

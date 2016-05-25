//
//  RecordTableViewCell.m
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "RecordModel.h"
#import "UserMyModel.h"
#import "NSDate+Interval.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    
}

-(void)setModel:(RecordModel *)model{
    _model = model;
    NSString *url = [[NSString stringWithFormat:@"%@",model.creator.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView ss_setHeader:[NSURL URLWithString:url]];
//    [self.userIcon setImage:imgView.image forState:(UIControlStateNormal)];
    [self.userIcon setBackgroundImage:imgView.image forState:(UIControlStateNormal)];
    self.userName.text = model.creator.name;
    self.price.text = [NSString stringWithFormat:@"%ld 元",model.price];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createDatetime / 1000];
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dTime = [date createdAt:[dfm stringFromDate:date]];
    self.investTime.text = dTime;
}

- (IBAction)clickUserIcon:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickUserBtnIcon:)]) {
        [self.delegate clickUserBtnIcon:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

@end

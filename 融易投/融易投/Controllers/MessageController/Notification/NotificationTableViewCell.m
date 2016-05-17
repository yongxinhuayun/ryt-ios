//
//  NotificationTableViewCell.m
//  融易投
//
//  Created by dongxin on 16/4/8.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "NotificationModel.h"

#import <UIImageView+WebCache.h>


@interface NotificationTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDatetimeLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@end
@implementation NotificationTableViewCell

-(void)setModel:(NotificationModel *)model{
    _model= model;
    float investInteral =model.createDatetime.floatValue / 1000;
    NSDate *newCreationEmdTimesp = [NSDate dateWithTimeIntervalSince1970:investInteral];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"nimei");
    NSString *timeStr=[formatter stringFromDate:newCreationEmdTimesp];
//    self.idLabel.text = model.ID;
    self.contentLabel.text = model.content;
    self.createDatetimeLabel.text = timeStr;
    NSString *str = [model.fromUser.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *pictureURL = [NSURL URLWithString:str];
    NSLog(@"%@",str);
    [self.userIcon ss_setHeader:pictureURL];
    ;
//    self.imageView
}

@end

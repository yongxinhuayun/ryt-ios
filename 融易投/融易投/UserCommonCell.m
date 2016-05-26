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
#import "NSDate+Interval.h"
#import <UIKit/UIKit.h>
@interface UserCommonCell ()
@end

@implementation UserCommonCell

-(void)setModel:(ArtworkCommentListModel *)model{

    _model = model;
    NSString *urlStr = [model.creator.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:urlStr];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView ss_setHeader:url];
    [self.userPic setBackgroundImage:imgView.image forState:(UIControlStateNormal)];
    [self.userName setTitle:model.creator.name forState:(UIControlStateNormal)];
    self.replyTime.text = [self getTime:model.createDatetime];
    
    self.content.text = model.content;
}
-(NSString *)getTime:(NSInteger)creatTime{
    NSDate *newCreationEmdTimesp = [NSDate dateWithTimeIntervalSince1970:creatTime / 1000];
    //设置时间格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:newCreationEmdTimesp];
    NSDate *date = [[NSDate alloc] init];
    NSString *time = [date createdAt:timeStr];
    
    return time;
}

- (IBAction)clickUserIcon:(UIButton *)sender {
    NSLog(@"当前cell= %@",self);
    if ([self.delegate respondsToSelector:@selector(clickUserIconOrName:)]) {
        [self.delegate clickUserIconOrName:self.indexPath];
    }
}

- (void)awakeFromNib {
}



@end

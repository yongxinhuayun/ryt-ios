//
//  CreationTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CreationTableViewCell.h"

#import "CreationModel.h"

#import "UIImageView+WebCache.h"

@interface CreationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *creationTitle;
@property (weak, nonatomic) IBOutlet UILabel *creationIntroductionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *LastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;

@end

@implementation CreationTableViewCell

+(instancetype)creationCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


-(void)setModel:(CreationModel *)model{
    
    _model= model;
    
    //设置项目背景图片
    NSString *picture_urlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *picture_urlURL = [NSURL URLWithString:picture_urlStr];
    
    //    NSLog(@"%@",picture_urlURL);
    
    [self.bgImageView sd_setImageWithURL:picture_urlURL placeholderImage:[UIImage imageNamed:@"基本资料-未传头像"]];
    
    //最新创作时间
    
    //将时间戳转换成NSData类型，接着将NSData转换为字符串
    //将时间戳转换为对象类型
    float timeV= model.newCreationEmdDatetime;
    
    //    NSDate *newCreationEmdTimesp = [NSDate dateWithTimeIntervalSince1970:model.newCreationEmdDatetime];
    //
    //    self.LastUpdateLabel.text = [NSString stringWithFormat:@"%@",newCreationEmdTimesp];
    //
    self.LastUpdateLabel.text = [NSString stringWithFormat:@"%f",timeV];
    
    //创作结束时间
    NSDate *creationEndDateTimesp = [NSDate dateWithTimeIntervalSince1970:model.creationEndDatetime];
    //设置时间格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:creationEndDateTimesp];
    //添加时间
    self.scheduleLabel.text = timeStr;
    
    
    //创作标题
    self.creationTitle.text = model.title;
    //创作简介
    self.creationIntroductionLabel.text = model.descriptions;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.userIcon ss_setHeader:pictureUrlURL];
    
    
    self.userName.text = model.author.name;
    self.userInfo.text = model.author.username;
}

//把系统的分割线去除,然后把控制器的的颜色改成要设置分割线的颜色
-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    
    //设置每个cell之间有个10的间距
    frame.size.height -= SSMargin;
    //设置每个cell离屏幕间距为10
    frame.origin.x += SSMargin;
    //因为x向右移动了10,所以cell的左边距离屏幕为10,但是为了保证cell的右边为10,应该设置为2 * 10.因为cell向右移动了10,所以屏幕的右边还是有10的cell,所以为了保证cell的右边距离屏幕为10,应该为2倍的间距
    frame.size.width -= 2 * SSMargin;
    
    [super setFrame:frame];
}


@end

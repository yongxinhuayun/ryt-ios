//
//  AuctionTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "AuctionTableViewCell.h"

#import "AuctionModel.h"

#import "UIImageView+WebCache.h"

@interface AuctionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *auctionTitle;
@property (weak, nonatomic) IBOutlet UILabel *auctionIntroductionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;

/** 拍卖前-整体 */
@property (weak, nonatomic) IBOutlet UIView *auctionBeforeView;
@property (weak, nonatomic) IBOutlet UILabel *auctionTimeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *auctionTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *auctionPrice;

/** 拍卖中-整体 */
@property (weak, nonatomic) IBOutlet UIView *auctingView;
@property (weak, nonatomic) IBOutlet UILabel *auctionMoney;
@property (weak, nonatomic) IBOutlet UILabel *auctionNum;
@property (weak, nonatomic) IBOutlet UILabel *auctionUpdateTime;


/** 拍卖后-整体 */
@property (weak, nonatomic) IBOutlet UIView *auctionAfterView;
@property (weak, nonatomic) IBOutlet UILabel *auctionUser;
@property (weak, nonatomic) IBOutlet UILabel *strikePrice;
@property (weak, nonatomic) IBOutlet UIImageView *fengexianImage;

@end

@implementation AuctionTableViewCell

+(instancetype)auctionCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


-(void)setModel:(AuctionModel *)model{
    
    _model= model;
    
    //设置项目背景图片
    NSString *picture_urlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *picture_urlURL = [NSURL URLWithString:picture_urlStr];
    
//    [self.bgImageView sd_setImageWithURL:picture_urlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    [self.bgImageView sd_setImageWithURL:picture_urlURL placeholderImage:nil];
    
    
//    model.step = @"30";
    if ([model.step isEqualToString:@"30"]) {
        
        self.auctionBeforeView.hidden = NO;
        self.auctingView.hidden = YES;
        self.auctionAfterView.hidden = YES;
        self.fengexianImage.hidden = NO;
        
        self.auctionPrice.text = [NSString stringWithFormat:@"%zd元",model.investsMoney];
        
        //拍卖时间  --- 需要拍卖起始时间和结束时间相减
        //设置时间格式
        NSDate *auctionStartDateTimesp1 = [NSDate dateWithTimeIntervalSince1970:model.auctionStartDatetime];
        
        NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"MM月dd日 HH:mm"];
        //将时间转换为字符串
        NSString *timeStr1=[formatter1 stringFromDate:auctionStartDateTimesp1];
        //添加时间
        self.auctionTimeLabel1.text = timeStr1;
        
        
        NSDate *auctionStartDateTimesp2 = [NSDate dateWithTimeIntervalSince1970:model.auctionEndDatetime];
        
        NSDateFormatter *formatter2=[[NSDateFormatter alloc]init];
        [formatter2 setDateFormat:@"HH:mm"];
        //将时间转换为字符串
        NSString *timeStr2 =[formatter2 stringFromDate:auctionStartDateTimesp2];
        //添加时间
        self.auctionTimeLabel2.text = timeStr2;
        
    }else if ([model.step isEqualToString:@"31"]){
        
        self.auctingView.hidden = NO;
        self.auctionBeforeView.hidden = YES;
        self.auctionAfterView.hidden = YES;
        self.fengexianImage.hidden = NO;
        
        self.auctionMoney.text = [NSString stringWithFormat:@"%ld",model.bewBiddingDate];
        
        self.auctionNum.text = [NSString stringWithFormat:@"%ld",model.investNum];
        
    }else if ([model.step isEqualToString:@"32"]) {
        
        self.auctionAfterView.hidden = NO;
        self.auctionBeforeView.hidden = YES;
        self.auctingView.hidden = YES;
        self.fengexianImage.hidden = NO;
        
        self.auctionUser.text = model.winner;
        self.strikePrice.text = [NSString stringWithFormat:@"%ld",model.investNum];
        
    }else {
        
        self.auctionAfterView.hidden = YES;
        self.auctionBeforeView.hidden = YES;
        self.auctingView.hidden = YES;
        self.fengexianImage.hidden = YES;
    }
    
    //创作标题
    self.auctionTitle.text = model.title;
    //创作简介
    self.auctionIntroductionLabel.text = model.descriptions;
    
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.userIcon ss_setHeader:pictureUrlURL];
    
    self.userName.text = model.author.name;
    self.userInfo.text = model.author.userBrief.content;
}

//把系统的分割线去除,然后把控制器的的颜色改成要设置分割线的颜色
-(void)setFrame:(CGRect)frame
{
    //设置每个cell之间有个10的间距
    frame.size.height -= 1;
    
    [super setFrame:frame];
}




@end

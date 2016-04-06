//
//  FinanceTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceTableViewCell.h"

#import "FinanceModel.h"
#import "ResultModel.h"

#import "UIImageView+WebCache.h"

@interface FinanceTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *financeTitle;
@property (weak, nonatomic) IBOutlet UILabel *financeIntroductionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressPercent;
@property (weak, nonatomic) IBOutlet UILabel *targetMoney;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *investNum;

@end

@implementation FinanceTableViewCell


+(instancetype)financeCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)setModel:(FinanceModel *)model{
    
    _model= model;
    
    
    /*
     {"resultCode":"0","
     objectList":[{"id":"qydeyugqqiugd2",
     "title":"测试","brief":"这是一个","description":null,"status":"1","investGoalMoney":1.00,"investStartDatetime":1455005261000,"investEndDatetime":1454314064000,"auctionStartDatetime":1454400455000,"auctionEndDatetime":1454400449000,
     "author":
        {"id":"icjxkedl0000b6i0","username":"123123","name":"魏立中","pictureUrl":"http://tenant.efeiyi.com/background/蔡水况.jpg","cityId":null,"status":"0","createDatetime":null,"type":"10000",
        "master":{"id":"icjxkedl0000b6i0","brief":"版画家，他使得业已消失数百年的明代印刷业老字号十竹斋重新恢复并焕发生机，成为杭州市文化产业传承创新的亮点。","title":"国家级传承人","favicon":"http://tenant.efeiyi.com/background/蔡水况.jpg","birthday":"1968年","level":"1","content":null,"presentAddress":"浙江","backgroundUrl":"background/魏立中.jpg","provinceName":"浙江","theStatus":"1","logoUrl":"logo/魏立中.jpg","masterSpeech":null,"artCategory":null,"titleCertificate":null}},
     "createDatetime":1454314046000,"artworkAttachment":[],"artworkComments":[],"artworkDraw":null,"picture_url":"http://tenant.efeiyi.com/background/蔡水况.jpg","step":null,"investsMoney":154,"creationEndDatetime":1458285471000,"type":"3","newCreationDate":null,"auctionNum":null,"newBidingPrice":null,"newBiddingDate":null}],
     "resultMsg":"成功"}
     */

    
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.picture_url] placeholderImage:[UIImage imageNamed:@"基本资料-未传头像"]];
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.picture_url]];
    NSLog(@"%@",model.picture_url);
    
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.picture_url] placeholderImage:[UIImage imageNamed:@"基本资料-未传头像"]];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.picture_url] placeholderImage:[UIImage imageNamed:@"基本资料-未传头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSLog(@"%@",model.picture_url);
        NSLog(@"%@",error);
        NSLog(@"%@",imageURL);
        
    }];
    
    
    
    self.targetMoney.text = [NSString stringWithFormat:@"%ld元",model.investGoalMoney];

    // 求出self和date相差多少秒
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:model.investEndDatetime];
    
    self.endTime.text = [NSString stringWithFormat:@"%@",confromTimesp];
    
    self.investNum.text = [NSString stringWithFormat:@"%ld",model.investorsNum];
    
    
    self.financeTitle.text = model.title;
    self.financeIntroductionLabel.text = model.author.descriptions;
    
//    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.author.pictureUrl] placeholderImage:[UIImage imageNamed:@"基本资料-未传头像"]];
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.author.pictureUrl] placeholderImage:[UIImage imageNamed:@"基本资料-未传头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSLog(@"%@",model.picture_url);
        NSLog(@"%@",error);
        NSLog(@"%@",imageURL);
        
    }];
    
    NSLog(@"%@",model.author.pictureUrl);
    

    
    self.userName.text = model.author.name;
    self.userInfo.text = model.author.username;
    
//    self.progressView.progress = nil;
    
}

@end

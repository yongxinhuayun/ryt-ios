//
//  FinanceTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceTableViewCell.h"

#import "FinanceModel.h"
#import "Progress.h"
#import "UIImageView+WebCache.h"

@interface FinanceTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *financeTitle;
@property (weak, nonatomic) IBOutlet UILabel *financeIntroductionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UIView *progressView;
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

-(void)awakeFromNib{
    Progress *progress = [[Progress alloc] init];
    progress.frame = self.progressView.bounds;
    self.progress = progress;
    [self.progressView addSubview:progress];
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
    
    NSString *picture_urlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *picture_urlURL = [NSURL URLWithString:picture_urlStr];
    
    //    NSLog(@"%@",picture_urlURL);
    
    [self.bgImageView sd_setImageWithURL:picture_urlURL];
    
    self.targetMoney.text = [NSString stringWithFormat:@"%ld元",model.investGoalMoney];
    
    //设置融资剩余时间
    float begainTime= model.investStartDatetime;
    float endTime = model.investEndDatetime;
    float investInteral = endTime - begainTime;
    
    NSDate *newCreationEmdTimesp = [NSDate dateWithTimeIntervalSince1970:investInteral];
    
    //设置时间格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH时mm分ss秒"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:newCreationEmdTimesp];
    //添加时间
    self.endTime.text = timeStr;
    
    //设置投资人数
    self.investNum.text = [NSString stringWithFormat:@"%ld",model.investNum];
    
    //设置投资标题
    self.financeTitle.text = model.title;
    //设置投资描述
    self.financeIntroductionLabel.text = model.brief;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    //    NSLog(@"%@",pictureUrlURL);
    
    [self.userIcon ss_setHeader:pictureUrlURL];
    self.progress.progress = 0.8;
    self.userName.text = model.author.name;
    self.userInfo.text = model.author.username;
    
    //    self.progressView.progress = nil;
    
}

//把系统的分割线去除,然后把控制器的的颜色改成要设置分割线的颜色
-(void)setFrame:(CGRect)frame
{
//    frame.size.height -= 1;
    
    //设置每个cell之间有个10的间距
    frame.size.height -= SSMargin;
    //设置每个cell离屏幕间距为10
//    frame.origin.x += SSMargin;
    //因为x向右移动了10,所以cell的左边距离屏幕为10,但是为了保证cell的右边为10,应该设置为2 * 10.因为cell向右移动了10,所以屏幕的右边还是有10的cell,所以为了保证cell的右边距离屏幕为10,应该为2倍的间距
//    frame.size.width -= 2 * SSMargin;
    
    [super setFrame:frame];
}



@end

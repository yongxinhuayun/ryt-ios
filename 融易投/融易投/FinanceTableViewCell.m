//
//  FinanceTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceTableViewCell.h"

#import "FinanceModel.h"

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
    
    NSString *picture_urlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *picture_urlURL = [NSURL URLWithString:picture_urlStr];
    
//    NSLog(@"%@",picture_urlURL);
    
    [self.bgImageView sd_setImageWithURL:picture_urlURL];
    
    self.targetMoney.text = [NSString stringWithFormat:@"%ld元",model.investGoalMoney];

    // 求出self和date相差多少秒
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:model.investEndDatetime];
    
    self.endTime.text = [NSString stringWithFormat:@"%@",confromTimesp];
    
    self.investNum.text = [NSString stringWithFormat:@"%ld",model.investorsNum];
    
    
    self.financeTitle.text = model.title;
    self.financeIntroductionLabel.text = model.author.descriptions;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
//    NSLog(@"%@",pictureUrlURL);
    
    //因为完成之后会返回一个从服务器加载的数据,所以我们这里拿到的就是从服务器获取的最初始的图片
    [self.userIcon sd_setImageWithURL:pictureUrlURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //使用裁剪方式
        //开启上下文
        //第一个参数:上下文的范围 第二个参数:是否是不透明的 第三个参数;
        //        UIGraphicsBeginImageContextWithOptions(<#CGSize size#>, <#BOOL opaque#>, <#CGFloat scale#>)
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        
        //描述圆形路径
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        //设置裁剪区域
        [path addClip];
        
        //绘制图片
        [image drawAtPoint:CGPointZero];
        
        //从上下文中获取图片
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        //给空间设置图片
        //        self.iconView.image = image;
        //这样裁剪会造成图片边缘有锯齿
        //使用分类处理锯齿
        self.userIcon.image = [image imageAntialias];
        
        
    }];

    
//    [self.userIcon sd_setImageWithURL:pictureUrlURL];
    
    self.userName.text = model.author.name;
    self.userInfo.text = model.author.username;
    
//    self.progressView.progress = nil;
    
}

//把系统的分割线去除,然后把控制器的的颜色改成要设置分割线的颜色
//当我们
-(void)setFrame:(CGRect)frame
{
    
    frame.size.height -= 1;
    
    [super setFrame:frame];
    
}



@end

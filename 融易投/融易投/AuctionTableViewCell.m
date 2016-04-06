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
@property (weak, nonatomic) IBOutlet UILabel *auctionTimeLabel;

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
    
    [self.bgImageView sd_setImageWithURL:picture_urlURL placeholderImage:[UIImage imageNamed:@"基本资料-未传头像"]];
    
    //拍卖时间  --- 需要拍卖起始时间和结束时间相减
    NSDate *auctionStartDateTimesp = [NSDate dateWithTimeIntervalSince1970:model.auctionStartDatetime];
    
    self.auctionTimeLabel.text = [NSString stringWithFormat:@"%@",auctionStartDateTimesp];
    
    //创作标题
    self.auctionTitle.text = model.title;
    //创作简介
    self.auctionIntroductionLabel.text = model.descriptions;
    
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    //    NSLog(@"%@",pictureUrlURL);
    
//    [self.userIcon sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"基本资料-未传头像"]];
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

    
    self.userName.text = model.author.name;
    self.userInfo.text = model.author.username;
}

//把系统的分割线去除,然后把控制器的的颜色改成要设置分割线的颜色
//当我们
-(void)setFrame:(CGRect)frame
{
    
    frame.size.height -= 1;
    
    [super setFrame:frame];
    
}


@end

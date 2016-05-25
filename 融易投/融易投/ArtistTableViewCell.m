//
//  ArtistTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistTableViewCell.h"
#import "ArtistModel.h"

@interface ArtistTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;



//@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
//@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtnConstraint;
@end

@implementation ArtistTableViewCell

+(instancetype)ArtistCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    
}

-(void)setInvestorModel:(InvestorModel *)investorModel{
    _investorModel = investorModel;
    if (SSScreenW == 375) {
        self.topBtnConstraint.constant = 50;
    }else{
        self.topBtnConstraint.constant = 40;
    }
}

-(void)setArtistModel:(ArtistModel *)artistModel{
    _artistModel = artistModel;
    if (SSScreenW == 375) {
        self.topBtnConstraint.constant = 50;
    }else{
        self.topBtnConstraint.constant = 40;
    }
    //设置头像
//        NSString *picture_urlStr = [[NSString stringWithFormat:@"%@",artistModel.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//        NSURL *picture_urlURL = [NSURL URLWithString:picture_urlStr];
//    
//        [self.userIcon sd_setImageWithURL:picture_urlURL];

    
}

-(void)setModel:(ArtistModel *)model{
    
//        _model= model;
    

    
        //设置头像
        //    NSString *picture_urlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //
        //    NSURL *picture_urlURL = [NSURL URLWithString:picture_urlStr];
        //
        //    [self.userIcon sd_setImageWithURL:picture_urlURL];
        
        //设置排名
        
//        //设置投资者
//        self.usernameLabel.text = model.truename;
//        
//        //设置项目总金额
//        self.priceLabel.text = [NSString stringWithFormat:@"%ld元",model.bidding_rate];
//    
//        //设置总成交价
//        self.totalPriceLabel.text = [NSString stringWithFormat:@"%ld元",model.bidding_rate];
    }
    
//把系统的分割线去除,然后把控制器的的颜色改成要设置分割线的颜色
-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
}

@end

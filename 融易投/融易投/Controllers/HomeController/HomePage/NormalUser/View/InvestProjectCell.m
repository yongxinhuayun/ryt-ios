//
//  InvestProjectCell.m
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "InvestProjectCell.h"
#import "PageInfoModel.h"
#import "ArtworksModel.h"

#import "UIImageView+WebCache.h"
#import "CommonButton.h"

@interface InvestProjectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;

@property (weak, nonatomic) IBOutlet UIButton *projectStepBtn;
@property (weak, nonatomic) IBOutlet CommonButton *dianzanBtn;

@end

@implementation InvestProjectCell


-(void)setModel:(ArtworksModel *)model{
    
    _model = model;
        
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.backgroundImage sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    
    self.title.text = model.title;
    
    self.totalMoney.text = [NSString stringWithFormat:@"%ld",model.goalMoney];
    
    //判断当前项目处于什么状态
    
    if ([model.step isEqualToString:@"12"]||[model.step isEqualToString:@"14"]||[model.step isEqualToString:@"15"]){
        
        [self.projectStepBtn setTitle:@"融资阶段" forState:UIControlStateNormal];
        
    }else if ([model.step isEqualToString:@"21"]||[model.step isEqualToString:@"22"]||[model.step isEqualToString:@"23"]||[model.step isEqualToString:@"24"]){
        
         [self.projectStepBtn setTitle:@"创作阶段" forState:UIControlStateNormal];
    }
    
        /*
        if ([model.step isEqualToString:@"10"]) {
            
            
        }else if ([model.step isEqualToString:@"11"]){
 
        }else if ([model.step isEqualToString:@"12"]) {
            
            
        }else if ([model.step isEqualToString:@"13"]) {
            
            
        }else if ([model.step isEqualToString:@"14"]) {
            
            
        }else if ([model.step isEqualToString:@"15"]) {
            
            
        }else if ([model.step isEqualToString:@"20"]) {
            
            
        }else if ([model.step isEqualToString:@"21"]) {
            
            
        }else if ([model.step isEqualToString:@"22"]) {
            
            
        }else if ([model.step isEqualToString:@"23"]) {
            
            
        }else if ([model.step isEqualToString:@"24"]) {
            
            
        }else if ([model.step isEqualToString:@"25"]) {
            
            
        }
         */
//    }
    
    
    //作者信息
    NSString *iconUrlStr = [[NSString stringWithFormat:@"%@",model.user.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *iconUrlURL = [NSURL URLWithString:iconUrlStr];
    
    [self.userIcon ss_setHeader:iconUrlURL];
    
    self.userName.text = model.user.name;
    self.userTitle.text = model.user.master.title;
    
//    NSLog(@"%@",[NSString stringWithFormat:@"%zd",self.model.num.integerValue]);
//    
//    NSLog(@"%@",self.model.num);
    
    if ([self.model.num isEqualToString:@""]) {
        
         [self.dianzanBtn setTitle:@"0" forState:UIControlStateNormal];
    }
    
    [self.dianzanBtn setTitle:self.model.num forState:UIControlStateNormal];

}

/****************************************实现点赞功能***************************************** */

//实现点赞功能
- (IBAction)dianZanClick:(UIButton *)button {
    
    //因为当我们进行点赞的同时,需要把点赞的按钮变成选中颜色并且点赞数加一,但是当我们点赞的同时,可能其他用户也再对同一个帖子进行点赞,所以好需要向服务器发送一个GET请求
    /*
     //1. 按钮变成选中图片
     [button setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateNormal];
     //2. 点赞数加一,直接修改模型中的数据,因为模型中的顶是个字符串,所以需要拼接
     [button setTitle:[NSString stringWithFormat:@"%zd",self.topic.ding.integerValue + 1] forState:UIControlStateNormal];
     //3. 发送请求
     //这里找不到发送请求的接口,就不操作了
     */
    
    /*
     //运行程序,发现会出现循环利用
     //方法一:如果我们在cell中添加标记,那么当我们点击赞的按钮的时候还是照样能循坏利用
     //方法二:在模型中添加辅助属性,这样就能分出当前cell是否被点赞
     //我们利用模型判断是否点过赞,还需要在模型topic的set方法中设置按钮的选中图片.因为当我们再次cell重新赋值模型的时候,还得来到模型的set方法,所以我们还得重新判断一下,然后赋值
     
     //1. 按钮变成选中图片
     [button setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateNormal];
     //2. 点赞数加一,直接修改模型中的数据,因为模型中的顶是个字符串,所以需要拼接
     [button setTitle:[NSString stringWithFormat:@"%zd",self.topic.ding.integerValue + 1] forState:UIControlStateNormal];
     
     self.topic.is_ding = YES;
     */
    
    /*
     //运行程序,当我们点击了赞的时候,上下拖动,原来的赞数就又变回来了,所以我们得修改模型中的数据
     //1.按钮变成选中图片
     [button setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateNormal];
     //2.点赞数加一
     self.topic.ding = [NSString stringWithFormat:@"%zd",self.topic.ding.integerValue + 1];
     [button setTitle:self.topic.ding forState:UIControlStateNormal];
     */
    
    /*--------------------------------------残留问题------------------------------------------*/
    //注意:因为我们之前修改了点赞数,改成了以万位单位,所以我们点赞的时候可能不会点赞数出现在按钮的标题上
    //这个需要在处理一下
    /*--------------------------------------残留问题------------------------------------------*/
    
    //当我们还要想取消赞的时候还要进行一下取消赞
    if (self.model.is_zan) { //取消赞
        
        //1. 按钮变成选中图片
        [button setImage:[UIImage imageNamed:@"dianzanqian"] forState:UIControlStateNormal];
        //2. 点赞数加一,直接修改模型中的数据,因为模型中的顶是个字符串,所以需要拼接
        self.model.num = [NSString stringWithFormat:@"%zd",self.model.num.integerValue - 1];
        self.model.is_zan = NO;
        
    }else{ //赞
        
        UILabel *num = [[UILabel alloc] initWithFrame:button.frame];
        num.center = button.center;
        num.textAlignment = NSTextAlignmentCenter;
        num.text = @"+1";
        num.textColor = [UIColor redColor];
        [self addSubview:num];
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat x = num.centerX;
            CGPoint p = CGPointMake(x, num.y - num.height);
            num.center = p;
            num.alpha = 0;
        } completion:^(BOOL finished) {
            [num removeFromSuperview];
        }];
        
        //1. 按钮变成选中图片
        [button setImage:[UIImage imageNamed:@"dianzanhou"] forState:UIControlStateNormal];
        //2. 点赞数加一,直接修改模型中的数据,因为模型中的顶是个字符串,所以需要拼接
        self.model.num = [NSString stringWithFormat:@"%zd",self.model.num.integerValue + 1];
        
        self.model.is_zan = YES;
    }
    
//    NSLog(@"%@",[NSString stringWithFormat:@"%zd",self.model.num.integerValue]);
    
    [button setTitle:self.model.num forState:UIControlStateNormal];
    

    //3. 发送请求
    //注意:当我们发送请求的时候,应该先修改按钮的选中图片,而不是一直等到服务器返回的数据,如果要是服务器返回的数据失败我们就再次提醒一下用户,再次进行点赞操作
    //当我们进行点赞的时候,应该提醒一下点赞是否成功,可以直接把选中的图片变大即可
    //    [button.imageView.layer addAnimation:<#(nonnull CAAnimation *)#> forKey:<#(nullable NSString *)#>]
    
    /*
    NSString *userId = @"18701526255";
    NSString *urlStr = @"http://192.168.1.41:8085/app/artworkPraise.do";
    NSDictionary *json = @{
                           @"artworkId" : self.artworkId,
                           @"currentUserId": userId,
                           };
    
    [self loadData:urlStr parameters:json andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        NSString *str = modelDict[@"resultMsg"];
        if ([str isEqualToString:@"成功"]) {
            UILabel *numLabel = [[UILabel alloc] initWithFrame:zan.frame];
            numLabel.center = zan.center;
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.text = @"+1";
            numLabel.textColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.7];
            [zan addSubview:numLabel];
            [UIView animateWithDuration:0.6 animations:^{
                CGFloat x = numLabel.centerX;
                CGPoint p = CGPointMake(x, 0);
                numLabel.center = p;
                numLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [numLabel removeFromSuperview];
            }];
            NSString *zanNum = [NSString stringWithFormat:@" %ld",self.artworkModel.praiseNUm + 1];
            [zan setTitle:zanNum forState:(UIControlStateNormal)];
        }
    }];

    */
    
    
}
/****************************************实现点赞功能***************************************** */

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

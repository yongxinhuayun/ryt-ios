//
//  OtherHeaderView.h
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageInfoModel;

@protocol CommonUserHeaderViewDelegate <NSObject>
//发送私信
@optional
-(void)postPrivateLetter;
-(void)addConcern;
@end

@interface CommonUserHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *privateLetterBtn;

@property (weak, nonatomic) IBOutlet UILabel *inverstMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *inverstProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvestRateLabel;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherViewTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherViewBottomCons;

@property (nonatomic,weak) id<CommonUserHeaderViewDelegate>delegate;
@property (nonatomic ,strong)PageInfoModel *model;


@property (nonatomic ,strong) void(^focusBlcok)();
@property (nonatomic ,strong) void(^fansBlcok)();


@end

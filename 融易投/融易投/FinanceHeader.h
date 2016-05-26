//
//  FinanceHeader.h
//  融易投
//
//  Created by dongxin on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Progress;
@protocol FinanceHeaderDelegate <NSObject>
-(void)scrollToRecordAndTop;
-(void)jumpToUserHome;
-(void)jumpToUserHomeByIndexPath:(NSIndexPath *)indexPath;
@end
@interface FinanceHeader : UIView
//项目图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
// 用户真实姓名
@property (weak, nonatomic) IBOutlet UILabel *userName;
//用户头衔
@property (weak, nonatomic) IBOutlet UILabel *userTitle;
//用户简介
@property (weak, nonatomic) IBOutlet UITextView *userContent;
//已融金额
@property (weak, nonatomic) IBOutlet UILabel *investsMoney;
//融资进度
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property(nonatomic,strong) Progress *progress;
//融资进度
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
//目标金额
@property (weak, nonatomic) IBOutlet UILabel *investGoalMoney;
//剩余时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//投资人数
@property (weak, nonatomic) IBOutlet UILabel *investNum;
@property (nonatomic,strong) NSMutableArray *investPeople;
//
@property (weak, nonatomic) IBOutlet UICollectionView *artworkInvestList;
@property(weak,nonatomic) id<FinanceHeaderDelegate> delegate;
@end

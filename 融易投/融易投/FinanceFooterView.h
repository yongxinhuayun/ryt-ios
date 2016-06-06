//
//  FinanceFooterView.h
//  融易投
//
//  Created by dongxin on 16/5/10.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinanceFooterViewDelegate <NSObject>
-(void)jumpTZController;
-(void)jumpPLController;
-(void)clickZan:(UIButton *)zan;
@end

@interface FinanceFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *zan;
@property(nonatomic,weak) id<FinanceFooterViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
+(instancetype)FinanceFooterView;
@end

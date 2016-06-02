//
//  PointView.h
//  融易投
//
//  Created by 李鹏飞 on 16/6/1.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PointViewDelegate <NSObject>

@required
/* 关闭 */
-(void)clickClose;
/* 跳转 */
-(void)clickRecharge;

@end

@interface PointView : UIView
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property(nonatomic,weak) id<PointViewDelegate>delegate;
@end

//
//  CoverHUDView.h
//  融易投
//
//  Created by efeiyi on 16/5/12.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverHUDView : UIView

+(instancetype)coverHUDView;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;
@property (weak, nonatomic) IBOutlet UIView *subView;

@end

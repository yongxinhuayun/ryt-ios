//
//  ShareViewHUD.h
//  融易投
//
//  Created by efeiyi on 16/5/26.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXButton.h"
@interface ShareViewHUD : UIView

@property (weak, nonatomic) IBOutlet WXButton *WXButton;
@property (weak, nonatomic) IBOutlet WXButton *friendButton;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;

+(instancetype)shareViewHUD;
@end

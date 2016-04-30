//
//  MeHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MeHeaderView.h"

@interface MeHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation MeHeaderView

+(instancetype)meHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    
    //设置图片能够点击
    //记住:UIImageView默认情况下是不能接收事件的,如果要执行点击方法,必须把默认的User interaction Enable 改成yes
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.iconImageView addGestureRecognizer:tapGesture];
    
    [self FocusBtnClick:nil];
    
}

-(void)tap {
    
    if (_editingInfoBlcok != nil) {
        _editingInfoBlcok();
    }
    
}

- (IBAction)FocusBtnClick:(id)sender {
    
    if (_focusBlcok != nil) {
        _focusBlcok();
    }
    
}

- (IBAction)FansBtnClick:(id)sender {
    
    if (_fansBlcok != nil) {
        _fansBlcok();
    }
    
}

@end

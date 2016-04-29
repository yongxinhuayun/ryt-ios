//
//  MyHeaderView.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MyHeaderView.h"

@interface MyHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation MyHeaderView

+(instancetype)myHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    
    
    NSLog(@"1");

    //设置图片能够点击
    //记住:UIImageView默认情况下是不能接收事件的,如果要执行点击方法,必须把默认的User interaction Enable 改成yes
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.iconImageView addGestureRecognizer:tapGesture];
    
    [self FocusBtnClick:nil];

}

-(void)tap {
    
    
    SSLog(@"11");
    
    if (_valueBlcok != nil) {
        _valueBlcok();
    }

}

- (IBAction)loginBtnClick:(id)sender {
    
  
}


- (IBAction)CompleteUserInfoBtnClick:(id)sender {
    
}




- (IBAction)shortVideo:(id)sender {
    
    
    
}
- (IBAction)releaseProject:(id)sender {
    
   
    
}
- (IBAction)artistBtnClick:(id)sender {
    
   
}


- (IBAction)FocusBtnClick:(id)sender {
    
    SSLog(@"11");
    
    if (_valueBlcok != nil) {
        _valueBlcok();
    }
    
}

- (IBAction)FansBtnClick:(id)sender {
    
   
    
}

- (IBAction)releaseBtnClick:(id)sender {
    
   
    
    
}
- (IBAction)test:(id)sender {
    
    SSLog(@"sdfsdf");
}

@end

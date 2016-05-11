//
//  ReleaseProjectCell.m
//  融易投
//
//  Created by efeiyi on 16/5/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ReleaseProjectCell1.h"

@interface ReleaseProjectCell1() <UITextViewDelegate>


@end

@implementation ReleaseProjectCell1

- (void)awakeFromNib {
    
    self.placeholderLabel.text = @"请填写作品创作的过程...\n示例说明(陶瓷制作说明):\n1.练泥,约10天；\n2.拉坯、印坯、利坯、晒坯，约12天；\n3.刻花，约3天；\n4.施釉，约1天；\n5.烧窑，约3天；\n6.彩绘，约2天。";
    self.label.text = @"创作过程说明";
    
    
    //让textView在左上角出现光标
//    self.automaticallyAdjustsScrollViewInsets = false;
    
    //设置placeholderLabel隐藏
    self.placeholderLabel.hidden = [self.textView.text length];
    
    //添加边框
    self.textView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    self.textView.layer.borderColor = [[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]CGColor];
    
    self.textView.layer.borderWidth = 1.0;
    
    self.textView.layer.cornerRadius = 8.0f;
    
    [self.textView.layer setMasksToBounds:YES];
    
    
    self.textView.delegate = self;
}

#pragma mark - Text View Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = [textView.text length];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text])
    {
        if ([self.textView.text length]) {
            [self.textView resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

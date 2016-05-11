//
//  ReleaseProjectCell2.m
//  融易投
//
//  Created by efeiyi on 16/5/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ReleaseProjectCell2.h"

@interface ReleaseProjectCell2 () <UITextViewDelegate>

@end

@implementation ReleaseProjectCell2

- (void)awakeFromNib {
    
    self.placeholderLabel.text = @"示例说明:\nQ1.该作品是否为纯手工制作?\n作品由本人亲自制作,是纯手工作品。\nQ2.该作品有什么价值？\n作品的价值在于...";
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

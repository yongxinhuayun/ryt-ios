//
//  SSTextField.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "TimeFiled.h"

@interface TimeFiled ()

@end

@implementation TimeFiled

-(void)awakeFromNib
{
    [self setup];

}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    UIDatePicker *birthdayDatePicker = [[UIDatePicker alloc] init];
    
    
    birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
    
    // 设置日期地区
    // zh:中国
    birthdayDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    // 设置初始化时间为1990-1-1
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd";
//    NSDate *date = [dateFormatter dateFromString:@"1990-01-01"];
////     //设置一开始日期
//    birthdayDatePicker.date = date;

    
    [birthdayDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];

    self.inputView = birthdayDatePicker;
}

-(void)dateChange:(UIDatePicker *)datePicker
{
    NSLog(@"%@",datePicker.date);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy";

    //设置选中文本框显示的时间
    self.text = [dateFormatter stringFromDate:datePicker.date];
}

@end

//
//  CommonTextView.h
//  融易投
//
//  Created by efeiyi on 16/5/9.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTextView : UIView


@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

+(instancetype) commonTextView;

@end

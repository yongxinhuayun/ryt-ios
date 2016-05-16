//
//  CommonTextView.h
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonnTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

/* 示例:
 - (void)setupTextView
 {
 CommonnTextView *textView = [[CommonnTextView alloc] init];
 textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
 textView.alwaysBounceVertical = YES;
 textView.delegate = self;
 textView.frame = self.view.bounds;
 [self.view addSubview:textView];
 self.textView = textView;
 }
 */
@end

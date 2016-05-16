//
//  CommonTextView.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonTextView.h"

@interface CommonnTextView()
/** 显示占位文字的label */
@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation CommonnTextView
#pragma mark - init
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.x = 4;
        placeholderLabel.y = 8;
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:15];
        
        self.placeholderColor = [UIColor grayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  监听文字改变
 */
- (void)textDidChange
{
    self.placeholderLabel.hidden = self.hasText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置宽度
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    
    // 自动计算高度
    [self.placeholderLabel sizeToFit];
    
    // 计算placeholder这个字符串将来显示出来的尺寸
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = self.font;
//    CGSize maxSize = CGSizeMake(self.placeholderLabel.width, MAXFLOAT);
//    CGSize placeholderSize = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    self.placeholderLabel.height = placeholderSize.height;
    
//    [self.placeholder sizeWithFont:self.font constrainedToSize:maxSize];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    // 重新布局子控件
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    // 重新布局子控件
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    self.placeholderLabel.hidden = self.hasText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    self.placeholderLabel.hidden = self.hasText;
}
@end

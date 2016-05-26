//
//  SSProgressView.m
//  融易投
//
//  Created by efeiyi on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "SSProgressView.h"

@implementation SSProgressView

- (void)awakeFromNib
{
    self.roundedCorners = 5;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress
{
    [super setProgress:progress];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end

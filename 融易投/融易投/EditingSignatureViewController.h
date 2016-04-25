//
//  EditingSignatureViewController.h
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingSignatureViewController : UIViewController


//假设编辑资料时,已经有昵称,就直接把昵称显示在控件上
@property (nonatomic ,copy) NSString *singature;

// 传值:需要传值的时候,再去调用
//@property (nonatomic ,strong) void(^valueBlcok)();
@property (nonatomic ,strong) void(^valueBlcok)(NSString *str);

@end

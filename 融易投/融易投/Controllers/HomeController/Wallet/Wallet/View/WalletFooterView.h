//
//  WalletFooterView.h
//  融易投
//
//  Created by efeiyi on 16/5/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletFooterView : UIView

//当编辑资料时调用
// 传值:需要传值的时候,再去调用
//@property (nonatomic ,strong) void(^valueBlcok)();
@property (nonatomic ,strong) void(^checkMoreBillBlcok)();

@end

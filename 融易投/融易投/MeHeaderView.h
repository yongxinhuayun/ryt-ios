//
//  MeHeaderView.h
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageInfoModel.h"
#import "ArtworksModel.h"

@interface MeHeaderView : UIView

+(instancetype)meHeaderView;

//当编辑资料时调用
// 传值:需要传值的时候,再去调用
//@property (nonatomic ,strong) void(^valueBlcok)();
@property (nonatomic ,strong) void(^editingInfoBlcok)();

@property (nonatomic ,strong) void(^focusBlcok)();

@property (nonatomic ,strong) void(^fansBlcok)();


@property (nonatomic ,strong)PageInfoModel *model;

@end

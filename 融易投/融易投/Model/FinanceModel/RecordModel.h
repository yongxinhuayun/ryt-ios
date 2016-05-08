//
//  RecordModel.h
//  融易投
//
//  Created by dongxin on 16/5/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserMyModel;

@interface RecordModel : NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,assign)NSInteger price;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong) UserMyModel *creator;
@property(nonatomic,assign)NSInteger createDatetime;
@end

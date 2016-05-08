//
//  UserCommonResultModel.h
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  UserCommentObjectModel;

@interface UserCommonResultModel : NSObject

@property(nonatomic,strong) UserCommentObjectModel *object;

@property(nonatomic,strong) NSString *resultCode;

@property(nonatomic,strong) NSString *resultMsg;

@end

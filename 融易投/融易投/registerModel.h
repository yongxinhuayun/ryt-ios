//
//  registerModel.h
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface registerModel : NSObject <NSCoding>

/** 用户id */
@property (nonatomic ,strong) NSString *ID;

/** 用户名 */
@property (nonatomic ,strong) NSString *username;

@end

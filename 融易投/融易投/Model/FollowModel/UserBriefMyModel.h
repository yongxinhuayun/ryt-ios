//
//  UserBriefMyModel.h
//  融易投
//
//  Created by efeiyi on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBriefMyModel : NSObject

/**  */
@property (nonatomic ,strong) NSString *ID;

/**  */
@property (nonatomic ,strong) NSString *status;

/** 简介 */
@property (nonatomic ,strong) NSString *content;


/** 个性签名 */
@property (nonatomic ,strong) NSString *signer;

@end

//
//  CreatorModel.h
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatorModel : NSObject


/** id */
@property (nonatomic ,strong) NSString* ID;

/**评论内容 */
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *username;
/** 评论者 */
@property (nonatomic ,strong) NSString *pictureUrl;
@property (nonatomic ,assign) NSInteger createDatetime;

@end

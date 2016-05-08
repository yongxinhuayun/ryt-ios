//
//  authorDetailModel.h
//  融易投
//
//  Created by efeiyi on 16/4/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MasterDetailsModel;

@interface AuthorDetailModel : NSObject


/** 项目作者名字 */
@property (nonatomic ,strong) NSString *name;

/** 作者信息 */
@property (nonatomic, strong) MasterDetailsModel *master;



@end

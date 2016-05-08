//
//  FocusMyModel.h
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArtUserFollowedMyModel.h"
#import "MasterMyModel.h"
#import "UserBriefMyModel.h"

@interface PageInfoListMyModel : NSObject


/**  */
@property (nonatomic ,strong) ArtUserFollowedMyModel *artUserFollowed;

/**  */
@property (nonatomic ,strong) UserBriefMyModel *userBrief;

/**  */
@property (nonatomic ,strong) MasterMyModel *master;

/**  */
@property (nonatomic ,strong) NSString *flag;

@end

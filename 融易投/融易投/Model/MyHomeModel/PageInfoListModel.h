//
//  PageInfoListModel.h
//  融易投
//
//  Created by efeiyi on 16/5/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserMyModel.h"

#import "ZanguoArtworkModel.h"

@interface PageInfoListModel : NSObject

/**  */
@property (nonatomic ,strong) ZanguoArtworkModel *artwork;

/**  */
@property (nonatomic ,strong) NSString *ID;

/**  */
@property (nonatomic ,strong) NSString *artworkMessage;

/**  */
@property (nonatomic ,strong) UserMyModel *user;

/**  */
@property (nonatomic ,strong) NSString *status;

/**  */
@property (nonatomic ,strong) NSString *watch;

/**  */
@property (nonatomic ,assign) NSInteger createDateTime;

@end

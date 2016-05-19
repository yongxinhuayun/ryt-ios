//
//  MasterWorkListModel.h
//  融易投
//
//  Created by efeiyi on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterWorkListModel : NSObject


//"id": "io9hfxwa23qkf3yk",
//"name": "你好",
//"type": "已售",
//"status": "1",
//"material": "好的",
//"createDatetime": 1463371213000,
//"pictureUrl": "http://rongyitou2.efeiyi.com/masterWork/1463371213549temp.jpg",
//"createYear": null


/** */
@property (nonatomic ,strong) NSString *ID;

/**  */
@property (nonatomic ,strong) NSString *name;

/**  */
@property (nonatomic ,strong) NSString *type;

/**  */
@property (nonatomic ,copy) NSString *status;

/**  */
@property (nonatomic ,copy) NSString *material;

/**  */
@property (nonatomic ,assign) NSInteger createDatetime;

/**  */
@property (nonatomic ,copy) NSString *pictureUrl;

/**  */
@property (nonatomic ,copy) NSString *createYear;


@end

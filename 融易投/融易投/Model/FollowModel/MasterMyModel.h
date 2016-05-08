//
//  MasterMyModel.h
//  融易投
//
//  Created by efeiyi on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MasterMyModel : NSObject


/** 项目id */
@property (nonatomic ,strong) NSString *ID;

/** 主题 */
@property (nonatomic ,strong) NSString *brief;

/** 主题 */
@property (nonatomic ,strong) NSString *title;

/** 图片 */
@property (nonatomic ,strong) NSString *favicon;

///** 项目描述 */
//@property (nonatomic ,strong) NSString *status;
//
///** 项目描述 */
//@property (nonatomic ,strong) NSString *type;
//
///** 融资开始时间 */
//@property (nonatomic ,assign) NSInteger createDatetime;

@end

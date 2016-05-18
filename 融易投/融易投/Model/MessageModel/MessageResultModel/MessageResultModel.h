//
//  MessageResultModel.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageResultModel : NSObject
//resultCode": "0",
//"objectList":
//"resultMsg": "成功"
@property(nonatomic,copy) NSString *resultCode;
@property(nonatomic,copy) NSString *resultMsg;
@property(nonatomic,strong)NSArray *objectList;
@end

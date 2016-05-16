//
//  ArtworkInvestor.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/16.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CreatorModel;
@interface ArtworkInvestor : NSObject
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,strong)CreatorModel *creator;
@end

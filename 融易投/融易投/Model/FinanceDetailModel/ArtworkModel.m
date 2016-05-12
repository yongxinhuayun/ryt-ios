//
//  ArtworkModel.m
//  融易投
//
//  Created by efeiyi on 16/4/16.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtworkModel.h"

@implementation ArtworkModel
+(instancetype)initWithDictionary:(NSDictionary *)dict{
    ArtworkModel *artwordModel = [[ArtworkModel alloc]init];
    [artwordModel setValuesForKeysWithDictionary:dict];
    return artwordModel;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

//
//  City.m
//  融易投
//
//  Created by efeiyi on 16/4/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "City.h"

@implementation City

+(instancetype)cityWithDict:(NSDictionary *)dict
{
    City *city = [[self alloc] init];
    
    [city setValuesForKeysWithDictionary:dict];
    
    return city;
}


@end

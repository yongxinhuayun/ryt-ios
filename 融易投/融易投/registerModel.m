//
//  registerModel.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "registerModel.h"

@implementation registerModel


//什么时候调用:自定义对象归档时候调用
//作用:告诉系统对象里面那些属性需要归档

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"id"];
    [aCoder encodeInteger:self.username forKey:@"username"];
    
}

@end

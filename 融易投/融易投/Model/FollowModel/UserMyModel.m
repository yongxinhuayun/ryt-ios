//
//  UserMyModel.m
//  融易投
//
//  Created by efeiyi on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UserMyModel.h"

@implementation UserMyModel


//敲encodeWithCoder出不来提示,说明Person必须遵守NSCoding协议

//什么时候调用:自定义对象归档时候调用
//作用:告诉系统对象里面那些属性需要归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.signMessage forKey:@"signMessage"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.pictureUrl forKey:@"pictureUrl"];
    
}

//什么时候调用:自定义对象解档时候调用
//作用:告诉系统对象里面哪些属性需要解档
//initWithCoder什么时候调用,只要解析一个文件的时候就会调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        //解档属性
        //注意:一定要给成员属性赋值
        //ID
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        //name
        _name = [aDecoder decodeObjectForKey:@"name"];
//        //signMessage
//        _signMessage = [aDecoder decodeObjectForKey:@"signMessage"];
        //username
        _username = [aDecoder decodeObjectForKey:@"username"];
        //pictureUrl
         _pictureUrl = [aDecoder decodeObjectForKey:@"pictureUrl"];
    }
    return self;
}

@end

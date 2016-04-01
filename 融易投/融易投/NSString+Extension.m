//
//  NSString+Extension.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(NSString *)docDir{
    
    NSString *path = NSHomeDirectory();//主目录
    
    NSLog(@"NSHomeDirectory:%@",path);
    
    NSString *userName = NSUserName();//与上面相同
    NSString *rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);

    return documentsDirectory;
}


    /*
    func cachesDir() -> String {
        
        //1. 拿到文件夹路径
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        
        //2. 拼接字符串
        let temp = (self as NSString).pathComponents.last
        
        let result = (path as NSString).stringByAppendingPathComponent(temp ?? "")
        
        return result
    }
    
    func rempDir() -> String {
        
        //1. 拿到文件夹路径
        let path = NSTemporaryDirectory()
        
        //2. 拼接字符串
        let temp = (self as NSString).pathComponents.last
        
        let result = (path as NSString).stringByAppendingPathComponent(temp ?? "")
        
        return result
    }
     */


@end

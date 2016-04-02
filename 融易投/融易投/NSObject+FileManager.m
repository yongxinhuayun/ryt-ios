//
//  NSObject+FileManager.m
//  百思不得姐
//
//  Created by 王梦思 on 15/12/22.
//  Copyright © 2015年 王梦思. All rights reserved.
//

#import "NSObject+FileManager.h"

@implementation NSObject (FileManager)

// 获取文件尺寸
+ (void)getFileCacheSizeWithPath:(NSString *)path completion:(void(^)(NSInteger total))completion
{
    
    // 如果文件比较大,又多,所以需要的时间很长
    // 文件操作比较耗时,开启子线程去计算,计算好了,在返回
    
    // 开启异步线程 2秒
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 1.创建文件管理者   获取文件尺寸 -> NSFileManager
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // 1.1.判断下是否存在,而且是否是文件夹
        BOOL isDirectory;
        
        BOOL isFileExist = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
        
        // 判断下当前是否是文件
        if (isFileExist){
            
            // 判断下是否是文件夹
            NSInteger total = 0;
            
            if (isDirectory) {
                // 2.遍历文件夹下所有文件,全部加上,就是文件夹尺寸
                NSArray *subPaths = [mgr subpathsAtPath:path];
                
                for (NSString *subPath in subPaths) {
                    // 3.拼接文件全路径
                    NSString *filePath = [path stringByAppendingPathComponent:subPath];
                    
                    BOOL isDirectory;
                    // 4.判断下当前是否是文件
                    BOOL isFileExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
                    
                    // 5.获取文件尺寸
                    if (isFileExist && !isDirectory && ![filePath containsString:@"DS"]) {
                        
                        NSDictionary *fileAttr = [mgr attributesOfItemAtPath:filePath error:nil];
                        NSInteger fileSize = [fileAttr[NSFileSize] integerValue];
                        
                        total += fileSize;
                    }
                }
                
            }else{
                
                // 当前传入是文件
                NSDictionary *fileAttr = [mgr attributesOfItemAtPath:path error:nil];
                
                total = [fileAttr[NSFileSize] integerValue];
                
            }
            
            //碰到异步方法时需要使用回调,block
            //因为我们在计算完文件大小的时候肯定知道接下来干什么,就是刷新表格
            //假设计算时长为2秒,我们可以使用同步线程,当计算完成之后,给方法添加一个完成之后需要做的方法
            // 计算完毕 -> 把计算的值传递出去
            dispatch_sync(dispatch_get_main_queue(), ^{
                
            /*
            completion = ^(NSInteger total) {
                
                self.total = total;
                
                // 计算完成就会调用
                [self.tableView reloadData];
                
            }
             */
                
                if (completion) {
                    completion(total);
                }
                
                
            });
            
        }
    });
    
   
    //如果我们在最后返回一个值,并且我们在上面添加了一个异步线程,我们执行到这里的时候,total的值肯定是0
    //因为计算文件大小,需要耗时,当我们还在计算的时候已经返回了计算的total为0
//    return total;
    
    //注意: 异步方法,不需要返回值
    //所以我们只能碰到异步方法时需要使用回调,block
    
}

- (void)getFileCacheSizeWithPath:(NSString *)path completion:(void (^)(NSInteger))completion
{
    [NSObject getFileCacheSizeWithPath:path completion:completion];
}

+ (NSString *)cachePath
{
    // 获取cachePath文件路径
    return  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)cachePath
{
    return [NSObject cachePath];
}


+ (void)removeCacheWithCompletion:(void (^)())completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 创建文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // 删除文件
        
        NSString *path = self.cachePath;
        
        BOOL isDirectory;
        
        BOOL isFileExist = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
        
        if (!isFileExist) return;
        
        if (isDirectory) {
            NSArray *subPaths = [mgr subpathsAtPath:path];
            for (NSString *subPath in subPaths) {
                
                NSString *filePath = [path stringByAppendingPathComponent:subPath];
                [mgr removeItemAtPath:filePath error:nil];
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
        
    });
    
    
}

- (void)removeCacheWithCompletion:(void (^)())completion
{
    [NSObject removeCacheWithCompletion:completion];
    
}

@end

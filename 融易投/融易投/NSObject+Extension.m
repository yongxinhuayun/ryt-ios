//
//  NSObject+Extension.m
//  42-掌握-NSInvocation
//
//  Created by 王梦思 on 15/11/13.
//  Copyright © 2015年 王梦思. All rights reserved.
//

#import "NSObject+Extension.h"


@implementation NSObject (Extension)


//-(void)performSelector:(SEL)aSelector withObjects:(NSArray *)objects
-(id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects
{
    //8.修改代码
    SEL selector = aSelector;
    
    //1.创建一个方法签名
    //9.修改把ViewController改成[self class]
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    
    //2.使用NSInvocation封装任务
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    //4.告诉目标函数和selector
    invocation.target = self;
    invocation.selector = selector;
    
    /*
    //5.设置参数
    NSString *number = @"10086";

    //self and _cmd 0~1 被占用了,从2开始
    [invocation setArgument:&number atIndex:2];
    
    //6.在添加到2个参数
    NSString *love = @"love";
    [invocation setArgument:&love atIndex:3];
     
    //7.在添加到3个参数
    NSString *status = @"WC";
    [invocation setArgument:&status atIndex:4];
     */
    
    //8.设置参数
//    NSInteger count = objects.count;
    
    //10.因为我们传递的是数组的个数,所以传递不对称时,会报错   [self performSelector:@selector(callWithNumber:) withObjects:@[@"10086",@"love",@"WC"]];
    //我们可以拿到NSMethodSignature中numberOfArguments属性---代表方法真正的要传的参数
//     NSInteger count1 = methodSignature.numberOfArguments;
    
    //运行程序,还是崩掉
    //因为外面的方法传递的是带有一个参数的方法,所以这里会遍历1次,但是methodSignature.numberOfArguments这里面的个数包括里面隐藏的2个参数
    //所以应该减去2
    
//     NSInteger count2 = methodSignature.numberOfArguments - 2;
    
    //11.运行程序,发现不报错了
    //假设外面是这么传的  [self performSelector:@selector(callWithNumber:andContext:) withObjects:@[@"10086"]];
    //报错,因为外界传递的方法要求传2个参数,所以这里遍历2次,跟后面传递的1个参数不符合
    //所以,我们要判断方法传递的参数和后面传递的参数的个数,去最小的那个
    
    NSInteger count2 = methodSignature.numberOfArguments - 2;
    NSInteger count3 = objects.count;
    NSInteger count = MIN(count2, count3);
    
    //12.运行程序,不会报错了
    /*
     - (id)performSelector:(SEL)aSelector;
     - (id)performSelector:(SEL)aSelector withObject:(id)object;
     - (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
     */
    //根据系统的方法可知,上面的方法都返回参数,所以我们最好也返回参数
    //修改方法名
    
    for (NSInteger i = 0; i < count; i++) {
        
        //8.2 不知道objects是神马类型就用id
        id obj = objects[i];
        
        //8.1注意,不能这么传,应该先把他拿出来
//        [invocation setArgument:&objects[i] atIndex:<#(NSInteger)#>]
        
        //8.3从2开始的,所以要加2
        [invocation setArgument:&obj atIndex:i + 2];
    }
    
    //3.调用该方法
    [invocation invoke];

    //12.一定要早调用这个方法[invocation invoke]之后返回参数,在外面新建一个demo方法,有返回数据
    //在NSInvocation中有个方法- (void)getReturnValue:(void *)retLoc;能返回返回值----后面的参数传递的是地址
    
//    id result = nil;
//    
//    [invocation getReturnValue:&result];
//    
//    return result;
    
    //13.外面调用没有返回值的参数时,直接崩掉
    //所以要判断
    //在NSMethodSignature中又2个属性 --- 返回值的类型和个数
    /*
     @property (readonly) const char *methodReturnType NS_RETURNS_INNER_POINTER;
     @property (readonly) NSUInteger methodReturnLength;
     */
    
    NSLog(@"%zd-------%s",methodSignature.methodReturnLength,methodSignature.methodReturnType);
    //打印出来的是  8-------@
    
    id result = nil;
    
    //判断
    if (methodSignature.methodReturnLength >0) {
        [invocation getReturnValue:&result];
    }

    return result;
    
    
}

@end

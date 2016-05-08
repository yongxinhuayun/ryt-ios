//
//  CreationModel.m
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CreationModel.h"

@implementation CreationModel

//1. 因为好多控制器都需要设置时间,所以把2个分类的头文件写入到pch中
//-(NSString *)newCreationEmdDatetime
//{
//    //2.7 制造假数据,看看判断能不能判断准确
////        _newCreationEmdDatetime = @"2015-12-27 20:12:03";
//
//        NSLog(@"%@",_newCreationEmdDatetime); //打印出来的结果是 这种格式 2015-12-27 20:07:03
//    //
//
//    //2. 因为服务器返回的数据是字符串类型,我们要想比较真机现在所处的时间跟用户发布帖子的时间,必须先要转换成NSDate类型的,才能进行比较
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//
//    NSDate *createdAtDate = [fmt dateFromString:_newCreationEmdDatetime];
//
//    //2.1 进行判断,比较出几种情况,是不是今年/昨天/今天/刚刚/几分钟前/几小时之前
//    if ([createdAtDate bs_isThisYear]) { //今年
//        //2.3 判断是今年的情况
//        if (createdAtDate.bs_isYesterday) {//昨天
//            fmt.dateFormat = @"昨天 HH:mm:ss";
//            return [fmt stringFromDate:createdAtDate];
//            //2.4 判断是今天的情况
//        }else if (createdAtDate.bs_isToday){ //今天  要是今天的话需要判断的就很多了
//
//            //因为来到这里的就是今年的数据了,但是要想判断是否为同一天/同一天相差的小时/分钟等,必须要使用NSCalendar类进行判断了
//
//            NSCalendar *calendar = [NSCalendar bs_calendar];
//
//            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//            //需要创建 NSCalendarUnit对象
//            //            NSDateComponents *components = [calendar components:<#(NSCalendarUnit)#> fromDate:<#(nonnull NSDate *)#> toDate:<#(nonnull NSDate *)#> options:<#(NSCalendarOptions)#>]
//            NSDateComponents *components = [calendar components:unit fromDate:createdAtDate toDate:[NSDate date] options:0];
//
//            //2.6 2种判断方式
//            //            if (components.hour == 0 && components.minute == 0) { //刚刚
//            //                return @"刚刚";
//            //            }else if (components.hour == 0){ //几分钟之前
//            //                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
//            //            }else{ //几小时之前
//            //                return [NSString stringWithFormat:@"%zd小时前",components.hour];
//            //            }
//
//            if (components.hour >= 1) { //几小时之前
//
//                return [NSString stringWithFormat:@"%zd小时前",components.hour];
//
//            }else if (components.minute >= 1) { //几分钟之前
//                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
//            }else{ //刚刚
//                return @"刚刚";
//            }
//
//            //2.5 判断既不是昨天也不是今天的情况
//        }else{ //既不是昨天也不是今天,就是几天之前
//
//            fmt.dateFormat = @"MM-dd HH:mm:ss";
//
//            return [fmt stringFromDate:createdAtDate];
//        }
//
//        //2.2 要是不是今天,就直接返回
//    }else{ //不是今年,返回服务器的格式即可
//
//        return _newCreationEmdDatetime;
//    }
//
//
//}

@end

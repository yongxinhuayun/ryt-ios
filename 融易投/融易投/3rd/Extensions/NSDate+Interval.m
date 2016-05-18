//
//  NSObject+FileManager.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NSDate+Interval.h"
#import "NSCalendar+Init.h"

NSString * const BSTimeIntervalDayKey = @"day";
NSString * const BSTimeIntervalHourKey = @"hour";
NSString * const BSTimeIntervalMinuteKey = @"minute";
NSString * const BSTimeIntervalSecondKey = @"second";

@implementation NSDate (Interval)

- (void)bs_timeIntervalSinceDate:(NSDate *)date day:(NSInteger *)day hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second
{
    // 求出self和date相差多少秒
    NSInteger interval = [self timeIntervalSinceDate:date];

    // 1天有多少秒
    NSInteger secondsPerDay = 24 * 60 * 60;
    // 1小时有多少秒
    NSInteger secondsPerHour = 60 * 60;
    // 1分钟有多少秒
    NSInteger secondsPerMinute = 60;

    *day = interval / secondsPerDay;
    *hour = (interval % secondsPerDay) / secondsPerHour;
    *minute = ((interval % secondsPerDay) % secondsPerHour) / secondsPerMinute;
    *second = ((interval % secondsPerDay) % secondsPerHour) % secondsPerMinute;
}

//- (NSArray *)bs_timeIntervalSinceDate:(NSDate *)date
//{
//    // 求出self和date相差多少秒
//    NSInteger interval = [self timeIntervalSinceDate:date];
//
//    // 1天有多少秒
//    NSInteger secondsPerDay = 24 * 60 * 60;
//    // 1小时有多少秒
//    NSInteger secondsPerHour = 60 * 60;
//    // 1分钟有多少秒
//    NSInteger secondsPerMinute = 60;
//
//    NSInteger day = interval / secondsPerDay;
//    NSInteger hour = (interval % secondsPerDay) / secondsPerHour;
//    NSInteger minute = ((interval % secondsPerDay) % secondsPerHour) / secondsPerMinute;
//    NSInteger second = ((interval % secondsPerDay) % secondsPerHour) % secondsPerMinute;
//    
//    return @[@(day), @(hour), @(minute), @(second)];
//}

//- (NSDictionary *)bs_timeIntervalSinceDate:(NSDate *)date
//{
//    // 求出self和date相差多少秒
//    NSInteger interval = [self timeIntervalSinceDate:date];
//    
//    // 1天有多少秒
//    NSInteger secondsPerDay = 24 * 60 * 60;
//    // 1小时有多少秒
//    NSInteger secondsPerHour = 60 * 60;
//    // 1分钟有多少秒
//    NSInteger secondsPerMinute = 60;
//    
//    NSInteger day = interval / secondsPerDay;
//    NSInteger hour = (interval % secondsPerDay) / secondsPerHour;
//    NSInteger minute = ((interval % secondsPerDay) % secondsPerHour) / secondsPerMinute;
//    NSInteger second = ((interval % secondsPerDay) % secondsPerHour) % secondsPerMinute;
//    
//    return @{
//             BSTimeIntervalDayKey : @(day),
//             BSTimeIntervalHourKey : @(hour),
//             BSTimeIntervalMinuteKey : @(minute),
//             BSTimeIntervalSecondKey : @(second)
//             };
//}

- (BSTimeInterval *)bs_timeIntervalSinceDate:(NSDate *)date
{
    // 求出self和date相差多少秒
    NSInteger interval = [self timeIntervalSinceDate:date];
    
    // 1天有多少秒
    NSInteger secondsPerDay = 24 * 60 * 60;
    // 1小时有多少秒
    NSInteger secondsPerHour = 60 * 60;
    // 1分钟有多少秒
    NSInteger secondsPerMinute = 60;
    
    BSTimeInterval *intervalObject = [[BSTimeInterval alloc] init];
    intervalObject.day = interval / secondsPerDay;
    intervalObject.hour = (interval % secondsPerDay) / secondsPerHour;
    intervalObject.minute = ((interval % secondsPerDay) % secondsPerHour) / secondsPerMinute;
    intervalObject.second = ((interval % secondsPerDay) % secondsPerHour) % secondsPerMinute;
    return intervalObject;
}

- (BOOL)bs_isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]]; // 20151226
    NSString *selfString = [fmt stringFromDate:self]; // 20151226
    
    return [nowString isEqualToString:selfString];
}

//- (BOOL)bs_isToday
//{
//    NSCalendar *calendar = [NSCalendar bs_calendar];
//
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    
//    return nowCmps.year == selfCmps.year
//           && nowCmps.month == selfCmps.month
//           && nowCmps.day == selfCmps.day;
//}

/**
 * 判断self是否为今年
 */
- (BOOL)bs_isThisYear
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy";
    
    NSString *nowYear = [fmt stringFromDate:[NSDate date]];
    NSString *selfYear = [fmt stringFromDate:self];
    
    return [nowYear isEqualToString:selfYear];
//    return [nowYear isEqual:selfYear];
}

//- (BOOL)bs_isThisYear
//{
//    NSCalendar *calendar = [NSCalendar bs_calendar];
//    
//    NSInteger nowYear = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]].year;
//    NSInteger selfYear = [calendar components:NSCalendarUnitYear fromDate:self].year;
//    
//    return nowYear == selfYear;
//}

- (BOOL)bs_isYesterday
{
    // now : 2015-12-01 12:14:57 ->  2015-12-01 00:00:00
    // self : 2015-11-30 11:11:20 -> 2015-11-30 00:00:00
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    // 生成只有年月日的字符串
    NSString *nowString = [fmt stringFromDate:[NSDate date]]; // 20151201
    NSString *selfString = [fmt stringFromDate:self]; // 20151130
    
    // 生成只有年月日的日期
    NSDate *nowDate = [fmt dateFromString:nowString];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
//    NSLog(@"%@  %@",self,selfDate);
//    
//    return YES;
    
    // 比较nowDate和selfDate的差值
    NSCalendar *calendar = [NSCalendar bs_calendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
           && cmps.month == 0
           && cmps.day == 1;
}

- (BOOL)bs_isTomorrow
{    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    // 生成只有年月日的字符串
    NSString *nowString = [fmt stringFromDate:[NSDate date]]; // 20151201
    NSString *selfString = [fmt stringFromDate:self]; // 20151130
    
    // 生成只有年月日的日期
    NSDate *nowDate = [fmt dateFromString:nowString];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    // 比较nowDate和selfDate的差值
    NSCalendar *calendar = [NSCalendar bs_calendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == -1;
}

//1. 因为好多控制器都需要设置时间,所以把2个分类的头文件写入到pch中
-(NSString *)created_at:(NSString *)date
{
    //2.7 制造假数据,看看判断能不能判断准确
    //    BSLog(@"%@",_created_at); //打印出来的结果是 这种格式 2015-12-27 20:07:03
    //
    //    _created_at = @"2015-12-27 20:12:03";
    
//    2. 因为服务器返回的数据是字符串类型,我们要想比较真机现在所处的时间跟用户发布帖子的时间,必须先要转换成NSDate类型的,才能进行比较
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt dateFromString:date];
    
    //2.1 进行判断,比较出几种情况,是不是今年/昨天/今天/刚刚/几分钟前/几小时之前
    if ([createdAtDate bs_isThisYear]) { //今年
        //2.3 判断是今年的情况
        if (createdAtDate.bs_isYesterday) {//昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
            //2.4 判断是今天的情况
        }else if (createdAtDate.bs_isToday){ //今天  要是今天的话需要判断的就很多了
            
            //因为来到这里的就是今年的数据了,但是要想判断是否为同一天/同一天相差的小时/分钟等,必须要使用NSCalendar类进行判断了
            
            NSCalendar *calendar = [NSCalendar bs_calendar];
            
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            //需要创建 NSCalendarUnit对象
            //            NSDateComponents *components = [calendar components:<#(NSCalendarUnit)#> fromDate:<#(nonnull NSDate *)#> toDate:<#(nonnull NSDate *)#> options:<#(NSCalendarOptions)#>]
            NSDateComponents *components = [calendar components:unit fromDate:createdAtDate toDate:[NSDate date] options:0];
            NSLog(@"%@",components);
            
            //2.6 2种判断方式
            //            if (components.hour == 0 && components.minute == 0) { //刚刚
            //                return @"刚刚";
            //            }else if (components.hour == 0){ //几分钟之前
            //                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
            //            }else{ //几小时之前
            //                return [NSString stringWithFormat:@"%zd小时前",components.hour];
            //            }
            
            if (components.hour >= 1) { //几小时之前
                fmt.dateFormat = @"HH:mm";
                return [fmt stringFromDate:createdAtDate];
//                return [NSString stringWithFormat:@"%zd小时前",components.hour];
                
            }else if (components.minute >= 1 ) { //几分钟之前
                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
            }else{ //刚刚
                return @"刚刚";
            }
            //2.5 判断既不是昨天也不是今天的情况
        }else{ //既不是昨天也不是今天,就是几天之前
            
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            
            return [fmt stringFromDate:createdAtDate];
        }
        
        //2.2 要是不是今天,就直接返回
    }else{ //不是今年,返回服务器的格式即可
        
        return date;
    }
    
}
-(NSString *)createdAt:(NSString *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt dateFromString:date];
    //2.1 进行判断,比较出几种情况,是不是今年/昨天/今天/刚刚/几分钟前/几小时之前
    if ([createdAtDate bs_isThisYear]) { //今年
        //2.3 判断是今年的情况
        if (createdAtDate.bs_isYesterday) {//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createdAtDate];
            //2.4 判断是今天的情况
        }else if (createdAtDate.bs_isToday){ //今天  要是今天的话需要判断的就很多了
            //因为来到这里的就是今年的数据了,但是要想判断是否为同一天/同一天相差的小时/分钟等,必须要使用NSCalendar类进行判断了
            NSCalendar *calendar = [NSCalendar bs_calendar];
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *components = [calendar components:unit fromDate:createdAtDate toDate:[NSDate date] options:0];
            if (components.hour >= 1) { //几小时之前
                fmt.dateFormat = @"HH:mm";
                return [fmt stringFromDate:createdAtDate];
            }else if (components.minute >= 1 ) { //几分钟之前
                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
            }else{ //刚刚
                return @"刚刚";
            }
            //2.5 判断既不是昨天也不是今天的情况
        }else{ //既不是昨天也不是今天,就是几天之前
            fmt.dateFormat = @"yyyy-MM-dd";
            return [fmt stringFromDate:createdAtDate];
        }
        //2.2 要是不是今天,就直接返回
    }else{ //不是今年,返回服务器的格式即可
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createdAtDate];
    }
}

@end

@implementation BSTimeInterval

@end

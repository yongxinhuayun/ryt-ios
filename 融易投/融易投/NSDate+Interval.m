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

@end

@implementation BSTimeInterval

@end

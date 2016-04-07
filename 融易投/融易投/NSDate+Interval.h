//
//  NSObject+FileManager.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTimeInterval : NSObject
/** 相隔多少天 */
@property (nonatomic, assign) NSInteger day;
/** 相隔多少小时 */
@property (nonatomic, assign) NSInteger hour;
/** 相隔多少分钟 */
@property (nonatomic, assign) NSInteger minute;
/** 相隔多少秒 */
@property (nonatomic, assign) NSInteger second;
@end

extern NSString * const BSTimeIntervalDayKey;
extern NSString * const BSTimeIntervalHourKey;
extern NSString * const BSTimeIntervalMinuteKey;
extern NSString * const BSTimeIntervalSecondKey;

typedef enum {
    BSTimeIntervalIndexDay = 0,
    BSTimeIntervalIndexHour = 1,
    BSTimeIntervalIndexMinute = 2,
    BSTimeIntervalIndexSecond = 3
} BSTimeIntervalIndex;

@interface NSDate (Interval)
- (void)bs_timeIntervalSinceDate:(NSDate *)date day:(NSInteger *)day hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second;
/**
 * 返回值数组:0位置是day,1.....
 * 返回值数组:元素索引位置参考BSTimeIntervalIndex
 */
//- (NSArray *)bs_timeIntervalSinceDate:(NSDate *)date;

/**
 * 返回值字典:key参考BSTimeIntervalXXXKey
 */
//- (NSDictionary *)bs_timeIntervalSinceDate:(NSDate *)date;

- (BSTimeInterval *)bs_timeIntervalSinceDate:(NSDate *)date;

- (BOOL)bs_isYesterday;
- (BOOL)bs_isToday;
- (BOOL)bs_isTomorrow;
- (BOOL)bs_isThisYear;
@end

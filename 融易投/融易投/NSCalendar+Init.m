//
//  NSObject+FileManager.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NSCalendar+Init.h"

@implementation NSCalendar (Init)

+ (instancetype)bs_calendar
{
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        return [NSCalendar currentCalendar];
    }
//    NSCalendar *calendar = nil;
//    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
//        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//    } else {
//        calendar = [NSCalendar currentCalendar];
//    }
//    return calendar;
    
}
@end

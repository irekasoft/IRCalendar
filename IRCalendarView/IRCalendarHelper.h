//
//  IRCalendarHelper.h
//  IRCalendarViewController
//
//  Created by Muhammad Hijazi  on 19/3/13.
//  Copyright (c) 2013 irekasoft. All rights reserved.
//
//  IRCalendarHelper V0.1

#import <Foundation/Foundation.h>

@interface IRCalendarHelper : NSObject


// Helpers

+ (NSString *)stringFromDate:(NSDate*)date withDateFormat:(NSString*)dateFormat;
+ (NSString *)stringMonthYearIDFromDate:(NSDate*)date;
+ (NSDate *)dateWithDay:(int)day month:(int)month year:(int)year;
+ (NSString *)stringMonthYearFromDate:(NSDate*)date;

+ (int)intMonthFromDate:(NSDate *)date;
+ (int)intYearFromDate:(NSDate *)date;
+ (int)intDayFromDate:(NSDate *)date;

+ (NSDate *) dateForDayFromDate:(NSDate *)date;

+ (NSString *)getShortDayName:(int)number;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

@end

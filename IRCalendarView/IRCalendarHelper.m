//
//  IRCalendarHelper.m
//  IRCalendarViewController
//
//  Created by Muhammad Hijazi  on 19/3/13.
//  Copyright (c) 2013 irekasoft. All rights reserved.
//

#import "IRCalendarHelper.h"

@implementation IRCalendarHelper

#pragma mark - Helper

+ (NSString *)stringFromDateStyle:(NSDate*)date{
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    // get time
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
}

+ (NSString *)stringWithRelativeFromDate:(NSDate*)date{
    
    NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:locale];
    
    
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDoesRelativeDateFormatting:YES];
    
    // get time
    return [NSString stringWithFormat:@"%@",
            [format stringFromDate:date]];
    
}

+ (NSString *)stringFromDate:(NSDate*)date withDateFormat:(NSString*)dateFormat{
    
//    NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:locale];
    [format setDateFormat:dateFormat];
    
    // get time
    return [NSString stringWithFormat:@"%@",
            [format stringFromDate:date]];
    
}

+ (NSString *)stringMonthYearFromDate:(NSDate*)date{
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:locale];
    [format setDateFormat:@"MMMM yyyy"];
    
    // get time
    return [NSString stringWithFormat:@"%@",
            [format stringFromDate:date]];
    
}

+ (NSString *)stringMonthYearIDFromDate:(NSDate*)date{
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:locale];
    [format setDateFormat:@"yyyyMM"];
    
    return [NSString stringWithFormat:@"%@",
            [format stringFromDate:date]];
    
}


+ (int)intMonthFromDate:(NSDate *)date{
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:locale];
    [format setDateFormat:@"M"];
    
    return [[NSString stringWithFormat:@"%@",
             [format stringFromDate:date]] intValue];
    
}

+ (int)intYearFromDate:(NSDate *)date{
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:locale];
    [format setDateFormat:@"yyyy"];
    
    return [[NSString stringWithFormat:@"%@",
             [format stringFromDate:date]] intValue];
    
}

+ (int)intDayFromDate:(NSDate *)date{
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:locale];
    [format setDateFormat:@"d"];
    
    return [[NSString stringWithFormat:@"%@",
             [format stringFromDate:date]] intValue];
    
}


+ (NSDate *)dateWithDay:(int)day month:(int)month year:(int)year{
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:day];
    [components setYear:year];
    [components setMonth:month];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorian dateFromComponents:components];
    
}

+ (NSDate *) dateForDayFromDate:(NSDate *)date{
    
    int day     = [IRCalendarHelper intDayFromDate:date];
    int month   = [IRCalendarHelper intMonthFromDate:date];
    int year    = [IRCalendarHelper intYearFromDate:date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:day];
    [components setYear:year];
    [components setMonth:month];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorian dateFromComponents:components];
    
}

+ (NSString *)getShortDayName:(int)number{
    // Make reference at November 2010
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    
    [components setYear:2010];
    [components setMonth:11];
    [components setDay:number];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EE"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    
    
    return [newDateString substringToIndex:1];
}


+ (NSString *)getMonthName:(int)number{
    // Make reference at November 2010
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    
    [components setYear:2010];
    [components setMonth:number];
    [components setDay:1];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMMM"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    
    
    return newDateString;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:format];
    
    NSDate *date = [formatter dateFromString:string];
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    
    comp.hour = 12;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    date = [cal dateByAddingComponents:comp toDate:date options:0];
    
    
    
    return date;
    
}

+ (NSDate *)dateFromString:(NSString *)string{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:string];
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    
    comp.hour = 12;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    date = [cal dateByAddingComponents:comp toDate:date options:0];
    
    return date;
}

//--------

+ (NSString *)stringFromDate:(NSDate*)date withDateFormat:(NSString*)dateFormat withLocaleID:(NSString *)localeID{
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeID];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:locale];
    [format setDateFormat:dateFormat];
    
    // get time
    return [NSString stringWithFormat:@"%@",
            [format stringFromDate:date]];
    
}

@end

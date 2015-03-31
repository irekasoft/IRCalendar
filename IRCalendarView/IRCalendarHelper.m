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

+ (NSString *)stringFromDate:(NSDate*)date withDateFormat:(NSString*)dateFormat{
    
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
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
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
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	return [gregorian dateFromComponents:components];
    
}

+ (NSString *)getShortDayName:(int)number{
	// Make reference at November 2010
	NSDateComponents *components = [[NSDateComponents alloc] init] ;
	
	[components setYear:2010];
	[components setMonth:11];
	[components setDay:number];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDate *date = [gregorian dateFromComponents:components];
	
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"EE"];
	NSString *newDateString = [outputFormatter stringFromDate:date];
 
	
	return [newDateString substringToIndex:1];
}




@end

//
//  IRCalendarView.h
//  IRCalendarView
//
//  Created by Hijazi on 30/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRCalendarHelper.h"

#define DAY_LABEL_TAG 111

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

enum DayName {
    
    DayNameSun = 1,
    DayNameMon = 2,
    DayNameTue = 3,
    DayNameWed = 4,
    DayNameThu = 5,
    DayNameFri = 6,
    DayNameSat = 7,
    
};


@interface IRCalendarView : UIView {

    enum DayName aStartDay;
    
    // calendar view bounds
    
    int cell[6][7];
    
    int maxCalRow;
    
    int prevCell[7];
    int nextCell[7];
    
    
    CGFloat dH;
    CGFloat dW;
    CGFloat min_side;
    
    CGFloat phoneOffsetX, phoneOffsetY;
    CGFloat fontSize;
    CGFloat monthLabelYOffset;
    CGFloat todayBoxHeight;
    CGFloat todayBoxOffset;
    
    UIView *calendarDetailView;
    
    UILabel *monthLabel;
    
    UILabel *dayNumberLabel;
    
    int nextMonthDay;
    
    BOOL isPhone;

    
}

@property (assign, nonatomic) enum DayName startDay;
@property (strong, nonatomic) NSDate *todayDate;



@property (nonatomic) BOOL isColorful;
@property (nonatomic) int displayMonth;
@property (nonatomic) int displayYear;
@property (nonatomic) int currentMonth;
@property (nonatomic) int currentYear;
@property (nonatomic) int currentDay;
@property (nonatomic) BOOL isStartFromSunday;

@property (strong, nonatomic) NSDate *date;

//- (void)gotoToday;


@end

//
//  IRCalendarView.m
//  IRCalendarView
//
//  Created by Hijazi on 30/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#import "IRCalendarView.h"

#define SUNDAY_COLOR [UIColor greyColor]
#define IRCALVH IRCalendarHelper
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface IRCalendarView ()


@end

@implementation IRCalendarView

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    
    // for demo
    self.isStartFromSunday = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.todayDate = [IRCALVH dateForDayFromDate:[NSDate date]];
    self.currentYear    = [IRCALVH intYearFromDate:self.todayDate];
    self.currentMonth   = [IRCALVH intMonthFromDate:self.todayDate];
    self.currentDay     = [IRCALVH intDayFromDate:self.todayDate];
    
    NSLog(@"year %d %d %d",self.displayYear, self.displayMonth, self.currentDay);
    
    // Create a place holder for dynamically changed number for in calendar
    calendarDetailView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:calendarDetailView];
    
    [self displayDaysLabel];

    
    
}



- (void)displayDaysLabel{
    
    //-----------------------------------
    // put day "S M T W T F S"
    //-----------------------------------
    fontSize = 20;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]] && view.tag == DAY_LABEL_TAG) {
            [view removeFromSuperview];
        }
    }
    
    // get size
    dW = self.bounds.size.width/7.0f;
    dH = self.bounds.size.height/7.0f;
    min_side = MIN(dW, dH);
    
    
    NSLog(@"label startWeekOn %d", startWeekOn);
    for (int i = 0; i < 7; i ++) {
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(i* dW, -dH, dW, dH)];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.backgroundColor = [UIColor clearColor];

        dayLabel.text = [[self getShortDayName:i from:startWeekOn] substringToIndex:3];
        dayLabel.tag = DAY_LABEL_TAG;
        dayLabel.textColor = [UIColor whiteColor];
        [self addSubview:dayLabel];
        
        [dayLabel setFont:[UIFont systemFontOfSize:fontSize]];
        
        // red color on sunday
        if (startWeekOn == DayNameSun){
            if (i == 0) dayLabel.textColor = [UIColor redColor];
        }else if (startWeekOn == DayNameMon){
            if (i == 6) dayLabel.textColor = [UIColor redColor];
        }
        
    }
    
}

#pragma mark - setter

- (void)setDate:(NSDate *)date {
    nextMonthDay = 0;
    _date = date;
    
    self.displayYear = [IRCALVH intYearFromDate:date];
    self.displayMonth = [IRCALVH intMonthFromDate:date];
    
    [self setupCellForCurrentMonthWithDate:date];
    
    [self displayDaysLabel];
    [self setNeedsDisplay];
}

- (NSInteger)normalizeFirstDay:(NSInteger)firstDay{
    NSInteger retVal;
    if (firstDay >= 0) {
        retVal = firstDay;
    }else{
        switch (firstDay) {
            
            case -1:{
                retVal = 6;
            }break;
            case -2:{
                retVal = 5;
            }break;
            case -3:{
                retVal = 4;
            }break;
            case -4:{
                retVal = 3;
            }break;
            case -5:{
                retVal = 2;
            }break;
            case -6:{
                retVal = 1;
            }break;

            default:
                break;
        }
    }
    return retVal;
}


- (void)setupCellForCurrentMonthWithDate:(NSDate *)date{
    
    // We want to make a custom NSDate
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[IRCALVH intYearFromDate:date]];
    [components setMonth:[IRCALVH intMonthFromDate:date]];
    [components setDay:1];
    
    // get the date with component stated
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *myDate = [gregorian dateFromComponents:components];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [outputFormatter setLocale:locale];
    [outputFormatter setDateFormat:@"c"];

    NSDateFormatter *outputFormatter2 = [[NSDateFormatter alloc] init];
    [outputFormatter2 setLocale:locale];
    [outputFormatter2 setDateFormat:@"EE"];

    
    // firstDay 1 ~ 7 : Monday ~ Sunday
    // 1    2    3    4    5    6    7
    // Sun  Mon  Tue  Wed  Thu  Fri  Sat
    
    NSInteger firstDay;
    NSInteger dayOnFirstDay = [[outputFormatter stringFromDate:myDate] intValue];
    NSLog(@"first day is %d %@",[[outputFormatter stringFromDate:myDate] intValue],[outputFormatter2 stringFromDate:myDate]);
    
    // legacy format
    if (self.isStartFromSunday) {
        if (self.isStartFromSunday == YES){
            
            startWeekOn = DayNameSun;
            
        }else if (self.isStartFromSunday == NO){
            
            startWeekOn = DayNameMon;
        }

    }

    // start exec
    if (startWeekOn == DayNameSun){
        firstDay = dayOnFirstDay-1;
    }else if (startWeekOn == DayNameMon){
        firstDay = dayOnFirstDay-2;
    }else if (startWeekOn == DayNameTue){
        firstDay = dayOnFirstDay-3;
    }else if (startWeekOn == DayNameWed){
        firstDay = dayOnFirstDay-4;
    }else if (startWeekOn == DayNameThu){
        firstDay = dayOnFirstDay-5;
    }else if (startWeekOn == DayNameFri){
        firstDay = dayOnFirstDay-6;
    }else if (startWeekOn == DayNameSat){
        firstDay = dayOnFirstDay-7;
    }
    firstDay = [self normalizeFirstDay:firstDay];
    
    NSLog(@"first day normalized %ld", firstDay);
    
    // get how many days in a calendar
    NSRange rangeForDay = [gregorian rangeOfUnit:NSCalendarUnitDay
                                          inUnit:NSCalendarUnitMonth
                                         forDate:myDate];
    
    NSInteger lastDay = rangeForDay.length;
    //NSLog(@"lastDay %d", lastDay);
    
    // reformat cell arrays
    for(int i=0;i<6;i++){
        for(int j=0;j<7;j++){
            cell[i][j]= 0;
        }
    }
    
    maxCalRow = 0;
    int dateNumber = 1;
    for (int i = 0; i < 6; i ++) {
        for (int j = 0; j < 7; j ++) {
            if (i == 0 && j < firstDay ) {
                
            }else {
                if (dateNumber > lastDay) {
                    
                    cell[i][j] = 0;
                    
                }else {
                    cell[i][j] = dateNumber;
                    maxCalRow = i + 1;
                    
                    dateNumber ++;
                }
            }
        }
    }
    
    NSLog(@"max cal row %d", maxCalRow);
    
}

- (void)setIsStartFromSunday:(BOOL)isStartFromSunday{
    
    if (isStartFromSunday) {
        startWeekOn = DayNameSun;
    }else{
        startWeekOn = DayNameMon;
    }
    _isStartFromSunday = isStartFromSunday;
    
    [self displayDaysLabel];
    
    
    [self setNeedsDisplay];
    
    
}

- (void)setStartWeekOn:(enum DayName)startWeekOn_{
    
    
    startWeekOn = startWeekOn_;
    
    _isStartFromSunday = NO;
    
    [self displayDaysLabel];
    [self setupCellForCurrentMonthWithDate:self.date];
    [self setNeedsDisplay];
   
    
}



#pragma mark - drawrect

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    NSLog(@"startfromsunday %d",self.isStartFromSunday);
    
    // refresh subview when setNeedDisplay
    if ([[calendarDetailView subviews] lastObject]) {
        for (UIView *subview in [calendarDetailView subviews]) [subview removeFromSuperview];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat box_side = self.bounds.size.width / 7.0;
    
    // add view for numbers
    for (int row = 0; row < maxCalRow; row++){
        
        for (int col = 0; col < 7; col++){
            
            NSString *dayString = [NSString stringWithFormat:@"%d",cell[row][col]];
            if ([dayString intValue] == 0) {
                dayString = @"";
            }
            
            //NSLog(@" current %d, %d %d",[dayString intValue], self.currentMonth, self.currentYear);
            // current day, current month, and current year
            if (([dayString intValue] == self.currentDay) &&
                self.displayMonth == self.currentMonth &&
                self.displayYear == self.currentYear) {
                
                NSLog(@"matched");
                
                //dateTile.backgroundColor = [UIColor whiteColor];
                dayNumberLabel.textColor = [UIColor whiteColor];
                
                CGColorRef blackColor = [UIColor redColor].CGColor;
                CGContextSetFillColorWithColor(context, blackColor);
                CGRect dateHighlighterRect;
                
                
                CGFloat box_min_side = MIN(dW, dH);
                
                //// Oval Drawing
                UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(col*dW + (dW - box_min_side)/2, row*dH , box_min_side , box_min_side)];
                [[UIColor redColor] setFill];
                [ovalPath fill];
                
                CGFloat outerMargin = 0.0f;
                CGRect outerRect = CGRectInset(dateHighlighterRect, outerMargin, outerMargin);
                CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 5);
                CGContextAddPath(context, outerPath);
                CGContextFillPath(context);
                
            }
            
            //// Text Drawing
            CGRect textRect = CGRectMake(col* dW, row* dH, box_side, dH);
            UIBezierPath* textPath = [UIBezierPath bezierPathWithRect: textRect];
            [UIColor.redColor setStroke];
            textPath.lineWidth = 1;
            [textPath stroke];
            {
                
                
                NSString* textContent = dayString;
                
                NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                textStyle.alignment = NSTextAlignmentCenter;
                
                NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: UIFont.labelFontSize], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
                
                CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
                CGContextSaveGState(context);
                CGContextClipToRect(context, textRect);
                [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
                CGContextRestoreGState(context);
                
            }
            
            dayNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(col* dW, row* dH , 45, 45)];
            dayNumberLabel.textAlignment = NSTextAlignmentCenter;
            
            dayString = [NSString stringWithFormat:@"%d",cell[row][col]];
            if ([dayString intValue] == 0) {
                dayString = @"";
            }
            // bug fixes on displaying mojibake (ghost character)
            
            dayNumberLabel.text = dayString;
            dayNumberLabel.backgroundColor = [UIColor clearColor];
            dayNumberLabel.textColor = [UIColor blackColor];
            [dayNumberLabel setFont:[UIFont systemFontOfSize:fontSize]];
//            [calendarDetailView addSubview:dayNumberLabel];
            
            [dayNumberLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:dayNumberLabel.font.pointSize]];
            
            //
            // COLORFUL COLORING
            if (self.isColorful) {
                
                if (self.isStartFromSunday) {
                    switch (col) {
                        case 0:
                            dayNumberLabel.textColor = UIColorFromRGB(0xE74C3C);
                            break;
                        case 1:
                            dayNumberLabel.textColor = [UIColor orangeColor];
                            break;
                        case 2:
                            dayNumberLabel.textColor = [UIColor colorWithRed:1 green:0.7 blue:0 alpha:1];
                            break;
                        case 3:
                            dayNumberLabel.textColor = [UIColor colorWithRed:0 green:0.8 blue:0.2 alpha:1];
                            break;
                        case 4:
                            dayNumberLabel.textColor = UIColorFromRGB(0x3498DB);
                            break;
                        case 5:
                            dayNumberLabel.textColor = [UIColor orangeColor];
                            break;
                        case 6:
                            dayNumberLabel.textColor = [UIColor lightGrayColor];
                            break;
                            
                        default:
                            break;
                    }
                }else if (!self.isStartFromSunday) {
                    switch (col) {
                        case 0:
                            dayNumberLabel.textColor = [UIColor lightGrayColor];
                            break;
                        case 1:
                            dayNumberLabel.textColor = [UIColor orangeColor];
                            break;
                        case 2:
                            dayNumberLabel.textColor = [UIColor colorWithRed:1 green:0.7 blue:0 alpha:1];
                            break;
                        case 3:
                            dayNumberLabel.textColor = [UIColor colorWithRed:0 green:0.8 blue:0.2 alpha:1];
                            break;
                        case 4:
                            dayNumberLabel.textColor = UIColorFromRGB(0x3498DB);
                            //flatBlueColor
                            break;
                        case 5:
                            dayNumberLabel.textColor = [UIColor orangeColor];
                            break;
                        case 6:
                            dayNumberLabel.textColor = UIColorFromRGB(0xE74C3C); // red
                            
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                
                // B&W COLORING
            } else {
                
                if(self.isStartFromSunday){
                    
                    switch (col) {
                        case 0:
                            dayNumberLabel.textColor = [UIColor redColor];
                            break;
                        default:
                            dayNumberLabel.textColor = [UIColor whiteColor];
                            break;
                    }
                }else{
                    switch (col) {
                        case 6:
                            dayNumberLabel.textColor = [UIColor redColor];
                            break;
                        default:
                            dayNumberLabel.textColor = [UIColor whiteColor];
                            break;
                    }
                }
                
            }
            
            
            
            
            
        }
    }
}

#pragma mark - helpers 

- (NSString *)getShortDayName:(int)number from:(enum DayName)startDay{
    // Make reference at November 2010
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setYear:2010];
    [components setMonth:11];
    [components setDay:number + startDay + 6];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EE"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [outputFormatter setLocale:locale];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    
    //	return [newDateString substringToIndex:1];
    return newDateString;
}

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius) {
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    return path;        
}



@end

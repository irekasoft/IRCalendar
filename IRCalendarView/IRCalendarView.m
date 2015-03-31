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
    //[self test];
    
    // We want to make a custom NSDate
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-7];
    
    NSDate *now = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateByAddingComponents:components toDate:now options:0];
    
    // Formatter configuration
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    [formatter setDateFormat:@"dd MM yyyy - e c"];
    // Date to string
    
    NSString *prettyDate = [formatter stringFromDate:date];
    NSLog(@"prettyDate %@", prettyDate);
    
}

- (void)test{

    for (int i = 2010; i <= 2015; i++) {
        
        for (int j = 1; j <= 12; j++) {
            NSDate *now = [IRCalendarHelper dateWithDay:1 month:j year:i];
            
            // Formatter configuration
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [formatter setLocale:posix];
            [formatter setDateFormat:@"dd MM yyyy - e c"];
            // Date to string
            
            NSString *prettyDate = [formatter stringFromDate:now];
            NSLog(@"prettyDate %@", prettyDate);
        }
        
        
    }
    
    
}

- (void)displayDaysLabel{
    
    phoneOffsetX = 0;
    phoneOffsetY = 0;
    monthLabelYOffset = -150;
    todayBoxHeight = 30;
    todayBoxOffset = 2;
    //-----------------------------------
    // put day "S M T W T F S"
    //-----------------------------------
    if (IS_IPHONE) {
        fontSize = 18;
    }else{
        fontSize = 24;
    }
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]] && view.tag == DAY_LABEL_TAG) {
            [view removeFromSuperview];
        }
    }
    
    // get size
    dW = self.bounds.size.width/7.0f;
    dH = self.bounds.size.height/7.0f;
    min_side = MIN(dW, dH);
    
    //NSLog(@" %f %f", dW, dH);
    CGFloat labelHeight = 20;
    for (int i = 0; i < 7.0; i ++) {
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(i* dW, -labelHeight, dW, labelHeight)];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.backgroundColor = [UIColor clearColor];

        dayLabel.text = [[self getShortDayName:i from:aStartDay] substringToIndex:3];
        dayLabel.tag = DAY_LABEL_TAG;
        dayLabel.textColor = [UIColor whiteColor];
        [self addSubview:dayLabel];
        
        [dayLabel setFont:[UIFont systemFontOfSize:fontSize]];
        
        // red color on sunday
        if (aStartDay == DayNameSun){
            if (i == 0) dayLabel.textColor = [UIColor redColor];
        }else if (aStartDay == DayNameMon){
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
    [self setNeedsDisplay];
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
    
    // firstDay 1 ~ 7 : Monday ~ Sunday
    // 1   2   3   4   5   6   7
    // Mon  Tue Wed Thu Fri Sat Sun
    
    if (self.startDay){
        
        aStartDay = self.startDay;
        
    }
    
    // This algorithm to create a calendar
    //
    // get the first day. mon ~ friday
    NSInteger firstDay = [[outputFormatter stringFromDate:myDate] intValue] - aStartDay;
    
    NSLog(@"first day is %d",firstDay);
    if (firstDay < 0 ) firstDay = DayNameFri;
    
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
        aStartDay = DayNameSun;
    }else{
        aStartDay = DayNameMon;
    }
    _isStartFromSunday = isStartFromSunday;
    [self setNeedsDisplay];
    [self displayDaysLabel];
    
}

- (void)setStartDay:(enum DayName)startDay{
    
    aStartDay = startDay;
    
    if (startDay == DayNameSun) {
        
        _isStartFromSunday = YES;
        
    }else if (startDay == DayNameMon){
        _isStartFromSunday = NO;
    }
    
    [self setNeedsDisplay];
    [self displayDaysLabel];
    
}

#pragma mark - drawrect

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    NSLog(@"startfromsunday %d",self.isStartFromSunday);
    //  currentDate.isDayStartOnSun = [DEFAULTS boolForKey:[Define getSwitchNameWithNumber:kSwitchCalendarStartFromSunday]];
    
    // refresh subview when setNeedDisplay
    if ([[calendarDetailView subviews] lastObject]) {
        for (UIView *subview in [calendarDetailView subviews]) [subview removeFromSuperview];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat box_side = self.bounds.size.width / 7.0;
    
    // add view for numbers
    for (int row = 0; row < maxCalRow; row++){
        
        for (int col = 0; col < 7; col++){
            
            //// Text Drawing
            CGRect textRect = CGRectMake(col* dW, row* dH, box_side, dH);
            UIBezierPath* textPath = [UIBezierPath bezierPathWithRect: textRect];
            [UIColor.redColor setStroke];
            textPath.lineWidth = 1;
            [textPath stroke];
            {
                NSString *dayString = [NSString stringWithFormat:@"'%d'",cell[row][col]];
//                if ([dayString intValue] == 0) {
//                    dayString = @"";
//                }
                
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
            
            NSString *dayString = [NSString stringWithFormat:@"%d",cell[row][col]];
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
            
            
            //NSLog(@" current %d, %d %d",[dayString intValue], self.currentMonth, self.currentYear);
            // current day, current month, and current year
            if (([dayString intValue] == self.currentDay) &&
                self.displayMonth == self.currentMonth &&
                self.displayYear == self.currentYear){
                
                NSLog(@"matched");
                
                //dateTile.backgroundColor = [UIColor whiteColor];
                dayNumberLabel.textColor = [UIColor whiteColor];
                
                CGColorRef blackColor = [UIColor redColor].CGColor;
                CGContextSetFillColorWithColor(context, blackColor);
                CGRect dateHighlighterRect;
                
                
                
                if (IS_IPHONE) {
                    // TODO: need to change to perfect box
                    //dateHighlighterRect = CGRectMake(j* dW  , i* dH , todayBoxHeight, todayBoxHeight);
                    
                    dateHighlighterRect = CGRectMake(col* dW + dW/4 , row* dH + dH/4, todayBoxHeight, todayBoxHeight);
                    
                }else {
                    dateHighlighterRect = CGRectMake(col* dW , row* dH , todayBoxHeight+ dW/4 , todayBoxHeight+ dH/4);
                }
                
                
                //CGContextFillRect(context, dateHighlighter);
                
                
                CGFloat outerMargin = 0.0f;
                CGRect outerRect = CGRectInset(dateHighlighterRect, outerMargin, outerMargin);
                CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 15);
                CGContextAddPath(context, outerPath);
                CGContextFillPath(context);
                
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

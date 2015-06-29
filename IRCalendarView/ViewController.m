//
//  ViewController.m
//  IRCalendarView
//
//  Created by Hijazi on 30/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet IRCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lbl_date.text = [IRCalendarHelper stringFromDate:[NSDate date] withDateFormat:@"MMMM yyyy"];
    [self test];
    
    
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *language = [locale displayNameForKey:NSLocaleIdentifier
                                             value:[locale localeIdentifier]];
    
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMMM"];
    locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ms"];
    [outputFormatter setLocale:locale];
    
    NSLog(@"dateFormatter %@",[outputFormatter stringFromDate:[IRCalendarHelper dateWithDay:1 month:1 year:2015]]);
    
    
    
    
    
}

- (void)hello{

    
    
}


- (void)viewWillLayoutSubviews{
    self.calendarView.date = self.datePicker.date;
    [super viewWillLayoutSubviews];
    [self.calendarView setNeedsDisplay];
}

- (void)test{
    
    // monday case
    for (int i = 2010; i <= 2015; i++) {
        
        for (int j = 1; j <= 12; j++) {
            NSDate *now = [IRCalendarHelper dateWithDay:1 month:j year:i];
            
            // Formatter configuration
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
//            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ms"]; // hari 1 adalah isnin
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]; // hari 1 adalah sunday
            [formatter setLocale:locale];
            [formatter setDateFormat:@"dd MM yyyy - MMMM EE c"];


            // Date to string
            
            NSString *prettyDate = [formatter stringFromDate:now];
//            NSLog(@"prettyDate %@", prettyDate);
            
            int day = [[IRCalendarHelper stringFromDate:now withDateFormat:@"dd MMMM "] intValue];
            
            NSLog(@"day %@",prettyDate);
        }
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)today:(id)sender {
}

- (IBAction)segmented_changes:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.calendarView.startWeekOn = DayNameSun;
            break;
        case 1:
            self.calendarView.startWeekOn = DayNameMon;
            break;
        case 2:
            self.calendarView.startWeekOn = DayNameTue;
            break;
        case 3:
            self.calendarView.startWeekOn = DayNameWed;
            break;
        case 4:
            self.calendarView.startWeekOn = DayNameThu;
            break;
        case 5:
            self.calendarView.startWeekOn = DayNameFri;
            break;
        case 6:
            self.calendarView.startWeekOn = DayNameSat;
            break;
            
        default:
            break;
    }
    
   
    
}
- (IBAction)changeDate:(UIDatePicker*)sender {
    
    self.calendarView.date = sender.date;
    
    self.lbl_date.text = [IRCalendarHelper stringFromDate:sender.date withDateFormat:@"MMMM yyyy"];
    
}
- (IBAction)changeStartFromSunday:(UISwitch *)sender {
    if (sender.isOn == YES) {
        self.calendarView.isStartFromSunday = YES;

    }else{
        self.calendarView.isStartFromSunday = NO;

    }
}

@end

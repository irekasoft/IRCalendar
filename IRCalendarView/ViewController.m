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
            NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [formatter setLocale:posix];
            [formatter setDateFormat:@"dd MM yyyy - EE c"];
            [formatter setDateFormat:@"dd MM yyyy - EE c ->"];

            // Date to string
            
            NSString *prettyDate = [formatter stringFromDate:now];
//            NSLog(@"prettyDate %@", prettyDate);
            
            int day = [[IRCalendarHelper stringFromDate:now withDateFormat:@"c"] intValue];
            
            NSLog(@"day %d",day);
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
            self.calendarView.isStartFromSunday = YES;
            break;
        case 1:
             self.calendarView.isStartFromSunday = NO;
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

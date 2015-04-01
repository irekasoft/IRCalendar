//
//  ViewController.m
//  IRCalendarView
//
//  Created by Hijazi on 30/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet IRCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.calendarView.date = [NSDate date];
    [self.calendarView setNeedsDisplay];
    self.calendarView.isStartFromSunday = YES;

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
            
//            NSLog(@"day %d",day);
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
            self.calendarView.startDay = DayNameTue;
            break;
        case 3:
            self.calendarView.startDay = DayNameWed;
            break;
        case 4:
            self.calendarView.startDay = DayNameThu;
            break;
        case 5:
            self.calendarView.startDay = DayNameFri;
            break;
        case 6:
            self.calendarView.startDay = DayNameSat;
            break;
            
        default:
            break;
    }
    
   
    
}
- (IBAction)changeDate:(UIDatePicker*)sender {
    
    self.calendarView.date = sender.date;
    
    self.lbl_date.text = [IRCalendarHelper stringFromDate:sender.date withDateFormat:@"MM yyyy"];
    
}

@end

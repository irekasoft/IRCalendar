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
    self.calendarView.date = [NSDate date];
    
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

@end

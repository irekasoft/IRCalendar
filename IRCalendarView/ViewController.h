//
//  ViewController.h
//  IRCalendarView
//
//  Created by Hijazi on 30/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRCalendarView.h"

@interface ViewController : UIViewController {
    
    BOOL isStartFromSunday;
    
}

@property (weak, nonatomic) IBOutlet UILabel *lbl_date;


@end


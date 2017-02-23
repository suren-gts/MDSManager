//
//  ReminderVC.h
//  MyMDSManager
//
//  Created by CEPL on 04/08/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"
#import "ContentPickerVC.h"

@interface ReminderVC : UIViewController <DatePikerDelegate>
{
    IBOutlet UISwitch *switchReminder;
    IBOutlet UITableView *tblReminderInterval;
    IBOutlet UIButton *btnFrequency;
    IBOutlet UIButton *btnSecheduleDay;
    IBOutlet UIView *viewSwitchBack;
    
    IBOutlet UIButton *btnSoundName;
    IBOutlet UILabel *lblSoundName;
    
    
    NSString *strFrequency;
    NSMutableArray *arrReminders;
    
    DatePickerVC *objDatePicker;
    ContentPickerVC *objPicker;
    BOOL IsActionSheetVisible;
    
    
    NSDateFormatter *dateformater;
    
    int currentDateSectionIndex;
}


@end

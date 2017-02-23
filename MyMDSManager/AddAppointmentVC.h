//
//  AddAppointmentVC.h
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"
#import "AppointementObject.h"
#import "ContentPickerVC.h"
#import <EventKit/EventKit.h>
@interface AddAppointmentVC : UIViewController <DatePikerDelegate,ValuePickerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UITableView *tblView;
    UITextField *txtTemp;
    UITextView *tvTemp;
    DatePickerVC *objDatePicker;
    ContentPickerVC *objPicker;
    BOOL IsActionSheetVisible;
    BOOL IsUp;
    UIToolbar *numberToolbar;
    
    NSInteger SomeEdit;
    
}
@property int editFlag;
@property (nonatomic,retain)AppointementObject *objLocalAppointment;
@end

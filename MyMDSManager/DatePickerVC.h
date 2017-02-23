//
//  DatePickerVC.h
//  MedicalApp
//
//  Created by CEPL on 06/05/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePikerDelegate

@optional
-(void)didSelectDate:(NSDate *)selectedDate;
-(void)didCancelPicker;
@end

@interface DatePickerVC : UIViewController
{
    IBOutlet UIDatePicker *datePicker;
}
//@property (nonatomic,retain)  IBOutlet UIDatePicker *datePicker;
@property (nonatomic,retain)id <DatePikerDelegate> datePickerDel;
@property  NSInteger entryTag;
@end

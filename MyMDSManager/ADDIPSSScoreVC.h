//
//  ADDIPSSScoreVC.h
//  MyMDSManager
//
//  Created by CEPL on 13/10/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"

@interface ADDIPSSScoreVC : UIViewController <UIAlertViewDelegate , UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UITextField *txtDate;
    IBOutlet UITextField *txtScore;
    IBOutlet UITextView *tvNotes;
   
    IBOutlet UIButton *btnDate;
    
    DatePickerVC *objDatePicker;
    UIToolbar* numberToolbar;
    BOOL IsUp;
    
    NSInteger SomeEdit;

    
}
@property int editTag;
@property (nonatomic,retain) NSMutableDictionary *dictLocal;

@end

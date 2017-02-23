//
//  AddNotestVC.h
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"

@interface AddNotestVC : UIViewController <UITextFieldDelegate,UITextViewDelegate,DatePikerDelegate>
{
    IBOutlet UITextField *txtTopic;
    IBOutlet UITextView *tvNotes;
    IBOutlet UITextField *txtDate;
    
    IBOutlet UIButton *btnDate;
    
    DatePickerVC *objDatePicker;
     UIToolbar* numberToolbar;
    BOOL IsUp;
    
    NSInteger SomeEdit;
}
@property int editTag;
@property (nonatomic,retain) NSMutableDictionary *dictLocal;
@end

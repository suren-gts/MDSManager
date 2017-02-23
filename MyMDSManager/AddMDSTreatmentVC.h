//
//  AddMDSTreatmentVC.h
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"
#import "ContentPickerVC.h"


typedef enum _TreatementSectionlist
{
    TreatementSection = 0,
    DateTiemSection = 1,
    NotesSection = 2,
    ButtonSection = 3,
}TreatementSectionlist;

@interface AddMDSTreatmentVC : UIViewController <UITextFieldDelegate,UITextViewDelegate,DatePikerDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UILabel *lblPageTitle;
    IBOutlet UITableView *tblView;
    UITextView *tvTemp;
    
    DatePickerVC *objDatePicker;
    
    NSMutableArray *arrOthers;
    
    UIToolbar* numberToolbar;
    BOOL IsUp;
    BOOL IsActionSheetVisible;
    
    NSInteger dateTag;
    
    NSInteger SomeEdit;
    
    
    NSMutableArray *arrDropDown;

    BOOL isActionSheetVisible;
    ContentPickerVC *objPicker;
}

@property int editFlag;
@property (nonatomic,retain)NSMutableDictionary *dictTreatment;
@end

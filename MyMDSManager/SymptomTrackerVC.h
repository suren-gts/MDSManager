//
//  SymptomTrackerVC.h
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"
#import "ContentPickerVC.h"
#import "SymptomObject.h"

typedef enum  _SymptomTableRows
{
    SymptomCat = 0,
    SymptomSubCat = 1,
    SymptomSeverity = 2,
    SymptomDateNTime = 3,
    SymptomDuration = 4,
    SymptomFrequency = 5,
    SymptomNotes = 6,
    SymptomButton = 7,
    SymptomHistory = 8,
    
}TableRos;

@interface SymptomTrackerVC : UIViewController<ValuePickerDelegate,DatePikerDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UITableView *tblSymptomList;
    BOOL IsUp;
    DatePickerVC *objDatePicker;
    ContentPickerVC *objPicker;
    
    UITextField *txtTemp;
    UITextView *tvTemp;
    
    NSInteger entryTag;
    
    UIToolbar* numberToolbar;
    
    UIView *addSymptomView;
    UITextField *txtsymptom;
    
    NSMutableArray *arrOtherSymptomeList;
    
    IBOutlet UIButton *btnHistory;
    BOOL isActionSheetVisible;
    
    NSInteger SomeEdit;

    
  
}
@property (nonatomic,retain)NSString *strEntrValue;
@property (nonatomic,retain) SymptomObject *objLocalSymptom;
@end

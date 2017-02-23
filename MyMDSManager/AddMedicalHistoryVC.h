//
//  AddMedicalHistoryVC.h
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"
#import "DiagnosisObject.h"
#import "ContentPickerVC.h"

@interface AddMedicalHistoryVC : UIViewController <DatePikerDelegate,ValuePickerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITextField *txtDiagnosis;
    
    IBOutlet UILabel *lblDate;
    
    
    IBOutlet UITextView *txtNotes;
    IBOutlet UIButton *btnDate;
    IBOutlet UILabel *lblDiagnosis;
    
    IBOutlet UITextField *txtProvider;
    IBOutlet UIButton *btnProvider;
    IBOutlet UIButton *btnAddProvider;
    IBOutlet UILabel *lblPageTitle;

    IBOutlet UIButton *btnDiagnosisList;

    UITextField *txtTemp;
    UITextView *tvTemp;
    UIToolbar *numberToolbar;
    
    ContentPickerVC *objPicker;
    
    DatePickerVC *objDatePicker;
    BOOL IsUp;
    
    // OtherView
    UIView *viewOtherValue;
    UITextField *txtOtherValue;
    UITableView *tblOtherList;
    NSMutableArray *arrOtherList;
    
    
    BOOL isEdit;

}
@property NSInteger entryTag;
@property int editFlag;
@property (nonatomic,retain)DiagnosisObject *objDiagnosis;

@end

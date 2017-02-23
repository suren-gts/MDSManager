//
//  AddTreatementMedicinVC.h
//  MyMDSManager
//
//  Created by CEPL on 01/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalObject.h"
#import "ContentPickerVC.h"
#import "DatePickerVC.h"
#import "AddMedicineVC.h"
typedef enum  TreatementType
{
    MedicineCreate = 0,
    MDSTreatment = 1,
    OtherTreatment = 2,
}TreatementType;

@interface AddTreatementMedicinVC : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UITableView *tblView;
    MedicalObject *objLocalMedicine;
    ContentPickerVC *objPicker;
    DatePickerVC *objDatePicker;
    
    
    UITextView *tvTemp;
    UITextField *txtTemp;
    BOOL IsActionSheetVisible;
    AddMedicineVC *objAddMedicine;
    UIToolbar* numberToolbar;
    
    // OtherView
    UIView *viewOtherValue;
    UITextField *txtOtherValue;
    UITableView *tblOtherList;
    NSMutableArray *arrOtherList;
    
    BOOL isEdit;
    
    
}

@property BOOL isShowData;

@property MedicalObject *objMedTemp;
@property int treatmentType;


@end

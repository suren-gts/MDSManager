//
//  AddInitialLabResultVC.h
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentPickerVC.h"
#import "DatePickerVC.h"
#import "LabResultObject.h"
@interface AddInitialLabResultVC : UIViewController<UITextFieldDelegate,ValuePickerDelegate,DatePikerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblPageTitle;
    UITextField *txtTemp;
    UITextView *tvTemp;
    ContentPickerVC *objPicker;
    DatePickerVC *objDatePicker;
    BOOL IsUp;
    BOOL IsActionSheetVisible;
    UIToolbar* numberToolbar;
    

    NSMutableArray *arrFiles;
    NSMutableArray *arrFullSizeImage;
    NSMutableArray *arrImageName;
    UIView *showImageView;
    UIImageView *imgShowMe;
    
    UIImagePickerController *imagePicker;
    
    //Add New Diagnosis
    UIView *viewNewDiagnosis;
    UITextField *txtNewDiagnosis;
    UITextField *txtNewUnit;
    UITextField *txtNormalValueMale;
    UITextField *txtNormalValueFemale;
    
    UITableView *tblCustomDiagnosisList;
    NSMutableArray *arrCustomDiagnosis;
    
    NSInteger SomeEdit;
    
}

@property NSInteger entryTag;
@property int editFlag;
@property (nonatomic,retain)LabResultObject *objLabResult;
@end

//
//  MenuProfileScreenVC.h
//  MyMDSManager
//
//  Created by CEPL on 03/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentPickerVC.h"
#import "DatePickerVC.h"


typedef enum _ProfileSections
{
    About= 0,
    ContactInfo = 1,
    Caregiver = 2,
    Alergies = 3,
    MedicalHistory = 4,
    PInsurance   = 5,
    SInsurance   =6 ,
    
    
} ProfileSections;



@interface MenuProfileScreenVC : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, ValuePickerDelegate, DatePikerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIAlertViewDelegate, UITextViewDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIImageView *imgUser;
    IBOutlet UITextField *txtName;
    IBOutlet UIButton *btnEditUserName;
    IBOutlet UILabel *lblPageTitle;
    
    NSMutableArray *arrInsurance;
    
    NSArray *arrSections;
    
    NSMutableDictionary *dictColleps;
    NSMutableDictionary *dictEditAction;
    UIButton *btnImageTag;
    
    
    UIToolbar* numberToolbar;
    UITextField *txtTemp;
    UITextView *tvTemp;
    ContentPickerVC *objPicker;
    DatePickerVC *objDatePicker;
    
    NSMutableArray *arrAlergies;
    NSMutableArray *arrCareGivers;
    
    UITextView *tvShowNotes;
    
    //View for Caregiver
    int viewTagForAlergyNCaregiver;
    IBOutlet UILabel *lblCaregiverNAlergyTitle;
    IBOutlet UIView *viewForCaregiverNAlergy;
    IBOutlet UITextField *txtCaregiverOrAlergyName;
    IBOutlet UITextField *txtRelation;
    IBOutlet UITextField *txtContactNo;
    IBOutlet UITextField *txtEmail;
    
    
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnDelete;
    
    IBOutlet UIButton *btnTakeUserPic;

    
    //View for Alergies
    IBOutlet UITextView *tvAlergyNotes;
    IBOutlet UIImageView *imgNotestBack;

    BOOL isEditingStateForCaregiverNAlergy;
    NSString *edtingIndexForCaregiverNAlergy;
    
    BOOL IsUp;
    BOOL IsActionSheetVisible;
    
    // OtherView
    UIView *viewOtherValue;
    UITextField *txtOtherValue;
    UITableView *tblOtherList;
    NSMutableArray *arrOtherList;
    
    UIImagePickerController *imagePicker;
    
    
    NSMutableDictionary *dicUserInfo;
    
    NSInteger SomeEdit;
    NSInteger SomeEditCaregiverOrAlergy;   // 0 for no change , 1 some unsaved changes .

    
}

@end

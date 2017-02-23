//
//  AddBloodCountVC.h
//  MyMDSManager
//
//  Created by CEPL on 20/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"
#import "ContentPickerVC.h"

#define TableSectionCount 5;
typedef enum _TableSections
{
    BloodType = 0,
    BloodCounts = 1,
    LabTest = 2,
    Notes = 3,
    Button = 4,
    
    
}TableSections;

@interface AddBloodCountVC : UIViewController<UITextFieldDelegate,DatePikerDelegate,UITextViewDelegate,ValuePickerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblPageTitle;
    
    UITextField *txtTemp;
    UITextView *tvTemp;
    DatePickerVC *objDatePicker;
    BOOL IsUp;
    
    BOOL IsActionSheetVisible;
    
    UIToolbar* numberToolbar;
    
    NSMutableArray *arrLabResult;
    
    IBOutlet UIView *viewLabResult;
    IBOutlet UITextField *txtTest;
    IBOutlet UITextField *txtTestValue;
    
   ContentPickerVC *objPicker;
    
    NSMutableArray *arrFiles;
    NSMutableArray *arrFullSizeImage;
    NSMutableArray *arrImageName;
    
    UIView *showImageView;
    UIImageView *imgShowMe;
    
    UIImagePickerController *imagePicker;
    
    NSInteger SomeEdit;
    
}

@property NSInteger entryTag;
@property int editFlag;
@property (nonatomic,retain)NSMutableDictionary *dictBloodCount;

@end

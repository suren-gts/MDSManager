//
//  AddMedicineVC.h
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentPickerVC.h"
#import "DatePickerVC.h"
#import "MedicalObject.h"


@protocol NewMedicineUpdateDelegate

@optional
-(void)newMedicineAdd;
-(void)addManagingProvider;

@end

typedef enum _TableRows
{
    Type        =   0,
    DrugName	=   1,
    GenericName =   2,
    Dosage		=   3,
    Frequency	=   4,
    StartDate 	=   5,
    EndDate     =   6,
    Reminder 	=   7,
    RefillDate	=   8,
    RefillFrq   =   9,
    PrescribeBy	=   10,
    AddNote		=   11,
    
} TableRows;

@interface AddMedicineVC : UIViewController<UITextFieldDelegate, ValuePickerDelegate, DatePikerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIImageView *imgMedicine;
    IBOutlet UILabel *lblTakePic;
    IBOutlet UIButton *btnEditOrSave;
  
    UIToolbar* numberToolbar;
    UITextField *txtTemp;
    UITextView *tvTemp;
    ContentPickerVC *objPicker;
    DatePickerVC *objDatePicker;
    MedicalObject *objLocalMedical;
    BOOL IsUp;
    NSInteger datePicTag;//Variable for making choise for start date, enddate
    BOOL IsActionSheetVisible;
    BOOL isNotApplicable;
    
    NSDateFormatter *dateformater;
     UIImagePickerController *imagePicker;
    
    
}
@property (nonatomic,retain) MedicalObject *objLocalMedical;
@property (nonatomic,retain) NSString *strActionValue;  //ActionValue for Edit Or Insert;
@property (nonatomic,retain)id <NewMedicineUpdateDelegate> medicineUpdateDelegte;
@end

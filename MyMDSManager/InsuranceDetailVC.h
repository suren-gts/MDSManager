//
//  InsuranceDetailVC.h
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentPickerVC.h"
typedef enum _InsuranceRows
{
    IImage=0,
    IOption=1,
    IName=2,
    IPhoneNumber=3,
    IEmployer=4,
    IGroup=5,
    IPrescription=6,
    IAddress=7,
    ICity=8,
    IState=9,
    IZipcode=10,
    
}InsuranceRows;

@interface InsuranceDetailVC : UIViewController <ValuePickerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *tblView;
    NSMutableDictionary *dictColleps;
    NSMutableDictionary *dictEditAction;
    NSMutableArray *arrInsurance;
    UIButton *btnImageTag;
    
    
    UIToolbar* numberToolbar;
    UITextField *txtTemp;
    BOOL IsUp;
    ContentPickerVC *objPicker;
    BOOL IsActionSheetVisible;
    
    UIImagePickerController *imagePicker;
    
    NSInteger SomeEdit;
}
@end

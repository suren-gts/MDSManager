//
//  AddMediaProfessionalVC.h
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContentPickerVC.h"

#import "RMPhoneFormat.h"

@interface AddMediaProfessionalVC : UIViewController <UITextFieldDelegate,UITextViewDelegate,ValuePickerDelegate>
{

    IBOutlet UILabel *lblPageTitle;
    IBOutlet UIButton *btnSave;
    IBOutlet UITextField *txtProviderName;
    IBOutlet UITextField *txtProviderSpeciality;
    IBOutlet UITextField *txtReferredBy;
    IBOutlet UITextView *txtAddress;
    IBOutlet UITextField *txtPhone;
    IBOutlet UITextField *txtFax;
    IBOutlet UITextField *txtEmail;
    
    IBOutlet UIButton *btnCountryCode;
    
   
    UITextField *txtTemp;
    UIToolbar *numberToolbar;
    BOOL IsUp;
    
    BOOL isActionSheetVisible;
    ContentPickerVC *objPicker;
    
    NSInteger SomeEdit;
}
@property int editTag;
@property (nonatomic,retain) NSMutableDictionary *dictLocal;
@end

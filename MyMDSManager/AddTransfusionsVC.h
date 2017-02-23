//
//  AddTransfusionsVC.h
//  MyMDSManager
//
//  Created by CEPL on 14/01/16.
//  Copyright (c) 2016 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"
#import "ContentPickerVC.h"


@interface AddTransfusionsVC : UIViewController <DatePikerDelegate,ValuePickerDelegate,UIActionSheetDelegate>
{
    IBOutlet UILabel *lblPageTitle;
    IBOutlet UIButton *btnDate;
    IBOutlet UITextField *txtTransfusiontype;
    IBOutlet UITextField *txtUnit;
    IBOutlet UIButton *btnTransfusion;
    
    UITextField *txtTemp;
    
    UIToolbar *numberToolbar;
    
    ContentPickerVC *objPicker;
    
    DatePickerVC *objDatePicker;
    BOOL IsUp;
    
    NSDate *dateTorder;
    
    double DateInDouble;
    
    NSInteger SomeEdit;
    
    IBOutlet UIButton *btnBloodtype;
    
    
}

@property int editFlag;
@property (nonatomic,retain) NSMutableDictionary *dictLocalValue;

@end

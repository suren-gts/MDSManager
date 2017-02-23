//
//  AddClinicalTrialVC.h
//  MyMDSManager
//
//  Created by Chanchal on 25/03/16.
//  Copyright © 2016 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalObject.h"


@interface AddClinicalTrialVC : UIViewController <UIAlertViewDelegate , UITextFieldDelegate>
{
    
    MedicalObject *objMedicine;
    
    IBOutlet UITextField *txtTrialNo;

    IBOutlet UITextField *txtNameOfTrial;
    IBOutlet UITextField *txtLocation;
    IBOutlet UIButton *btnSave;
    
    UIToolbar* numberToolbar;
    
    BOOL isEdit;
}

@property BOOL isShow;
@property MedicalObject *objMedTemp;


-(IBAction)clickOnSave:(UIButton *)sender;
-(IBAction)clickBack:(UIButton *)sender;



@end

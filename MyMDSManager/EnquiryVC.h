//
//  EnquiryVC.h
//  MyMDSManager
//
//  Created by CEPL on 03/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnquiryVC : UIViewController
{
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIButton *btnSubmit;
    
    IBOutlet UITextField *tfName;
    
    IBOutlet UITextField *tfPhone;
    IBOutlet UITextField *tfEmail;
    
    
    IBOutlet UITextView *tvComment;
    
    IBOutlet UIButton *btnApplySecond;
    
    IBOutlet UIButton *btnPatient;
    IBOutlet UIButton *btnFamily;
    IBOutlet UIButton *btnFriend;
    IBOutlet UIButton *btnCaregiver;
    
    NSDictionary *dictResult;
    
}
- (IBAction)didSelectBack:(UIButton *)sender;
- (IBAction)didSelectSubmitForm:(UIButton *)sender;
- (IBAction)didSelectIAm:(UIButton *)sender;


@end

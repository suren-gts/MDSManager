//
//  SettingsScreenVC.h
//  MyMDSManager
//
//  Created by CEPL on 01/08/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
//For G+

@class GIDSignInButton;


#import <MessageUI/MessageUI.h>

@interface SettingsScreenVC : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UISwitch *switchPushNotification;
    IBOutlet UISwitch *switchCalendarNotification;
    IBOutlet UIButton *btnGoogleLogin;
    IBOutlet UILabel *lblLoginState;
   
    
    NSString *csv;
    
    NSString *NumOfDownloadNeeded;
    
}
- (IBAction)changePushNotificationState:(UISwitch *)sender;
- (IBAction)changeCalendarNotification:(UISwitch *)sender;


- (IBAction)btnCSVExport:(id)sender;
@end

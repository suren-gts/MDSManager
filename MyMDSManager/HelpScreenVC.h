//
//  HelpScreenVC.h
//  MyMDSManager
//
//  Created by CEPL on 28/08/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <MessageUI/MessageUI.h>

@interface HelpScreenVC : UIViewController< MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UIScrollView *scrollView;
 
    
    IBOutlet UILabel * lblAddress;
    
    IBOutlet UIButton *btnPhoneInUS;
    IBOutlet UIButton *btnPhoneOutUS;
    IBOutlet UIButton *btnEmail;
    IBOutlet UIButton *btnFax;
    
    IBOutlet UIWebView *webContact;
    
    
    NSURLRequest  *requestedPath;
    NSArray *arrRequest;
}
- (IBAction)didSelectPhoneOutUS:(UIButton *)sender;
- (IBAction)didSelectMail:(UIButton *)sender;
- (IBAction)didSelectPhoneInUS:(UIButton *)sender;

@end

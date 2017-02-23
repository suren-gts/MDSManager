//
//  MediaProfessionalListVC.h
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface MediaProfessionalListVC : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrMediaProffetional;
    MFMailComposeViewController *mailComposer;
    IBOutlet UIButton *btnAddMD;
}
@end

    

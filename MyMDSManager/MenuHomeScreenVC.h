//
//  MenuHomeScreenVC.h
//  MyMDSManager
//
//  Created by CEPL on 03/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuHomeScreenVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UITableView *tblView;
    NSMutableArray *arrContent;
    NSMutableArray *arrImages;
    
    NSArray *arrSubMenu;
 
    //First Time Google Account
    UIView *viewFirstTimeGoogle;
    
    NSString *NumOfDownloadNeeded;
    
    
    IBOutlet UILabel *lblTitle;

    
}

@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;
@end

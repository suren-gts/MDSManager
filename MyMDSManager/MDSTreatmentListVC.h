//
//  MDSTreatmentListVC.h
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSTreatmentListVC : UIViewController
{
    IBOutlet UITableView *tblView;
    UITextView *tvShowNotes;
    NSMutableArray *arrTreatments;
    IBOutlet UIButton *btnAddTreatment;
    
    
}
@end

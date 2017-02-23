//
//  NotesListVC.h
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesListVC : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrNotes;
    UITextView *tvShowNotes;
    IBOutlet UIButton *btnAddNotes;
}

@end;
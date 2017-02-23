//
//  AddReminderVC.h
//  MyMDSManager
//
//  Created by CEPL on 04/08/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddReminderVC : UIViewController
{
    IBOutlet UITableView *tblView;
    NSArray *arrTableContent;;
    NSDateFormatter *formatter;
    NSArray *arrCount1;
    NSArray *arrCount2;
    
    //
    NSMutableDictionary *dictSchedule;
    NSMutableArray *arrSechdeul;
    
}
@property int entryTag;
@property NSIndexPath *lastSelected;;
@end

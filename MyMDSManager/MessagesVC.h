//
//  MessagesVC.h
//  MyMDSManager
//
//  Created by CEPL on 03/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesVC : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrTableContent;
    NSDateFormatter *dateFormater;
}
@end

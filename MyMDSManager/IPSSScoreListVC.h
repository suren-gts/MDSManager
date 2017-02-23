//
//  IPSSScoreListVC.h
//  MyMDSManager
//
//  Created by CEPL on 13/10/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPSSScoreListVC : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrrTableContent;
    
    IBOutlet UIButton * btnAddIPSSScore;
    
}
@end

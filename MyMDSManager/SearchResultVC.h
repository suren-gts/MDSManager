//
//  SearchResultVC.h
//  MyMDSManager
//
//  Created by CEPL on 26/08/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultVC : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrSearchContent;
    
    //Code
    NSArray *arrSearchFilter;
    IBOutlet UIView *viewSearchFilter;
    IBOutlet UILabel *lblSearchFilter;
    
    IBOutlet UITextField *txtSearchField;
    
    BOOL IsUp;
    int selectedSearchFilter;
    
    IBOutlet UIButton *btnFilter1;
    IBOutlet UIButton *btnFilter2;
    IBOutlet UIButton *btnFilter3;
    IBOutlet UIButton *btnFilter4;
}
@property NSInteger filterTag;
@property (nonatomic,retain)NSString *strFilter;
@end

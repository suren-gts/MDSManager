//
//  InicialLabResultVC.h
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileHeaderCell.h"

typedef enum _InitialLabResultSection
{
    BloodCount=0,

}InitialLabResultSection;

@interface InicialLabResultVC : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableDictionary *dictColleps;
    NSMutableArray *arrBloodCellsTest;
    IBOutlet UILabel *lblPageTitle;
    IBOutlet UIButton *btnAddInitial;
}

@property (nonatomic,retain)NSString *strEntryFlag;
// for InicialLab Results Or Ongoing LabResults;

@end

//
//  SymptomListVC.h
//  MyMDSManager
//
//  Created by CEPL on 28/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentPickerVC.h"


#import "SHLineGraphView.h"
#import "SHPlot.h"


@interface SymptomListVC : UIViewController <  ValuePickerDelegate>
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrSympotms;
    
    NSMutableArray *arrChartDropDownsymptom;
    NSMutableArray *arrChartSymptom;
    IBOutlet UIButton *btnSymtomDropDownList;
      
    ContentPickerVC *objPicker;
    IBOutlet UIButton *btnList;
    IBOutlet UIButton *btnChart;
    IBOutlet UIButton *btnAddSymptom;

    BOOL isActionSheetVisible;
    
    
    SHLineGraphView * lineGraph;
    

}

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;


- (IBAction)refresh:(id)sender;




@end

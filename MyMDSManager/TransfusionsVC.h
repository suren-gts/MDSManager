//
//  TransfusionsVC.h
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentPickerVC.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"

@interface TransfusionsVC : UIViewController < ValuePickerDelegate>
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrBloodcounts;
    NSMutableArray *arrChartBloodCountData;
    NSMutableArray *arrChartDropDownBloodCount;
    
    
    ContentPickerVC *objPicker;
    BOOL isActionSheetVisible;
    IBOutlet UIButton *btnList;
    IBOutlet UIButton *btnChart;
    IBOutlet UIButton *btnBloodCounts;
    
    NSString *strSelectBlood;
    
    IBOutlet UIButton *btnAddTransfusion;
    

       SHLineGraphView * lineGraph;
    
    
}

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@end

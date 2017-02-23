//
//  MedicalHistoryScreenVC.h
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum _MedicalHistorySection
{
    DiagnosisHistory=0,
    SurgicalHistory=1,
}MedicalHistorySection;

@interface MedicalHistoryScreenVC : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableDictionary *dictColleps;
    NSMutableArray *arrDiagnosisHistory;
    NSMutableArray *arrSurgicalHistory;
    
    UITextView *tvShowNotes;
}

@end

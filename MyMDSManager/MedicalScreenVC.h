//
//  MedicalScreenVC.h
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMedicineVC.h"
typedef enum _MedicalSection
{
    CurrentMedicine=0,
    PreviousMedicine=1,
}MedicalSection;

@interface MedicalScreenVC : UIViewController <NewMedicineUpdateDelegate>
{
     IBOutlet UITableView *tblView;
    NSMutableArray *arrCurrentMedicine;
    NSMutableArray *arrPreviousMedicine;
    NSArray *arrMedicinType;
   
    int currentlySelctecdTab;
    AddMedicineVC *objAddMedicine;
    
    IBOutlet UIButton *btnAddMedication;
}
@end



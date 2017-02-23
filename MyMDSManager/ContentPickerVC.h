//
//  ContentPickerVC.h
//  MyMDSManager
//
//  Created by CEPL on 04/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicePlayerClass.h"
@protocol ValuePickerDelegate
@optional

-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue;
-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger)section andForRow:(NSInteger)row;
-(void)didCancelPicker;
@end

typedef enum _EntryTagForView
{
    ProfileScreen= 0,
    InitialLabResult= 1,
    SymptomTracker = 2,
    AddMedicine = 3,
    Insurance=4,
    AddBoneMerrow=5,
    ManagingProvider=6,
    AddTreatmentMedicine=7,
    ReminderSound=8,
    Transfusion = 9,
    MedicalHistoryDiagnosis = 10,
    TreatmentServerList = 11,
    SymptomListTag = 12,
    CountryPhoneCode = 14,
    BloodCountTag = 15,
    TransfusionTag = 16,
    AddTreatment   = 17,
    Suregery = 18,
} EntryTagForView;


@interface ContentPickerVC : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *arrPikerContent;
    NSMutableArray *arrPikerContent2;
    NSInteger selectedRowForComonent1;
    NSInteger selectedRowForComonent2;
    
    MusicePlayerClass *mymusicPlayer;
    
    
}
@property NSInteger rowId;
@property NSInteger sectionId;
@property NSInteger EntryTag;
@property (nonatomic,retain)NSArray *arrPikerContent;
@property (nonatomic,retain)id <ValuePickerDelegate> valueDelegate;
@end


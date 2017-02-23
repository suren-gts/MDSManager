//
//  MedicalObject.h
//  MyMDSManager
//
//  Created by CEPL on 07/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicalObject : NSObject

@property (nonatomic,retain)NSString *strId;
@property (nonatomic,retain)NSString *strDrugName;
@property (nonatomic,retain)NSString *strGenericName;
@property (nonatomic,retain)NSString *strDosage;
@property (nonatomic,retain)NSString *strType;
@property (nonatomic,retain)NSString *strFrequency;
@property (nonatomic,retain)NSString *strStartDate;
@property (nonatomic,retain)NSString *strEndDate;
@property (nonatomic,retain)NSString *strRefillDate;
@property (nonatomic,retain)NSString *strRefillFrequency;
@property (nonatomic,retain)NSString *strPrescribedBy;
@property (nonatomic,retain)NSString *strNotes;


@property (nonatomic,retain)NSDate *startDate;
@property (nonatomic,retain)NSDate *endDate;

@property (nonatomic,retain)NSString *strImageName;

@property (nonatomic,retain)NSString *strReminder;
@property (nonatomic,retain)NSString *strRFrequencyTitle;
@property (nonatomic,retain)NSString *strReminderCounts;
@property (nonatomic,retain)NSDate *reminderStartTime;
@property (nonatomic,retain)NSString *strScheduleDays;

@property (nonatomic,retain)NSString *strReminderSoundName;
@property (nonatomic,retain)NSString *strRemdinerSoundIndex;


//Chanchal Newely added
// Clinincal Trial
@property (nonatomic,retain) NSString *strTrialNumber;
@property (nonatomic,retain) NSString *strNameOfTrial;
@property (nonatomic,retain) NSString *strLocation;

@property (nonnull,retain) NSString *strOtherTreatmentName;

-(id) initDefaults;

@end

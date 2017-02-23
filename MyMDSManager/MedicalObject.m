//
//  MedicalObject.m
//  MyMDSManager
//
//  Created by CEPL on 07/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "MedicalObject.h"

@implementation MedicalObject
@synthesize strId,strDrugName,strGenericName,strDosage,strType,strFrequency,strStartDate,strEndDate,strReminder,strRefillDate,strPrescribedBy,strNotes,strImageName,startDate,endDate,strRefillFrequency;
@synthesize strReminderCounts,strRFrequencyTitle,reminderStartTime,strScheduleDays,strRemdinerSoundIndex,strReminderSoundName,strOtherTreatmentName;

//Chanchal
@synthesize strLocation,strNameOfTrial,strTrialNumber;

-(id) initDefaults
{
    self = [super init];
    if (self)
    {
        self.strId=@"";
        self.strDrugName=@"";
        self.strGenericName=@"";
        self.strDosage=@"";
        self.strNotes=@"";
        self.strType=@"";
        self.strFrequency=@"";
        self.strStartDate=@"";
        self.strEndDate=@"";
        self.strReminder=@"";
        self.strRefillDate=@"";
        self.strPrescribedBy=@"";
        self.strImageName=@"";
        self.strRefillFrequency=@"";
        
        self.strRFrequencyTitle=@"";
        self.strReminderCounts=@"";
        self.strScheduleDays=@"";
        
        self.strReminderSoundName=@"";
        self.strRemdinerSoundIndex=@"";
        
        self.strTrialNumber = @"";
        self.strLocation = @"";
        self.strNameOfTrial = @"";
        
        self.strOtherTreatmentName = @"";
        
    }
    return(self);
}

@end

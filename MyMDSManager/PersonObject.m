//
//  PersonObject.m
//  MyMDSManager
//
//  Created by CEPL on 04/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "PersonObject.h"

@implementation PersonObject

@synthesize strId,strName,strFirstName,strMiddleName,strGender,strAge,strDOB,strHeight,strWeight,strEmailId,strBloodGroup,strLivingWith,strMaritalStatus,strSSN;

@synthesize strAddress1,strAddress2,strAddress3,strCity,strState,strZipcode,strContactNoHome,strContactNoCell,strContactNoWork;

@synthesize strMedicineAllergies,strFoodAllergies,strOtherAllergies;

@synthesize arrCaregivers,arrDrugs;

-(id) initDefaults
{
    self = [super init];
    if (self)
    {
        self.strId=@"";
        self.strName=@"";
        self.strFirstName=@"";
        self.strMiddleName=@"";
        self.strMiddleName=@"";
        
        self.strGender=@"Male";
        self.strAge=@"";
        self.strDOB=@"";
        self.strEmailId=@"";
        self.strBloodGroup=@"";
        self.strHeight=@"";
        self.strWeight=@"";
        
        self.strAddress1=@"";
        self.strAddress2=@"";
        self.strAddress3=@"";
        self.strCity=@"";
        self.strState=@"";
        self.strZipcode=@"";
       
        self.strContactNoHome=@"";
        self.strContactNoCell=@"";
        self.strContactNoWork=@"";
        
        self.strCountryCodeCell = @"";
        self.strCountryCodeHome = @"";
        self.strCountryCodeWork = @"";
        
        
        self.strMedicineAllergies=@"+1";
        self.strFoodAllergies=@"+1";
        self.strOtherAllergies=@"+1";
        
        
        
        self.arrCaregivers=[[NSMutableArray alloc]init];
        self.arrDrugs=[[NSMutableArray alloc]init];
    }
    
    return(self);
}
/*
-(void)parseDataWithValues:(NSDictionary *)dict
{
    if ([dict valueForKey:@"patient_id"])
    {
        self.strId=[dict valueForKey:@"patient_id"];
    }
    if ([dict valueForKey:@"name"])
    {
        self.strName=[dict valueForKey:@"name"];
    }
    if ([dict valueForKey:@"appoitment_id"])
    {
        self.strScheduleId=[dict valueForKey:@"appoitment_id"];
    }
    
    if ([dict valueForKey:@"time"])
    {
        
        [dateFormatter setDateFormat:@"MM-dd-YYYY"];
        NSString *strDate=[NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:[NSDate date]],[dict valueForKey:@"time"]];
        
        NSTimeZone* gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"CST"];
        //        NSTimeZone* localTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"IST"];
        NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
        
        NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
        [gmtDateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:"];
        [gmtDateFormatter setTimeZone:gmtTimeZone];
        
        NSDate *date = [gmtDateFormatter dateFromString:strDate];
        
        NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
        [localDateFormatter setTimeZone:localTimeZone];
        [localDateFormatter setDateFormat:@"hh:mm a"];
        
        self.strScheduleTime=[NSString stringWithFormat:@"%@",[localDateFormatter stringFromDate:date]];
        
    }
    if ([dict valueForKey:@"age"])
    {
        self.strAge=[dict valueForKey:@"age"];
    }
    if ([dict valueForKey:@"blood_group"])
    {
        self.strBloodGroup=[dict valueForKey:@"blood_group"];
    }
    
    if ([dict valueForKey:@"primary_contact"])
    {
        self.strPrimaryContactNo=[dict valueForKey:@"primary_contact"];
    }
    if ([dict valueForKey:@"primary_email"])
    {
        self.strEmailId=[dict valueForKey:@"primary_email"];
    }
    if ([dict valueForKey:@"gender"])
    {
        self.strGender=[dict valueForKey:@"gender"];
    }
    if ([dict valueForKey:@"first_name"])
    {
        self.strFirstName=[dict valueForKey:@"first_name"];
    }
    if ([dict valueForKey:@"middle_name"])
    {
        self.strMiddleName=[dict valueForKey:@"middle_name"];
    }
    if ([dict valueForKey:@"last_name"])
    {
        self.strLastName=[dict valueForKey:@"last_name"];
    }
    if ([dict valueForKey:@"primary_address"])
    {
        self.strPrimaryAddress=[dict valueForKey:@"primary_address"];
    }
    if ([dict valueForKey:@"primary_city"])
    {
        self.strPrimaryCity=[dict valueForKey:@"primary_city"];
    }
    if ([dict valueForKey:@"primary_state"])
    {
        self.strPrimaryState=[dict valueForKey:@"primary_state"];
    }
    if ([dict valueForKey:@"primary_zipcode"])
    {
        self.strPrimaryZipcode=[dict valueForKey:@"primary_zipcode"];
    }
    if ([dict valueForKey:@"secondary_address"])
    {
        self.strSecondaryAddress=[dict valueForKey:@"secondary_address"];
    }
    if ([dict valueForKey:@"secondary_city"])
    {
        self.strSecondaryCity=[dict valueForKey:@"secondary_city"];
    }
    if ([dict valueForKey:@"secondary_state"])
    {
        self.strSecondaryState=[dict valueForKey:@"secondary_state"];
    }
    if ([dict valueForKey:@"secondary_zipcode"])
    {
        self.strSecondaryZipcode=[dict valueForKey:@"secondary_zipcode"];
    }
    if ([dict valueForKey:@"secondary_contact"])
    {
        self.strSecondaryContactNo=[dict valueForKey:@"secondary_contact"];
    }
    
    
    if ([dict valueForKey:@"helathcare_address"])
    {
        self.strHealthcareFax=@"44-208-1234567";//[dict valueForKey:@"helathcare_address"];
    }
    if ([dict valueForKey:@"helathcare_email"])
    {
        self.strHealthcareEmailId=[dict valueForKey:@"helathcare_email"];
    }
    if ([dict valueForKey:@"healthcare_contact"])
    {
        self.strHealthcareContactNo=[dict valueForKey:@"healthcare_contact"];
    }
    
    
    if ([[dict valueForKey:@"medicine"] isKindOfClass:[NSArray class]])
    {
        self.arrMedicine=[dict valueForKey:@"medicine"];
    }
    if ([[dict valueForKey:@"problems"] isKindOfClass:[NSArray class]])
    {
        self.arrProblems=[dict valueForKey:@"problems"];
    }
    if ([[dict valueForKey:@"image"] isKindOfClass:[NSArray class]])
    {
        // self.arrImages=[dict valueForKey:@"image"];
        NSArray *arr=[dict valueForKey:@"image"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dictNotes=[arr objectAtIndex:i];
            ImageObject *objNotes=[[ImageObject alloc]initDefaults];
            [objNotes parseDataWithValues:dictNotes];
            [self.arrImages addObject:objNotes];
        }
        
    }
    if ([[dict valueForKey:@"notes"] isKindOfClass:[NSArray class]])
    {
        NSArray *arr=[dict valueForKey:@"notes"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dictNotes=[arr objectAtIndex:i];
            NotesObject *objNotes=[[NotesObject alloc]initDefaults];
            [objNotes parseDataWithValues:dictNotes];
            [self.arrNotes addObject:objNotes];
        }
    }
    if ([[dict valueForKey:@"vitals"] isKindOfClass:[NSArray class]])
    {
        NSArray *arr=[dict valueForKey:@"vitals"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dictVital=[arr objectAtIndex:i];
            VitalsObject *objVital=[[VitalsObject alloc]initDefaults];
            [objVital parseDataWithValues:dictVital];
            [self.arrVitals addObject:objVital];
        }
        
    }
    if ([[dict valueForKey:@"reports"] isKindOfClass:[NSArray class]])
    {
        NSArray *arr=[dict valueForKey:@"reports"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dictVital=[arr objectAtIndex:i];
            LabResultObject *objVital=[[LabResultObject alloc]initDefaults];
            [objVital parseDataWithValues:dictVital];
            [self.arrLabReports addObject:objVital];
        }
    }
    
    
}
 */
@end


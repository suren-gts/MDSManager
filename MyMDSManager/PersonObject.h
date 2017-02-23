//
//  PersonObject.h
//  MyMDSManager
//
//  Created by CEPL on 04/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonObject : NSObject
{
    
}
@property (nonatomic,retain)NSString *strId;
@property (nonatomic,retain)NSString *strName;
@property (nonatomic,retain)NSString *strFirstName;
@property (nonatomic,retain)NSString *strMiddleName;
@property (nonatomic,retain)NSString *strLastName;
@property (nonatomic,retain)NSString *strGender;
@property (nonatomic,retain)NSString *strAge;
@property (nonatomic,retain)NSString *strDOB;
@property (nonatomic,retain)NSString *strHeight;
@property (nonatomic,retain)NSString *strWeight;
@property (nonatomic,retain)NSString *strMaritalStatus;
@property (nonatomic,retain)NSString *strLivingWith;
@property (nonatomic,retain)NSString *strBloodGroup;
@property (nonatomic,retain)NSString *strSSN;

@property (nonatomic,retain)NSString *strEmailId;
@property (nonatomic,retain)NSString *strAddress1;
@property (nonatomic,retain)NSString *strAddress2;
@property (nonatomic,retain)NSString *strAddress3;
@property (nonatomic,retain)NSString *strCity;
@property (nonatomic,retain)NSString *strState;
@property (nonatomic,retain)NSString *strZipcode;

@property (nonatomic,retain)NSString *strContactNoHome;
@property (nonatomic,retain)NSString *strContactNoCell;
@property (nonatomic,retain)NSString *strContactNoWork;

@property (nonatomic,retain)NSString *strCountryCodeHome;
@property (nonatomic,retain)NSString *strCountryCodeWork;
@property (nonatomic,retain)NSString *strCountryCodeCell;


@property (nonatomic,retain)NSString *strMedicineAllergies;
@property (nonatomic,retain)NSString *strFoodAllergies;
@property (nonatomic,retain)NSString *strOtherAllergies;

@property (nonatomic,retain)NSMutableArray *arrDrugs;

@property (nonatomic,retain)NSMutableArray *arrCaregivers;




-(id) initDefaults;
@end

//
//  InsuranceCompanyObject.h
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceCompanyObject : NSObject

@property (nonatomic,retain)NSString *strId;
@property (nonatomic,retain)UIImage *imgCompany;
@property (nonatomic,retain)NSString *strImageName;
@property (nonatomic,retain)NSString *strCopanyName;
@property (nonatomic,retain)NSString *strOptions;
@property (nonatomic,retain)NSString *strPhoneNumber;
@property (nonatomic,retain)NSString *strEmployer;
@property (nonatomic,retain)NSString *strGroup;
@property (nonatomic,retain)NSString *strPrescription;
@property (nonatomic,retain)NSString *strAddress;
@property (nonatomic,retain)NSString *strCity;
@property (nonatomic,retain)NSString *strState;
@property (nonatomic,retain)NSString *strZipCode;
@property (nonatomic,retain)NSString *strCompanyType;

-(id) initDefaults;
@end

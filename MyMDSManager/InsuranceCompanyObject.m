//
//  InsuranceCompanyObject.m
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "InsuranceCompanyObject.h"

@implementation InsuranceCompanyObject

@synthesize strId,strCopanyName,strOptions,strPhoneNumber,strEmployer,strGroup,strPrescription,strAddress,strCity,strState,strZipCode,strCompanyType,strImageName,imgCompany;

-(id) initDefaults
{
    self = [super init];
    if (self)
    {
        self.strId=@"";
        self.imgCompany=nil;
        self.strImageName=@"";
        self.strCopanyName=@"";
        self.strOptions=@"";
        self.strPhoneNumber=@"";
        self.strEmployer=@"";
        self.strGroup=@"";
        self.strPrescription=@"";
        self.strAddress=@"";
        self.strCity=@"";
        self.strState=@"";
        self.strZipCode=@"";
        self.strCompanyType=@"";
    }
    
    return(self);
}

@end

//
//  LabResultObject.m
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "LabResultObject.h"

@implementation LabResultObject
@synthesize strId,strDiagnosisTest,strDate,strManagingProvider,strNotes,strResult,strUnits,strLabImages;

-(id) initDefaults
{
    self = [super init];
    if (self)
    {
        self.strId=@"";
        self.strDiagnosisTest=@"";
        self.strDate=@"";
        self.strManagingProvider=@"";
        self.strNotes=@"";
        self.strUnits=@"";
        self.strResult=@"";
        self.strLabImages=@"";
    }
    
    return(self);
}

@end

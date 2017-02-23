//
//  DiagnosisObject.m
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "DiagnosisObject.h"

@implementation DiagnosisObject

@synthesize strId,strDiagnosis,strDate,strManagingProvider,strNotes;

-(id) initDefaults
{
    self = [super init];
    if (self)
    {
        self.strId=@"";
        self.strDiagnosis=@"";
        self.strDate=@"";
        self.strManagingProvider=@"";
        self.strNotes=@"";
        
    }
    return(self);
}

@end

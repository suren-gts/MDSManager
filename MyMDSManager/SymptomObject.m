//
//  SymptomObject.m
//  MyMDSManager
//
//  Created by CEPL on 17/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "SymptomObject.h"

@implementation SymptomObject
@synthesize strId,strSymptom,strServirty,strDate,strTime,dateValue,timeValue,strDuration,strFrequency,strNotes;

-(id) initDefaults
{
    self = [super init];
    if (self)
    {

        self.strId=@"";
        self.strSymptom=@"";
        self.strSymptomSubCat=@"";
        self.strServirty=@"5";
        self.strDate=@"";
        self.strTime=@"";
        self.strDuration=@"";
        self.strFrequency=@"";
        self.strNotes=@"";
        self.strSymptomSubCat=@"";
    }
    
    return(self);
}

@end

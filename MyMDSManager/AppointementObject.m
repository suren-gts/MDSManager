//
//  AppointementObject.m
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "AppointementObject.h"

@implementation AppointementObject
@synthesize strId,strDateTime,strNotes,strProvider,dateValue,strEventIdentifier;


-(id) initDefaults
{
    self = [super init];
    if (self)
    {
        self.strId=@"";
        self.strProvider=@"";
        self.strDateTime=@"";
        self.strNotes=@"";
        self.strEventIdentifier=@"";
    }
    
    return(self);
}

@end

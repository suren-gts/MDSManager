//
//  AppointementObject.h
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointementObject : NSObject

@property (nonatomic,retain)NSString *strId;
@property (nonatomic,retain)NSString *strDateTime;
@property (nonatomic,retain)NSString *strProvider;
@property (nonatomic,retain)NSString *strNotes;
@property (nonatomic,retain)NSDate *dateValue;

@property (nonatomic,retain)NSString *strEventIdentifier;

-(id) initDefaults;
@end

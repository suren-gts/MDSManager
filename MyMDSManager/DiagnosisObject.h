//
//  DiagnosisObject.h
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiagnosisObject : NSObject

@property (nonatomic,retain)NSString *strId;
@property (nonatomic,retain)NSString *strDiagnosis;
@property (nonatomic,retain)NSString *strDate;
@property (nonatomic,retain)NSString *strManagingProvider;
@property (nonatomic,retain)NSString *strNotes;

-(id) initDefaults;
@end

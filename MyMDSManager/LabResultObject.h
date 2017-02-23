//
//  LabResultObject.h
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabResultObject : NSObject
{
    
}

@property (nonatomic,retain)NSString *strId;
@property (nonatomic,retain)NSString *strDiagnosisTest;
@property (nonatomic,retain)NSString *strDate;
@property (nonatomic,retain)NSString *strResult;
@property (nonatomic,retain)NSString *strUnits;
@property (nonatomic,retain)NSString *strManagingProvider;
@property (nonatomic,retain)NSString *strNotes;
@property (nonatomic,retain)NSString *strLabImages;

-(id) initDefaults;

@end

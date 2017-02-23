//
//  SymptomObject.h
//  MyMDSManager
//
//  Created by CEPL on 17/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SymptomObject : NSObject


@property (nonatomic,retain)NSString *strId;
@property (nonatomic,retain)NSString *strSymptom;
@property (nonatomic,retain)NSString *strSymptomSubCat;
@property (nonatomic,retain)NSString *strServirty;
@property (nonatomic,retain)NSString *strDate;
@property (nonatomic,retain)NSDate *dateValue;
@property (nonatomic,retain)NSString *strTime;
@property (nonatomic,retain)NSDate *timeValue;
@property (nonatomic,retain)NSString *strDuration;
@property (nonatomic,retain)NSString *strFrequency;
@property (nonatomic,retain)NSString *strNotes;

@property double dateToOrder;


-(id) initDefaults;
@end

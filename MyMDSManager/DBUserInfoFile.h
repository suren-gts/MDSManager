//
//  DBUserInfoFile.h
//  MyMDSManager
//
//  Created by CEPL on 23/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <Foundation/Foundation.h>
static sqlite3 *database2;

@interface DBUserInfoFile : NSObject
{
    NSString *password;
    
}
-(id)initWith;


-(void)getUserInfo;
-(BOOL )updateUserName;
-(BOOL)updateUserAboutInfo;
-(BOOL )updateUserContactInfo;

-(NSMutableArray*)getAllCaregiver;
-(void)insertCaregivers:(NSDictionary*)DicValue;
-(BOOL)updateCaregivers:(NSDictionary*)DicValue;
-(void)deleteCaregiverForId:(int)rowid;


-(NSMutableArray*)getAllAlergy;
-(void)insertAlergies:(NSDictionary*)DicValue;
-(BOOL)updateAlergies:(NSDictionary*)DicValue;
-(void)deleteAlergyForRowid:(int)rowid;

-(NSMutableArray *)getCountryPhoneCode;


@end

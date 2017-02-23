//
//  DBUserInfoFile.m
//  MyMDSManager
//
//  Created by CEPL on 23/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "DBUserInfoFile.h"
#import "AESCrypt.h"

@implementation DBUserInfoFile

-(id)initWith
{
    password=@"SquareBits";
    if(sqlite3_open([App_Delegate.dBPath_userInfo UTF8String], &database2) == SQLITE_OK)
    {
        NSLog(@"Success");
    }
    else
    {
        NSLog(@"Fail");
    }
    
    return self;
}

-(void)getUserInfo
{
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM userinfo"];
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(database2, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database2));
        
    }
    else if(sqlite3_prepare_v2(database2, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            /*
            //             int i  = sqlite3_column_int(compiledStatement, 0);
            App_Delegate.objAppPerson.strName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            
            App_Delegate.objAppPerson.strDOB=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            
            App_Delegate.objAppPerson.strHeight=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            
            App_Delegate.objAppPerson.strWeight=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            
            App_Delegate.objAppPerson.strBloodGroup=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            
            App_Delegate.objAppPerson.strMaritalStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            
            App_Delegate.objAppPerson.strLivingWith=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            
            App_Delegate.objAppPerson.strSSN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
            
            App_Delegate.objAppPerson.strAddress1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)];
            
            App_Delegate.objAppPerson.strAddress2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,10)];
            
            App_Delegate.objAppPerson.strAddress3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,11)];
            
            App_Delegate.objAppPerson.strCity=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,12)];
            
            App_Delegate.objAppPerson.strState=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,13)];
            
            App_Delegate.objAppPerson.strZipcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,14)];
            
            App_Delegate.objAppPerson.strEmailId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,15)];
            
            App_Delegate.objAppPerson.strContactNoHome=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,16)];
            
            App_Delegate.objAppPerson.strContactNoWork=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,17)];
            
            App_Delegate.objAppPerson.strContactNoCell=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,18)];
            
            App_Delegate.objAppPerson.strGender=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,19)];
            
            App_Delegate.objAppPerson.strCountryCodeHome=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,20)];
            App_Delegate.objAppPerson.strCountryCodeWork=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,21)];
            App_Delegate.objAppPerson.strCountryCodeCell=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,22)];
            */
            
            
            App_Delegate.objAppPerson.strName= [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] password:password];
            
            NSLog(@"%@", App_Delegate.objAppPerson.strName);
            
            App_Delegate.objAppPerson.strDOB=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] password:password];

            
            App_Delegate.objAppPerson.strHeight=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] password:password];

            
            App_Delegate.objAppPerson.strWeight=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)] password:password];

            
            App_Delegate.objAppPerson.strBloodGroup=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)] password:password];

            
            App_Delegate.objAppPerson.strMaritalStatus=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)] password:password];

            
            App_Delegate.objAppPerson.strLivingWith=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)] password:password];

            
            App_Delegate.objAppPerson.strSSN=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)] password:password];

            
            App_Delegate.objAppPerson.strAddress1=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)] password:password];

            
            App_Delegate.objAppPerson.strAddress2=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,10)] password:password];

            
            App_Delegate.objAppPerson.strAddress3=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,11)] password:password];

            
            App_Delegate.objAppPerson.strCity=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,12)] password:password];

            
            App_Delegate.objAppPerson.strState=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,13)] password:password];

            
            App_Delegate.objAppPerson.strZipcode=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,14)] password:password];

            
            App_Delegate.objAppPerson.strEmailId=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,15)] password:password];

            
            App_Delegate.objAppPerson.strContactNoHome=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,16)] password:password];

            
            App_Delegate.objAppPerson.strContactNoWork=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,17)] password:password];

            
            App_Delegate.objAppPerson.strContactNoCell=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,18)] password:password];

            
            App_Delegate.objAppPerson.strGender=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,19)] password:password];

            
            App_Delegate.objAppPerson.strCountryCodeHome=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,20)] password:password];

            App_Delegate.objAppPerson.strCountryCodeWork=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,21)] password:password];

            App_Delegate.objAppPerson.strCountryCodeCell=[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,22)] password:password];


            
        }

    }
}

-(BOOL )updateUserAboutInfo
{
    //NSString *query =  [NSString stringWithFormat:@"UPDATE  userinfo SET dob ='%@', height = '%@', weight = '%@', bloodgroup = '%@', maritalstatus = '%@',livingstatus = '%@',ssn = '%@', gender = '%@' Where uid ='1'",App_Delegate.objAppPerson.strDOB,App_Delegate.objAppPerson.strHeight,App_Delegate.objAppPerson.strWeight,App_Delegate.objAppPerson.strBloodGroup,App_Delegate.objAppPerson.strMaritalStatus,App_Delegate.objAppPerson.strLivingWith,App_Delegate.objAppPerson.strSSN,App_Delegate.objAppPerson.strGender];
    
    
    NSString *enDOB=[AESCrypt encrypt:App_Delegate.objAppPerson.strDOB password:password];
    NSString *enHeight=[AESCrypt encrypt:App_Delegate.objAppPerson.strHeight password:password];
    NSString *enWeight=[AESCrypt encrypt:App_Delegate.objAppPerson.strWeight password:password];
    NSString *enBloodGrp=[AESCrypt encrypt:App_Delegate.objAppPerson.strBloodGroup password:password];
    NSString *enMaritalState=[AESCrypt encrypt:App_Delegate.objAppPerson.strMaritalStatus password:password];
    NSString *enLivingWith =[AESCrypt encrypt:App_Delegate.objAppPerson.strLivingWith password:password];
    NSString *enSSN=[AESCrypt encrypt:App_Delegate.objAppPerson.strSSN password:password];
    NSString *enGender=[AESCrypt encrypt:App_Delegate.objAppPerson.strGender password:password];
    
    NSString *query =  [NSString stringWithFormat:@"UPDATE  userinfo SET dob ='%@', height = '%@', weight = '%@', bloodgroup = '%@', maritalstatus = '%@',livingstatus = '%@',ssn = '%@', gender = '%@' Where uid ='1'",enDOB,enHeight,enWeight,enBloodGrp,enMaritalState,enLivingWith,enSSN,enGender];
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database2, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database2));
            return NO;
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            return YES;
        }
        //  sqlite3_reset(statement);
        //  sqlite3_step(statement);
        //  sqlite3_finalize(statement);
        
        // sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        return NO;
    }
}
-(BOOL )updateUserName
{
    
    NSLog(@"Name -  %@",App_Delegate.objAppPerson.strName);
    
    NSString *enName = [AESCrypt encrypt:App_Delegate.objAppPerson.strName password:password];
    
    //NSString *query =  [NSString stringWithFormat:@"UPDATE  userinfo SET name = '%@' Where uid ='1'",App_Delegate.objAppPerson.strName];
    
    NSString *query =  [NSString stringWithFormat:@"UPDATE  userinfo SET name = '%@' Where uid ='1'",enName];
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database2, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database2));
            return NO;
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            return YES;
        }
        //  sqlite3_reset(statement);
        //  sqlite3_step(statement);
        //  sqlite3_finalize(statement);
        
        // sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        return NO;
    }
}
-(BOOL )updateUserContactInfo
{
    
    //NSString *query =  [NSString stringWithFormat:@"UPDATE  userinfo SET addressline1 = '%@',  addressline2 ='%@', addressline3 = '%@', city = '%@', state = '%@', zipcode = '%@',emailid = '%@',contacthome = '%@' ,contactwork = '%@' ,contactcell = '%@', countrycodehome = '%@', countrycodework = '%@', countrycodecell = '%@' Where uid ='1'",App_Delegate.objAppPerson.strAddress1,App_Delegate.objAppPerson.strAddress2,App_Delegate.objAppPerson.strAddress3,App_Delegate.objAppPerson.strCity,App_Delegate.objAppPerson.strState,App_Delegate.objAppPerson.strZipcode,App_Delegate.objAppPerson.strEmailId,App_Delegate.objAppPerson.strContactNoHome,App_Delegate.objAppPerson.strContactNoWork,App_Delegate.objAppPerson.strContactNoCell,App_Delegate.objAppPerson.strCountryCodeHome,App_Delegate.objAppPerson.strCountryCodeWork,App_Delegate.objAppPerson.strCountryCodeCell];
    
    NSString *enADD1=[AESCrypt encrypt:App_Delegate.objAppPerson.strAddress1 password:password];
    NSString *enADD2=[AESCrypt encrypt:App_Delegate.objAppPerson.strAddress2 password:password];
    NSString *enADD3=[AESCrypt encrypt:App_Delegate.objAppPerson.strAddress3 password:password];
    NSString *enCity=[AESCrypt encrypt:App_Delegate.objAppPerson.strCity password:password];
    NSString *enState=[AESCrypt encrypt:App_Delegate.objAppPerson.strState password:password];
    NSString *enZipCode=[AESCrypt encrypt:App_Delegate.objAppPerson.strZipcode password:password];
    NSString *enEmail=[AESCrypt encrypt:App_Delegate.objAppPerson.strEmailId password:password];
    NSString *enHomeNo=[AESCrypt encrypt:App_Delegate.objAppPerson.strContactNoHome password:password];
    NSString *enWorkNo=[AESCrypt encrypt:App_Delegate.objAppPerson.strContactNoWork password:password];
    NSString *enCntactNo=[AESCrypt encrypt:App_Delegate.objAppPerson.strContactNoCell password:password];
    NSString *enCountryCodeHome=[AESCrypt encrypt:App_Delegate.objAppPerson.strCountryCodeHome password:password];
    NSString *enCountryCodeWork=[AESCrypt encrypt:App_Delegate.objAppPerson.strCountryCodeWork password:password];
    NSString *enCountryCodeCell=[AESCrypt encrypt:App_Delegate.objAppPerson.strCountryCodeCell password:password];
    
    
    NSString *query =  [NSString stringWithFormat:@"UPDATE  userinfo SET addressline1 = '%@',  addressline2 ='%@', addressline3 = '%@', city = '%@', state = '%@', zipcode = '%@',emailid = '%@',contacthome = '%@' ,contactwork = '%@' ,contactcell = '%@', countrycodehome = '%@', countrycodework = '%@', countrycodecell = '%@' Where uid ='1'",enADD1,enADD2,enADD3,enCity,enState,enZipCode,enEmail,enHomeNo,enWorkNo,enCntactNo,enCountryCodeHome,enCountryCodeWork,enCountryCodeCell];
    
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database2, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database2));
            return NO;
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            return YES;
        }
        //  sqlite3_reset(statement);
        //  sqlite3_step(statement);
        //sqlite3_finalize(statement);
        
        // sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        return NO;
    }
}


-(NSMutableArray*)getAllCaregiver
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT rowid,caregivername,caregivercontact,caregiverrelation,caregiveremail FROM caregiversinfo"];
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(database2, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database2));
        
    }
    else if(sqlite3_prepare_v2(database2, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            //    [ary addObject:[NSString stringWithFormat:@"%D",str]];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            int rowid=sqlite3_column_int(compiledStatement, 0);
            [dict setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            
            /*
            [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"caregivername"];
            [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"caregivercontact"];
            [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"caregiverreletion"];
             */
            
            [dict setObject:[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] password:password] forKey:@"caregivername"];
            [dict setObject:[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] password:password] forKey:@"caregivercontact"];
            [dict setObject:[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] password:password] forKey:@"caregiverreletion"];
           [dict setObject:[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)] password:password] forKey:@"caregiveremail"];
            
            [arr addObject:dict];
        }
    }
    return arr;
}

-(void)insertCaregivers:(NSDictionary*)DicValue
{
    
    //NSString *query =[NSString stringWithFormat:@"INSERT INTO caregiversinfo (caregivername,caregivercontact,caregiverrelation) VALUES (\"%@\", \"%@\",\"%@\") ", [DicValue objectForKey:@"caregivername"],[DicValue objectForKey:@"caregivercontact"],[DicValue objectForKey:@"caregiverreletion"]];
    
    
    NSString *enCName=[AESCrypt encrypt:[DicValue objectForKey:@"caregivername"] password:password];
    NSString *enCContact=[AESCrypt encrypt:[DicValue objectForKey:@"caregivercontact"] password:password];
    NSString *enCRelation=[AESCrypt encrypt:[DicValue objectForKey:@"caregiverreletion"] password:password];
    NSString *enCEmail=[AESCrypt encrypt:[DicValue objectForKey:@"caregiveremail"] password:password];
    
    NSString *query =[NSString stringWithFormat:@"INSERT INTO caregiversinfo (caregivername,caregivercontact,caregiverrelation,caregiveremail) VALUES (\"%@\", \"%@\",\"%@\",\"%@\") ",enCName,enCContact,enCRelation,enCEmail];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database2, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database2));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
    }
}
-(BOOL)updateCaregivers:(NSDictionary*)DicValue
{
    
    NSString *enCName=[AESCrypt encrypt:[DicValue objectForKey:@"caregivername"] password:password];
    NSString *enCContact=[AESCrypt encrypt:[DicValue objectForKey:@"caregivercontact"] password:password];
    NSString *enCRelation=[AESCrypt encrypt:[DicValue objectForKey:@"caregiverreletion"] password:password];
    NSString *enCEmail=[AESCrypt encrypt:[DicValue objectForKey:@"caregiveremail"] password:password];
    
    
   // NSString *query =  [NSString stringWithFormat:@"UPDATE  caregiversinfo SET caregivername = '%@',  caregivercontact ='%@',  caregiverrelation ='%@' Where rowid ='%@'",[DicValue objectForKey:@"caregivername"],[DicValue objectForKey:@"caregivercontact"],[DicValue objectForKey:@"caregiverreletion"],[DicValue valueForKey:@"rowid"]];
    
     NSString *query =  [NSString stringWithFormat:@"UPDATE  caregiversinfo SET caregivername = '%@',  caregivercontact ='%@',  caregiverrelation ='%@', caregiveremail ='%@' Where rowid ='%@'",enCName,enCContact,enCRelation,enCEmail,[DicValue valueForKey:@"rowid"]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database2, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database2));
            return NO;
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            return YES;
        }
        //  sqlite3_reset(statement);
        //  sqlite3_step(statement);
        //  sqlite3_finalize(statement);
        
        // sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        return NO;
    }
}
-(void)deleteCaregiverForId:(int)rowid
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM caregiversinfo where rowid=='%d'",rowid] ;
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database2, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database2));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

-(NSMutableArray*)getAllAlergy
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT rowid,allergytype,allergysubstance FROM alergyinfo"];
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(database2, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database2));
        
    }
    else if(sqlite3_prepare_v2(database2, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            //    [ary addObject:[NSString stringWithFormat:@"%D",str]];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            int rowid=sqlite3_column_int(compiledStatement, 0);
            [dict setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            
            /*
            [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"alergiename"];
            [dict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"alergiesubtance"];
             */
            
            [dict setObject:[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] password:password] forKey:@"alergiename"];
            [dict setObject:[AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] password:password] forKey:@"alergiesubtance"];
            
            
            [arr addObject:dict];
        }
    }
    return arr;
}

-(void)insertAlergies:(NSDictionary*)DicValue
{
    
    NSString *enAlergyName=[AESCrypt encrypt:[DicValue objectForKey:@"alergiename"] password:password];
    NSString *enAlergySubstance=[AESCrypt encrypt:[DicValue objectForKey:@"alergiesubtance"] password:password];
    
    NSString *query =[NSString stringWithFormat:@"INSERT INTO alergyinfo (allergytype,allergysubstance) VALUES (\"%@\", \"%@\") ",enAlergyName,enAlergySubstance];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database2, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database2));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
    }
}

-(BOOL)updateAlergies:(NSDictionary*)DicValue
{
    NSString *enAlergyName=[AESCrypt encrypt:[DicValue objectForKey:@"alergiename"] password:password];
    NSString *enAlergySubstance=[AESCrypt encrypt:[DicValue objectForKey:@"alergiesubtance"] password:password];
    
    //NSString *query =  [NSString stringWithFormat:@"UPDATE  alergyinfo SET allergytype = '%@',  allergysubstance ='%@' Where rowid ='%@'",[DicValue objectForKey:@"alergiename"],[DicValue objectForKey:@"alergiesubtance"],[DicValue valueForKey:@"rowid"]];
    
    NSString *query =  [NSString stringWithFormat:@"UPDATE  alergyinfo SET allergytype = '%@',  allergysubstance ='%@' Where rowid ='%@'",enAlergyName,enAlergySubstance,[DicValue valueForKey:@"rowid"]];
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database2, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database2));
            return NO;
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            return YES;
        }
        //  sqlite3_reset(statement);
        //  sqlite3_step(statement);
        //  sqlite3_finalize(statement);
        
        // sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database2));
        return NO;
    }
}

-(void)deleteAlergyForRowid:(int)rowid
{
    
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM alergyinfo where rowid=='%d'",rowid] ;
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database2, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database2));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}


-(NSMutableArray *)getCountryPhoneCode
{
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT distinct Country,CountryCode FROM globalareacodes"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    NSMutableArray *arrDataList = [[NSMutableArray alloc] init];
    if(sqlite3_prepare_v2(database2, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database2));
    }
    else if(sqlite3_prepare_v2(database2, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            NSMutableDictionary *dictValue = [[NSMutableDictionary alloc] init];
            [dictValue setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)] forKey:@"CountryName"]; ;
            [dictValue setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"CountryCode"]; ;
            [arrDataList addObject:dictValue];
        }
        
    }
    return arrDataList;
}

@end

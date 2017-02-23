//
//  DBFile.m
//  Italic
//
//  Created by FOX-MAC-M on 29/03/14.
//  Copyright (c) 2014 fox. All rights reserved.
//  com.italickeyboard.app

#import "DBFile.h"
#import "AppDelegate.h"


@implementation DBFile
{
    
}

-(id)initWith
{
   
    formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyyHHmmssSSS"];

    if(sqlite3_open([App_Delegate.dBPath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"Success");
        
    }
    else
    {
        NSLog(@"Fail");
    }

    return self;
}

#pragma mark Search Criteia

-(NSMutableArray*)getSymptomInfoListForFilter:(NSString *)strFilter
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM symptorInfo where symptomname LIKE '%%%@%%' OR severity LIKE '%%%@%%'  OR symptomdate LIKE '%%%@%%'  OR symptomtime LIKE '%%%@%%'  OR duration LIKE '%%%@%%' OR frequency LIKE '%%%@%%' OR notes LIKE '%%%@%%' ",strFilter,strFilter,strFilter,strFilter,strFilter,strFilter,strFilter];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            SymptomObject *objSymptom=[[SymptomObject alloc]init];
            objSymptom.strId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objSymptom.strSymptom=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objSymptom.strServirty=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objSymptom.strDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objSymptom.strTime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            objSymptom.strDuration=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            objSymptom.strFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            objSymptom.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            [arr addObject:objSymptom];
        }
    }
    return arr;
}

-(NSMutableArray*)GetAllMedicalProviderForFilter:(NSString *)strFilter
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM medicalprovider where providername LIKE '%%%@%%' OR providerspeciality LIKE '%%%@%%'  OR referredby LIKE '%%%@%%'  OR address LIKE '%%%@%%'  OR phone LIKE '%%%@%%' OR email LIKE '%%%@%%' OR fax LIKE '%%%@%%' ",strFilter,strFilter,strFilter,strFilter,strFilter,strFilter,strFilter];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            int rowid=sqlite3_column_int(compiledStatement, 0);
            [dictObject setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"name"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"speciality"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"reference"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)] forKey:@"address"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)] forKey:@"phone"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)] forKey:@"fax"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)] forKey:@"mail"];
            
            [arr addObject:dictObject];
        }
    }
    return arr;
}

-(NSMutableArray*)getMedicinesForFilter:(NSString *)strFilter
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM MedicineInfo where drugname LIKE '%%%@%%' OR genericname LIKE '%%%@%%'  OR type LIKE '%%%@%%'  OR frequency LIKE '%%%@%%'  OR startdate LIKE '%%%@%%' OR prescirbedby LIKE '%%%@%%' OR notes LIKE '%%%@%%' ",strFilter,strFilter,strFilter,strFilter,strFilter,strFilter,strFilter];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            MedicalObject *ObjMedical=[[MedicalObject alloc]initDefaults];
            
            ObjMedical.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            ObjMedical.strDrugName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            ObjMedical.strGenericName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            ObjMedical.strDosage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            ObjMedical.strType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            ObjMedical.strFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            ObjMedical.strStartDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            ObjMedical.strEndDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            ObjMedical.strRefillDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
            ObjMedical.strPrescribedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)];
            ObjMedical.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,10)];
            ObjMedical.strImageName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,11)];
            ObjMedical.strRefillFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,12)];
            ObjMedical.startDate=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 13)];
            ObjMedical.endDate=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 14)];
            ObjMedical.strReminder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,15)];
            ObjMedical.strRFrequencyTitle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,16)];
            ObjMedical.strReminderCounts=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,17)];
            ObjMedical.reminderStartTime=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 18)];
            ObjMedical.strScheduleDays=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,19)];
            ObjMedical.strReminderSoundName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,20)];
            ObjMedical.strRemdinerSoundIndex=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,21)];

            [arr addObject:ObjMedical];
        }
    }
    return arr;
}

-(NSMutableArray*)GetAllNotesForFilter:(NSString *)strFilter
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM notesInfo where date LIKE '%%%@%%' OR topic LIKE '%%%@%%'  OR notes LIKE '%%%@%%'",strFilter,strFilter,strFilter];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictNotes=[[NSMutableDictionary alloc]init];
            [dictNotes setValue:[NSString stringWithFormat:@"%d",sqlite3_column_int(compiledStatement,0)] forKey:@"rowid"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"date"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"topic"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"note"];
            
            [arr addObject:dictNotes];
        }
    }
    return arr;
}

#pragma mark - Medicine Methods

-(NSMutableArray*)getAllCurrentMedicines:(NSString *)strValue
{
    NSTimeInterval timeInterval=[[NSDate date] timeIntervalSince1970];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM MedicineInfo where type='%@' AND (endtimestamp > '%f' OR endtimestamp == '%f' OR endtimestamp == '0') ORDER BY mid DESC",strValue,timeInterval,timeInterval];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            MedicalObject *ObjMedical=[[MedicalObject alloc]initDefaults];
            
            ObjMedical.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            ObjMedical.strDrugName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            ObjMedical.strGenericName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            ObjMedical.strDosage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            ObjMedical.strType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            ObjMedical.strFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            ObjMedical.strStartDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            ObjMedical.strEndDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            ObjMedical.strRefillDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
            ObjMedical.strPrescribedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)];
            ObjMedical.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,10)];
            ObjMedical.strImageName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,11)];
            ObjMedical.strRefillFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,12)];
            ObjMedical.startDate=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 13)];
            ObjMedical.endDate=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 14)];
            ObjMedical.strReminder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,15)];
            ObjMedical.strRFrequencyTitle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,16)];
            ObjMedical.strReminderCounts=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,17)];
            ObjMedical.reminderStartTime=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 18)];
            ObjMedical.strScheduleDays=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,19)];
            ObjMedical.strReminderSoundName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,20)];
            ObjMedical.strRemdinerSoundIndex=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,21)];

            [arr addObject:ObjMedical];
        }
    }
    return arr;
}

-(NSMutableArray*)getAllPreviousMedicines:(NSString *)strValue;
{
    NSTimeInterval timeInterval=[[NSDate date] timeIntervalSince1970];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM MedicineInfo where type='%@' AND endtimestamp < '%f' AND endtimestamp !=0 ORDER BY mid DESC",strValue,timeInterval];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            MedicalObject *ObjMedical=[[MedicalObject alloc]initDefaults];
            ObjMedical.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            ObjMedical.strDrugName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            ObjMedical.strGenericName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            ObjMedical.strDosage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            ObjMedical.strType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            ObjMedical.strFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            ObjMedical.strStartDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            ObjMedical.strEndDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            ObjMedical.strRefillDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
            ObjMedical.strPrescribedBy=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)];
            ObjMedical.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,10)];
            ObjMedical.strImageName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,11)];
            ObjMedical.strRefillFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,12)];
            ObjMedical.startDate=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 13)];
            ObjMedical.endDate=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 14)];
            ObjMedical.strReminder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,15)];
            ObjMedical.strRFrequencyTitle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,16)];
            ObjMedical.strReminderCounts=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,17)];
            ObjMedical.reminderStartTime=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 18)];
            ObjMedical.strScheduleDays=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,19)];
            ObjMedical.strReminderSoundName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,20)];
            ObjMedical.strRemdinerSoundIndex=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,21)];
            
            [arr addObject:ObjMedical];
        }
    }
    return arr;
}

-(int)insertMedicine:(MedicalObject *)objMedicine
{
    int lastRowId=-1;
    NSTimeInterval startTimeInterval=[objMedicine.startDate timeIntervalSince1970];
    
    NSTimeInterval endtTimeInterval=[objMedicine.endDate timeIntervalSince1970];
    
    NSString *query =[NSString stringWithFormat:@"INSERT INTO MedicineInfo (drugname,genericname,dosage,type,frequency,startdate,enddate,refildate,prescirbedby,notes,imagename,refilfrequency,starttimestamp,endtimestamp,reminderstring,rfrequencytitle,remindercounts,reminderstarttime,scheduledays,remindersoundfile,remindersoundindex) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" , \"%f\", \"%f\" , \"%@\" , \"%@\" , \"%@\" , \"%f\", \"%@\", \"%@\", \"%@\") ",objMedicine.strDrugName,objMedicine.strGenericName,objMedicine.strDosage,objMedicine.strType,objMedicine.strFrequency,objMedicine.strStartDate,objMedicine.strEndDate,objMedicine.strRefillDate,objMedicine.strPrescribedBy,objMedicine.strNotes,objMedicine.strImageName,objMedicine.strRefillFrequency,startTimeInterval,endtTimeInterval,objMedicine.strReminder,objMedicine.strRFrequencyTitle,objMedicine.strReminderCounts,[objMedicine.reminderStartTime timeIntervalSince1970],objMedicine.strScheduleDays,objMedicine.strReminderSoundName,objMedicine.strRemdinerSoundIndex];
    
   
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
        lastRowId = (int)sqlite3_last_insert_rowid(database);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}
-(BOOL)updateMedicine:(MedicalObject *)objMedicine
{
    NSTimeInterval startTimeInterval=[objMedicine.startDate timeIntervalSince1970];
    NSTimeInterval endtTimeInterval=[objMedicine.endDate timeIntervalSince1970];
    
    if (objMedicine.strEndDate.length<=0)
    {
        objMedicine.strEndDate=@"N/A";
    }
    
    NSString *query =  [NSString stringWithFormat:@"UPDATE  MedicineInfo SET drugname = '%@',  genericname ='%@', dosage = '%@', type = '%@', frequency = '%@', startdate = '%@',enddate = '%@',refildate = '%@' , prescirbedby = '%@' , notes = '%@' , imagename = '%@' , refilfrequency = '%@', starttimestamp = '%f' , endtimestamp = '%f' , reminderstring = '%@', rfrequencytitle = '%@', remindercounts = '%@' , reminderstarttime = '%f', scheduledays= '%@', remindersoundfile = '%@', remindersoundindex = '%@' Where mid ='%@'",objMedicine.strDrugName,objMedicine.strGenericName,objMedicine.strDosage,objMedicine.strType,objMedicine.strFrequency,objMedicine.strStartDate,objMedicine.strEndDate,objMedicine.strRefillDate,objMedicine.strPrescribedBy,objMedicine.strNotes,objMedicine.strImageName,objMedicine.strRefillFrequency,startTimeInterval,endtTimeInterval,objMedicine.strReminder,objMedicine.strRFrequencyTitle,objMedicine.strReminderCounts,[objMedicine.reminderStartTime timeIntervalSince1970],objMedicine.strScheduleDays, objMedicine.strReminderSoundName, objMedicine.strRemdinerSoundIndex ,objMedicine.strId];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
            return NO;
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            return YES;
        }
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}
-(void)deleteMedicine:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM MedicineInfo where mid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

-(NSMutableArray*)getAllDiagnosis
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM medicaldiagnosishistory where historytype='d' ORDER BY drowid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            DiagnosisObject *objDiagnosis=[[DiagnosisObject alloc]initDefaults];
            
            objDiagnosis.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objDiagnosis.strDiagnosis=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objDiagnosis.strDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objDiagnosis.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objDiagnosis.strManagingProvider=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];

            [arr addObject:objDiagnosis];
        }
    }
    return arr;

}
-(void)insertDiagnosisHistory:(DiagnosisObject *)objDiagonsis
{
    
  NSString *query =[NSString stringWithFormat:@"INSERT INTO medicaldiagnosishistory (diagnosis,date,notes,managingprovider,historytype) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\") ",objDiagonsis.strDiagnosis,objDiagonsis.strDate,objDiagonsis.strNotes,objDiagonsis.strManagingProvider,@"d"];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
}
-(BOOL)updateMedicalHistory:(DiagnosisObject *)objDiagonsis //update Diagnosis & Surgery
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  medicaldiagnosishistory SET diagnosis = '%@',  date ='%@', notes = '%@', managingprovider = '%@' Where drowid ='%@'",objDiagonsis.strDiagnosis,objDiagonsis.strDate,objDiagonsis.strNotes,objDiagonsis.strManagingProvider,objDiagonsis.strId];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(NSMutableArray*)getAllSurgery
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM medicaldiagnosishistory where historytype='s' ORDER BY drowid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            DiagnosisObject *objDiagnosis=[[DiagnosisObject alloc]initDefaults];
            
            objDiagnosis.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objDiagnosis.strDiagnosis=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objDiagnosis.strDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objDiagnosis.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objDiagnosis.strManagingProvider=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];

            
            [arr addObject:objDiagnosis];
        }
    }
    return arr;
    
}
-(void)insertSurgicalHistory:(DiagnosisObject *)objDiagonsis
{
    
    NSString *query =[NSString stringWithFormat:@"INSERT INTO medicaldiagnosishistory (diagnosis,date,notes,managingprovider,historytype) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\") ",objDiagonsis.strDiagnosis,objDiagonsis.strDate,objDiagonsis.strNotes,objDiagonsis.strManagingProvider,@"s"];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
}

-(void)deleteMedicalHistory:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM medicaldiagnosishistory where drowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

-(NSMutableArray*)getAllBloodCellInitialLabResult
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM labresultinfo where labresulttype='Ib' ORDER BY lrowid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            LabResultObject *objLab=[[LabResultObject alloc]initDefaults];
            
            objLab.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objLab.strDiagnosisTest=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objLab.strDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objLab.strResult=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objLab.strUnits=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            objLab.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            objLab.strLabImages=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            [arr addObject:objLab];
        }
    }
    return arr;
    
}

-(int)insertBloodCellInitialLabResult:(LabResultObject *)objLab
{
    NSString *query =[NSString stringWithFormat:@"INSERT INTO labresultinfo (diagnosistest,date,results,units,notes,labimages,labresulttype) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\") ",objLab.strDiagnosisTest,objLab.strDate,objLab.strResult,objLab.strUnits,objLab.strNotes,objLab.strLabImages,@"Ib"];
    int lastRowId = -1;
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            lastRowId = (int)sqlite3_last_insert_rowid(database);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}

-(BOOL)updateInitialLabReuslts:(LabResultObject *)objLab //update BloodCount & Diagnosis Test
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  labresultinfo SET diagnosistest = '%@',  date ='%@', results = '%@', units = '%@' , notes = '%@' , labimages = '%@' Where lrowid ='%@'",objLab.strDiagnosisTest,objLab.strDate,objLab.strResult,objLab.strUnits,objLab.strNotes,objLab.strLabImages,objLab.strId];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(void)deleteInitialLabReuslts:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM labresultinfo where lrowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

-(NSMutableArray*)getAllBloodCellOnGoingLabResult
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM labresultinfo where labresulttype='Od' ORDER BY lrowid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            LabResultObject *objLab=[[LabResultObject alloc]initDefaults];
            
            objLab.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objLab.strDiagnosisTest=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objLab.strDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objLab.strResult=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objLab.strUnits=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            objLab.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            objLab.strLabImages=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            
            [arr addObject:objLab];
        }
    }
    return arr;
    
}

-(int)insertBloodCellOnGoingLabResult:(LabResultObject *)objLab
{
    int lastRowId = -1;
    NSString *query =[NSString stringWithFormat:@"INSERT INTO labresultinfo (diagnosistest,date,results,units,notes,labimages,labresulttype) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\") ",objLab.strDiagnosisTest,objLab.strDate,objLab.strResult,objLab.strUnits,objLab.strNotes,objLab.strLabImages,@"Od"];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            lastRowId = (int)sqlite3_last_insert_rowid(database);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}

-(NSMutableArray*)getInsuranceDetail
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM InsuranceDetail order by irowid"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            InsuranceCompanyObject *object=[[InsuranceCompanyObject alloc]initDefaults];
            
            object.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            object.strOptions=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            object.strCopanyName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            object.strPhoneNumber=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            object.strEmployer=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
             object.strGroup=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
             object.strPrescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
             object.strAddress=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
             object.strCity=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
             object.strState=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)];
             object.strZipCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,10)];
             object.strCompanyType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,11)];
            object.strImageName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,12)];
            if (object.strImageName.length>0)
            {
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
                NSString *filePath = [dataPath stringByAppendingPathComponent:object.strImageName];
                object.imgCompany=[UIImage imageWithContentsOfFile:filePath];
            }
            [arr addObject:object];
        }
    }
    return arr;
    
}
-(BOOL)updateInsuranceDetail:(InsuranceCompanyObject *)objInsurance
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  InsuranceDetail SET companyoption = '%@',  companyname ='%@', phoneno = '%@', employer = '%@', companygroup = '%@', prescription = '%@',address = '%@',city = '%@' , state = '%@' , zipcode = '%@', companyimagename = '%@' Where companytype ='%@'",objInsurance.strOptions,objInsurance.strCopanyName,objInsurance.strPhoneNumber,objInsurance.strEmployer,objInsurance.strGroup,objInsurance.strPrescription,objInsurance.strAddress,objInsurance.strCity,objInsurance.strState,objInsurance.strZipCode,objInsurance.strImageName,objInsurance.strCompanyType];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(NSMutableArray*)GetTodaysAppointments:(NSDate *)forDate
{
    NSTimeInterval startTimeInterval=[forDate timeIntervalSince1970];
    NSDate *dateForNextDay=[forDate dateByAddingTimeInterval:86400];
    NSTimeInterval endTimeInterval=[dateForNextDay timeIntervalSince1970];
    NSMutableArray *arr = [[NSMutableArray alloc]init];//timestamp BETWEEN %f AND %f
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM appointmentsInfo where datetimestamp BETWEEN %f AND %f ORDER BY datetimestamp",startTimeInterval,endTimeInterval];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            AppointementObject *objAppoint=[[AppointementObject alloc]initDefaults];
            
            objAppoint.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objAppoint.strDateTime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objAppoint.strProvider=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objAppoint.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objAppoint.dateValue=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 4)];
            objAppoint.strEventIdentifier=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            [arr addObject:objAppoint];
        }
    }
    return arr;
}

-(NSMutableArray*)GetAllCurrentAppointments
{
    
//  NSTimeInterval timeInterval=[[NSDate date] timeIntervalSince1970];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM appointmentsInfo"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            AppointementObject *objAppoint=[[AppointementObject alloc]initDefaults];
            
            objAppoint.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objAppoint.strDateTime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objAppoint.strProvider=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objAppoint.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objAppoint.dateValue=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 4)];
            objAppoint.strEventIdentifier=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            [arr addObject:objAppoint];
        }
    }
    return arr;
}

-(NSMutableDictionary *)GetAppointmentForCalaenderEvent
{
    //    NSTimeInterval timeInterval=[[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *dictEvent = [[NSMutableDictionary alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT datetimestamp FROM appointmentsInfo"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    NSDateFormatter *localformatter = [[NSDateFormatter alloc] init];
    [localformatter setDateFormat:@"yyyy-MM-dd"];

    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSDate *myDate=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 0)];
            
            NSString *strEventKey = [localformatter stringFromDate:myDate];
            [dictEvent setValue:@"YES" forKey:strEventKey];
        }
    }
    return dictEvent;
}

/*
-(NSMutableArray*)GetAllPreviousAppointments
{
    NSTimeInterval timeInterval=[[NSDate date] timeIntervalSince1970];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM appointmentsInfo where datetimestamp < '%f'",timeInterval];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            AppointementObject *objAppoint=[[AppointementObject alloc]initDefaults];
            
            objAppoint.rowid= sqlite3_column_int(compiledStatement, 0);
            objAppoint.strDateTime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objAppoint.strProvider=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objAppoint.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objAppoint.dateValue=[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(compiledStatement, 4)];
            
            [arr addObject:objAppoint];
        }
    }
    return arr;
}
 */
-(int)insertAppointments:(AppointementObject *)objAppoint
{
    int lastRowId = -1;
    NSTimeInterval timeInterval=[objAppoint.dateValue timeIntervalSince1970];
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"MMM dd yyyy  hh:mm a"];
    NSString *strDate=[dateformater stringFromDate:objAppoint.dateValue];
    NSLog(@"Date :%@",strDate);
    
    NSString *query =[NSString stringWithFormat:@"INSERT INTO appointmentsInfo (dateNtime,provider,notes,eventidentifier,datetimestamp) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%f\") ",objAppoint.strDateTime,objAppoint.strProvider,objAppoint.strNotes,objAppoint.strEventIdentifier,timeInterval];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            lastRowId = (int)sqlite3_last_insert_rowid(database);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}
-(BOOL)updateAppointments:(AppointementObject *)objAppoint
{
    NSString *query=@"";
    if (objAppoint.dateValue)
    {
        NSTimeInterval timeInterval=[objAppoint.dateValue timeIntervalSince1970];
        query =  [NSString stringWithFormat:@"UPDATE  appointmentsInfo SET dateNtime = '%@',  provider ='%@', notes = '%@', datetimestamp = '%f' ,eventidentifier = '%@' Where arowid ='%@'",objAppoint.strDateTime,objAppoint.strProvider,objAppoint.strNotes,timeInterval,objAppoint.strEventIdentifier,objAppoint.strId];
    }
    else
    {
        query =  [NSString stringWithFormat:@"UPDATE  appointmentsInfo SET dateNtime = '%@',  provider ='%@', notes = '%@', eventidentifier = '%@' Where arowid ='%@'",objAppoint.strDateTime,objAppoint.strProvider,objAppoint.strNotes,objAppoint.strEventIdentifier,objAppoint.strId];
    }
    
   
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(void)deleteAppointment:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM appointmentsInfo where arowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}


-(NSMutableArray*)getAllSymptom:(NSString *)strCat
{    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT symptom FROM symptomslist where description like '%@'",strCat];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            [arr addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)]];
        }
    }
    return arr;
}

-(NSMutableArray*)getAllSymptomWithId
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM symptomslist"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            NSMutableDictionary *dictValue = [[NSMutableDictionary alloc] init];
            [dictValue setValue:[NSString stringWithFormat:@"%d",sqlite3_column_int(compiledStatement,0)] forKey:@"rowid"];
            [dictValue setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"Symptom"];
            [arr addObject:dictValue];
        }
    }
    return arr;
}

-(void)createSymptom:(NSString *)strSymptom withDescription:(NSString *)strDesc
{
    NSString *query =[NSString stringWithFormat:@"INSERT INTO symptomslist (symptom,description) VALUES (\"%@\", \"%@\") ",strSymptom,strDesc];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
}
-(void)deleteUserCreateSymptom:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM symptomslist where rowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}
//notesInfo" ("nrowid" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "date" VARCHAR, "topic" VARCHAR, "notes" VARCHAR)


-(NSMutableArray*)GetAllNotes
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM notesInfo ORDER BY nrowid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictNotes=[[NSMutableDictionary alloc]init];
            [dictNotes setValue:[NSString stringWithFormat:@"%d",sqlite3_column_int(compiledStatement,0)] forKey:@"rowid"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"date"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"topic"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"note"];

            [arr addObject:dictNotes];
        }
    }
    return arr;
}

-(void)insertNotes:(NSMutableDictionary *)dictNotes
{
    
     NSString *query =[NSString stringWithFormat:@"INSERT INTO notesInfo (date,topic,notes) VALUES (\"%@\", \"%@\", \"%@\") ",[dictNotes valueForKey:@"date"],[dictNotes valueForKey:@"topic"],[dictNotes valueForKey:@"note"]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
}
-(BOOL)updatetNotes:(NSMutableDictionary *)dictNotes
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  notesInfo SET date = '%@',  topic ='%@', notes = '%@' Where rowid ='%@'",[dictNotes valueForKey:@"date"],[dictNotes valueForKey:@"topic"],[dictNotes valueForKey:@"note"],[dictNotes valueForKey:@"rowid"]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}
-(void)deleteNotes:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM notesInfo where rowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

// bloodcountResult" ("broid" date,hgb,wbc,anc,platelets,rbcs,tranfusion,notes,ferritin" VARCHAR)

-(NSMutableArray*)GetAllBloodCountResult
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM bloodcountResult"];
    
    // NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM bloodcountResult ORDER BY broid DESC"];
    
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM bloodcountResult ORDER BY date_to_order DESC"];
    
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            int rowid=sqlite3_column_int(compiledStatement, 0);
            [dictObject setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"date"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"HGB"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"WBC"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)] forKey:@"ANC"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)] forKey:@"Platelets"];
            /*[dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)] forKey:@"RBCS"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)] forKey:@"Tranfusion"];*/
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)] forKey:@"notes"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)] forKey:@"Ferritin"];

            
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)] forKey:@"bloodnotes"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)] forKey:@"bloodcountsimages"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,10)] forKey:@"date_to_order"];
            
            [arr addObject:dictObject];
        }
    }
    return arr;
}

-(int)insertBloodCountResult:(NSMutableDictionary *)dictObject
{
    int lastRowId=-1;
    /*
    NSString *query =[NSString stringWithFormat:@"INSERT INTO bloodcountResult (date, hgb, wbc, anc, platelets, rbcs, tranfusion, notes,ferritin,bloodnotes,bloodcountsimages,date_to_order) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" , \"%@\",\"%@\") ",[dictObject valueForKey:@"date"],[dictObject valueForKey:@"HGB"],[dictObject valueForKey:@"WBC"],[dictObject valueForKey:@"ANC"],[dictObject valueForKey:@"Platelets"],[dictObject valueForKey:@"RBCS"],[dictObject valueForKey:@"Tranfusion"],[dictObject valueForKey:@"notes"],[dictObject valueForKey:@"Ferritin"],[dictObject valueForKey:@"bloodnotes"],[dictObject valueForKey:@"bloodcountsimages"],[dictObject valueForKey:@"date_to_order"]];
    */
    
     NSString *query =[NSString stringWithFormat:@"INSERT INTO bloodcountResult (date, hgb, wbc, anc, platelets, notes,ferritin,bloodnotes,bloodcountsimages,date_to_order) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\") ",[dictObject valueForKey:@"date"],[dictObject valueForKey:@"HGB"],[dictObject valueForKey:@"WBC"],[dictObject valueForKey:@"ANC"],[dictObject valueForKey:@"Platelets"],[dictObject valueForKey:@"notes"],[dictObject valueForKey:@"Ferritin"],[dictObject valueForKey:@"bloodnotes"],[dictObject valueForKey:@"bloodcountsimages"],[dictObject valueForKey:@"date_to_order"]];
    
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
        lastRowId = (int)sqlite3_last_insert_rowid(database);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}

-(BOOL)updateBloodCountResult:(NSMutableDictionary *)dictObject
{
    /*
    NSString *query =  [NSString stringWithFormat:@"UPDATE  bloodcountResult SET date = '%@',  hgb ='%@', wbc = '%@', anc = '%@', platelets = '%@', rbcs = '%@',tranfusion = '%@',notes = '%@' , ferritin = '%@' ,bloodnotes = '%@', bloodcountsimages = '%@' ,date_to_order = '%@' Where broid ='%@'",[dictObject valueForKey:@"date"],[dictObject valueForKey:@"HGB"],[dictObject valueForKey:@"WBC"],[dictObject valueForKey:@"ANC"],[dictObject valueForKey:@"Platelets"],[dictObject valueForKey:@"RBCS"],[dictObject valueForKey:@"Tranfusion"],[dictObject valueForKey:@"notes"],[dictObject valueForKey:@"Ferritin"],[dictObject valueForKey:@"bloodnotes"],[dictObject valueForKey:@"bloodcountsimages"],[dictObject valueForKey:@"date_to_order"],[dictObject valueForKey:@"rowid"]];
     */
    
    NSString *query =  [NSString stringWithFormat:@"UPDATE  bloodcountResult SET date = '%@',  hgb ='%@', wbc = '%@', anc = '%@', platelets = '%@',notes = '%@' , ferritin = '%@' ,bloodnotes = '%@', bloodcountsimages = '%@' ,date_to_order = '%@' Where broid ='%@'",[dictObject valueForKey:@"date"],[dictObject valueForKey:@"HGB"],[dictObject valueForKey:@"WBC"],[dictObject valueForKey:@"ANC"],[dictObject valueForKey:@"Platelets"],[dictObject valueForKey:@"notes"],[dictObject valueForKey:@"Ferritin"],[dictObject valueForKey:@"bloodnotes"],[dictObject valueForKey:@"bloodcountsimages"],[dictObject valueForKey:@"date_to_order"],[dictObject valueForKey:@"rowid"]];
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(void)deleteBloodCountResult:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM bloodcountResult where broid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

-(NSMutableArray*)getAllBloodCountForParticularBlood:(NSString *)strBloodCount
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
   // NSString *queryString=[NSString stringWithFormat:@"SELECT date, %@ FROM bloodcountResult where %@ > 0 ORDER BY date_to_order ASC",strBloodCount,strBloodCount];
    //NSString *queryString=[NSString stringWithFormat:@"SELECT date, %@ FROM bloodcountResult where %@ > 0 ORDER BY broid ASC",strBloodCount,strBloodCount];
    NSString *queryString=[NSString stringWithFormat:@"SELECT date, %@ FROM bloodcountResult where %@ > 0 ORDER BY date_to_order ASC",strBloodCount,strBloodCount];
    
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
        
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)] forKey:@"date"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"value"];

            
            [arr addObject:dictObject];
        }
    }
    return arr;
}

//otherlabreult" ("otherrowid" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "blabid" INTEGER, "labtitle" VARCHAR, "labvalue" VARCHAR)

-(NSMutableArray *)GetOtherLabResult:(NSInteger)forRowid
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM otherlabreult where blabid like '%ld'",(long)forRowid];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            //int rowid=sqlite3_column_int(compiledStatement, 0);
           // [dictObject setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"labTitle"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"labValue"];
            
            [arr addObject:dictObject];
        }
    }
    return arr;
}
-(int)insertOtherResult:(NSMutableDictionary *)dictObject
{
    int lastRowId=-1;
    NSString *query =[NSString stringWithFormat:@"INSERT INTO otherlabreult (blabid, labtitle, labvalue) VALUES (\"%@\", \"%@\",\"%@\") ",[dictObject valueForKey:@"browid"],[dictObject valueForKey:@"labTitle"],[dictObject valueForKey:@"labValue"]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
        lastRowId = (int)sqlite3_last_insert_rowid(database);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}

// treatementInfo" ("trowid" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "startdate" VARCHAR, "enddate" VARCHAR, "treatement" VARCHAR, "notes" VARCHAR)

-(NSMutableArray*)GetAllMDSTreatment
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM treatementInfo ORDER BY trowid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            int rowid=sqlite3_column_int(compiledStatement, 0);
            [dictObject setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"startdate"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"enddate"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"treatment"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)] forKey:@"note"];
            [arr addObject:dictObject];
        }
    }
    return arr;
}

-(int)insertMDSTreatment:(NSMutableDictionary *)dictObject
{
    int lastRowId=1;
    NSString *query =[NSString stringWithFormat:@"INSERT INTO treatementInfo (startdate, enddate, treatement, notes) VALUES (\"%@\", \"%@\", \"%@\" ,\"%@\") ",[dictObject valueForKey:@"startdate"],[dictObject valueForKey:@"enddate"],[dictObject valueForKey:@"treatment"],[dictObject valueForKey:@"note"]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
        lastRowId = (int)sqlite3_last_insert_rowid(database);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}


-(BOOL)updateMDSTreatment:(NSMutableDictionary *)dictObject
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  treatementInfo SET startdate = '%@',  enddate ='%@', treatement = '%@', notes = '%@' Where trowid ='%@'",[dictObject valueForKey:@"startdate"],[dictObject valueForKey:@"enddate"],[dictObject valueForKey:@"treatment"],[dictObject valueForKey:@"note"],[dictObject valueForKey:@"rowid"]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(void)deleteMDSTreatment:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM treatementInfo where trowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

//treatmentMedicineInfo" ("trowid" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "treatementid" INTEGER, "medicinename" VARCHAR, "dosage" VARCHAR, "days" VARCHAR)

-(NSMutableArray*)GetAllMDSTreatmentMedicine:(int)treatementId withType:(NSString *)type
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM treatmentMedicineInfo where treatementid like '%d' and type like '%@'",treatementId,type];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            MedicalObject *objMedicine=[[MedicalObject alloc]init];
            objMedicine.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objMedicine.strDrugName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objMedicine.strDosage =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objMedicine.strFrequency =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            objMedicine.strRefillFrequency =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            objMedicine.strNotes =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            objMedicine.strStartDate =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            objMedicine.strType =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
            objMedicine.strOtherTreatmentName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)];
            [arr addObject:objMedicine];
        }
    }
    return arr;
}

-(NSMutableArray*)GetAllOtherTreatment
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM treatmentMedicineInfo where type like 'T' "];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            MedicalObject *objMedicine=[[MedicalObject alloc]init];
            objMedicine.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objMedicine.strDrugName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objMedicine.strDosage =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objMedicine.strFrequency =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            objMedicine.strRefillFrequency =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            objMedicine.strNotes =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            objMedicine.strStartDate =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            objMedicine.strType =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
            objMedicine.strOtherTreatmentName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)];
            [arr addObject:objMedicine];
        }
    }
    return arr;
}


-(int)insertMDSTreatmentMedicine:(MedicalObject *)objMedicine
{
    int lastRowId=-1;
    
    NSString *query =[NSString stringWithFormat:@"INSERT INTO treatmentMedicineInfo (treatementid, medicinename, dosage, days,cyclenumber,notes,date,type,othertreatmentname) VALUES ( \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" ,\"%@\",\"%@\",\"%@\") ",objMedicine.strId,objMedicine.strDrugName,objMedicine.strDosage,objMedicine.strFrequency,objMedicine.strRefillFrequency,objMedicine.strNotes,objMedicine.strStartDate,objMedicine.strType,objMedicine.strOtherTreatmentName];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
        lastRowId = (int)sqlite3_last_insert_rowid(database);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}

-(int)insertMDSClinicalTrial:(MedicalObject *)objMedicine
{
    int lastRowId=-1;
    
    NSString *query =[NSString stringWithFormat:@"INSERT INTO clinicaltrial (treatementid, trial_number, name_of_trial,location) VALUES ( \"%@\", \"%@\", \"%@\", \"%@\") ",objMedicine.strId,objMedicine.strTrialNumber,objMedicine.strNameOfTrial,objMedicine.strLocation];
//    
//    NSString *query =[NSString stringWithFormat:@"INSERT INTO clinicaltrial (trial_number, name_of_trial, name_of_trial ) VALUES ( \"%@\", \"%@\", \"%@\") ",objMedicine.strLocation,objMedicine.strNameOfTrial,objMedicine.strTrialNumber];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
        lastRowId = (int)sqlite3_last_insert_rowid(database);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
    return lastRowId;
}

-(NSMutableArray*)GetAllMDSClinicalTrial:(int)treatementId
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM clinicaltrial where treatementid like '%d'" ,treatementId];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            MedicalObject *objMedicine=[[MedicalObject alloc]init];
            objMedicine.strId= [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objMedicine.strTrialNumber =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objMedicine.strNameOfTrial =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objMedicine.strLocation =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            [arr addObject:objMedicine];
        }
    }
    return arr;
}


-(void)deleteMDSTreatmentMedicine:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM treatmentMedicineInfo where treatementid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

-(void)deleteMDSClinicalTrial:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM clinicaltrial where treatementid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}


-(NSMutableArray*)GetAllMedicineName
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT drugname FROM MedicineInfo"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            [arr addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)]];
        }
    }
    return arr;
}

// bonemarrowResult" ("browid" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "date" VARCHAR, "marrowblast" VARCHAR, "description" VARCHAR, "notes" VARCHAR)


-(NSMutableArray*)GetAllBoneMarrowResult
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM bonemarrowResult ORDER BY browid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            int rowid=sqlite3_column_int(compiledStatement, 0);
            [dictObject setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"date"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"boneblast"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"description"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)] forKey:@"notes"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)] forKey:@"boneimages"];
            
            [arr addObject:dictObject];
        }
    }
    return arr;
}

-(int)insertBoneMarrowResult:(NSMutableDictionary *)dictObject
{
    int lastRowId = -1;
    NSString *query =[NSString stringWithFormat:@"INSERT INTO bonemarrowResult (date, marrowblast, description, notes,boneimages) VALUES (\"%@\", \"%@\", \"%@\" ,\"%@\" ,\"%@\") ",[dictObject valueForKey:@"date"],[dictObject valueForKey:@"boneblast"],[dictObject valueForKey:@"description"],[dictObject valueForKey:@"notes"],[dictObject valueForKey:@"boneimages"]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
            lastRowId = (int)sqlite3_last_insert_rowid(database);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        
    }
    return lastRowId;
}


-(BOOL)updateBoneMarrowResult:(NSMutableDictionary *)dictObject
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  bonemarrowResult SET date = '%@',  marrowblast ='%@', description = '%@', notes = '%@' , boneimages = '%@'  Where browid ='%@'",[dictObject valueForKey:@"date"],[dictObject valueForKey:@"boneblast"],[dictObject valueForKey:@"description"],[dictObject valueForKey:@"notes"],[dictObject valueForKey:@"boneimages"],[dictObject valueForKey:@"rowid"]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(void)deleteBoneMarrowResult:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM bonemarrowResult where browid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

//medicalprovider" ("mrowid" INTEGER PRIMARY KEY  AUTOINCREMENT , "providername" VARCHAR, "providerspeciality" VARCHAR, "referredby" VARCHAR, "address" VARCHAR, "phone" VARCHAR, "fax" VARCHAR, "email" VARCHAR)

-(NSMutableArray*)GetAllMedicalProvider
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM medicalprovider ORDER BY mrowid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            int rowid=sqlite3_column_int(compiledStatement, 0);
            [dictObject setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"name"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"speciality"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"reference"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)] forKey:@"address"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)] forKey:@"phone"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)] forKey:@"fax"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)] forKey:@"mail"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)] forKey:@"countrycode"];
            [arr addObject:dictObject];
        }
    }
    return arr;
}
-(NSMutableArray*)GetAllMedicalProvidersName
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT providername FROM medicalprovider"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            [arr addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)]];
        }
    }
    return arr;
}


-(void)insertMedicalProvider:(NSMutableDictionary *)dictObject
{
    NSString *query =[NSString stringWithFormat:@"INSERT INTO medicalprovider (providername,providerspeciality,referredby,address,phone,fax,email,countrycode) VALUES (\"%@\",\"%@\",\"%@\",\"%@\", \"%@\", \"%@\" ,\"%@\" ,\"%@\") ",[dictObject valueForKey:@"name"],[dictObject valueForKey:@"speciality"],[dictObject valueForKey:@"reference"],[dictObject valueForKey:@"address"],[dictObject valueForKey:@"phone"],[dictObject valueForKey:@"fax"],[dictObject valueForKey:@"mail"],[dictObject valueForKey:@"countrycode"]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
}


-(BOOL)updateMedicalProvider:(NSMutableDictionary *)dictObject
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  medicalprovider SET providername = '%@',  providerspeciality ='%@', referredby = '%@',  address = '%@', phone = '%@', fax = '%@', email = '%@', countrycode = '%@' Where mrowid ='%@'",[dictObject valueForKey:@"name"],[dictObject valueForKey:@"speciality"],[dictObject valueForKey:@"reference"],[dictObject valueForKey:@"address"],[dictObject valueForKey:@"phone"],[dictObject valueForKey:@"fax"],[dictObject valueForKey:@"mail"],[dictObject valueForKey:@"countrycode"],[dictObject valueForKey:@"rowid"]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}
-(void)deleteMedicalProffetional:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM medicalprovider where rowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}
//symptorInfo" ("srowid" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "symptomname" VARCHAR, "severity" VARCHAR, "symptomdate" VARCHAR, "symptomtime" VARCHAR, "duration" VARCHAR, "frequency" VARCHAR, "notes" VARCHAR, "createdate" VARCHAR, "modifieddate" VARCHAR)

-(NSMutableArray*)getAllSymptomInfoList
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    
    //NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM symptorInfo ORDER BY date_to_order ASC"];
    //NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM symptorInfo ORDER BY srowid DESC"];
     NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM symptorInfo ORDER BY date_to_order DESC"];

    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            SymptomObject *objSymptom=[[SymptomObject alloc]init];
            objSymptom.strId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objSymptom.strSymptom=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objSymptom.strServirty=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objSymptom.strDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objSymptom.strTime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            objSymptom.strDuration=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            objSymptom.strFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            objSymptom.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            objSymptom.strSymptomSubCat=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
            //objSymptom.dateToOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,9)];
            
            [arr addObject:objSymptom];
        }
    }
    return arr;
}

-(void)insertSymptomInfoList:(SymptomObject *)object
{
    NSString *query =[NSString stringWithFormat:@"INSERT INTO symptorInfo (symptomname,severity,symptomdate,symptomtime,duration,frequency,notes,symptomSubCat,date_to_order) VALUES (\"%@\",\"%@\",\"%@\",\"%@\", \"%@\", \"%@\" ,\"%@\", \"%@\",\"%f\") ",object.strSymptom,object.strServirty,object.strDate,object.strTime,object.strDuration,object.strFrequency,object.strNotes,object.strSymptomSubCat,object.dateToOrder];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
}
-(BOOL)updateSymptomInfoList:(SymptomObject *)object
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  symptorInfo SET symptomname = '%@',  severity ='%@', symptomdate = '%@', symptomtime = '%@', duration = '%@', frequency = '%@', notes = '%@', symptomSubCat = '%@',date_to_order='%f' Where rowid ='%@'",object.strSymptom,object.strServirty,object.strDate,object.strTime,object.strDuration,object.strFrequency,object.strNotes,object.strSymptomSubCat,(double)object.dateToOrder,object.strId];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(void)deleteSymptom:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM symptorInfo where rowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

-(NSMutableArray*)getAllUniqueSymptomForChart
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
   
    NSString *queryString=[NSString stringWithFormat:@"SELECT distinct symptomSubCat  FROM symptorInfo ORDER BY date_to_order ASC"];
 
    
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            NSString *strValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            [arr addObject:strValue];
        }
    }
    return arr;
}

-(NSMutableArray*)getAllSymptomForParticularSymptom:(NSString *)strSymptom
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    
    // NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM symptorInfo where symptomSubCat = '%@' ORDER BY date_to_order ASC ",strSymptom];
    //NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM symptorInfo where symptomSubCat = '%@' ORDER BY srowid ASC",strSymptom];
    
     NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM symptorInfo where symptomSubCat = '%@' ORDER BY date_to_order ASC",strSymptom];
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            SymptomObject *objSymptom=[[SymptomObject alloc]init];
            objSymptom.strId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            objSymptom.strSymptom=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            objSymptom.strServirty=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            objSymptom.strDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            objSymptom.strTime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            objSymptom.strDuration=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
            objSymptom.strFrequency=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
            objSymptom.strNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,7)];
            objSymptom.strSymptomSubCat=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,8)];
            
            [arr addObject:objSymptom];
        }
    }
    return arr;
}


-(NSMutableArray*)GetIPSSRScore
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM ipssrscoreInfo ORDER BY irowid DESC"];
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            int rowid=sqlite3_column_int(compiledStatement, 0);
            [dictObject setValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"rowid"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"IPSSRDate"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"IPSSRSocre"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"IPSSRNotes"];
            
            [arr addObject:dictObject];
        }
    }
    return arr;
}
//ipssrscoreInfo" ("irowid" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "date" VARCHAR, "score" VARCHAR, "notes" VARCHAR)
-(void)insertIPSSRScore:(NSMutableDictionary *)dictObject
{
    NSString *query =[NSString stringWithFormat:@"INSERT INTO ipssrscoreInfo (date,score,notes) VALUES (\"%@\",\"%@\", \"%@\") ",[dictObject valueForKey:@"IPSSRDate"],[dictObject valueForKey:@"IPSSRSocre"],[dictObject valueForKey:@"IPSSRNotes"]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
}
-(BOOL)updateIPSSRScore:(NSMutableDictionary *)dictObject
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  ipssrscoreInfo SET date = '%@',  score ='%@', notes = '%@' Where irowid ='%@'",[dictObject valueForKey:@"IPSSRDate"],[dictObject valueForKey:@"IPSSRSocre"],[dictObject valueForKey:@"IPSSRNotes"],[dictObject valueForKey:@"rowid"]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(void)deleteIPSSRScore:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM ipssrscoreInfo where irowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}

//CREATE TABLE "transfusioninfo" ("trowid" INTEGER, "date" VARCHAR, "ttype" VARCHAR, "unit" VARCHAR)

-(NSMutableArray*)GetAllTransfusion
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    //NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM transfusioninfo ORDER BY trowid DESC"];
    NSString *queryString=[NSString stringWithFormat:@"SELECT * FROM transfusioninfo ORDER BY date_to_order DESC"];
    
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictNotes=[[NSMutableDictionary alloc]init];
            [dictNotes setValue:[NSString stringWithFormat:@"%d",sqlite3_column_int(compiledStatement,0)] forKey:@"rowid"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"date"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] forKey:@"type"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] forKey:@"unit"];
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)] forKey:@"date_to_order"];
            
            [dictNotes setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)] forKey:@"bloodtype"];
            
            //to handle null return
            
            NSString *nullChecker=[dictNotes objectForKey:@"date_to_order"];
            if ([nullChecker isEqualToString:@"(null)"] || [nullChecker isEqualToString:@"0.0"])
            {
                
                NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
                NSDate *dateFromString;
                
                NSDateFormatter *dt1=[[NSDateFormatter alloc]init];
                [dt1 setDateFormat:@"MMM dd,yyyy"];
                if ([nullChecker isEqualToString:@"0.0"])
                {
                     [dateformater setDateFormat:@"MMM dd yyyy"];
                    dateFromString=[dateformater dateFromString:[dictNotes objectForKey:@"date"]];
                    
                    [dictNotes setValue:[NSString stringWithFormat:@"%@",[dt1 stringFromDate:dateFromString]] forKey:@"date"];
                    
                }
                else if ([nullChecker isEqualToString:@"(null)"])
                {
                    [dateformater setDateFormat:@"MMM dd,yyyy"];
                    dateFromString=[dateformater dateFromString:[dictNotes objectForKey:@"date"]];
                    
                    
                    [dictNotes setValue:[NSString stringWithFormat:@"%@",[dt1 stringFromDate:dateFromString]] forKey:@"date"];
                }
                
                double DateInDouble=[dateFromString timeIntervalSince1970];
                [dictNotes setValue:[NSNumber numberWithDouble:DateInDouble] forKey:@"date_to_order"];
                 NSString *nullChecker1=[dictNotes objectForKey:@"date_to_order"];
                NSLog(@"testing null  %@",nullChecker1);
                
                [App_Delegate.dbObj updatetTransfusion:dictNotes];
            }
            
            [arr addObject:dictNotes];
        }
    }
    return arr;
}

-(void)insertTransfusion:(NSMutableDictionary *)dictTransfusion
{
    
    NSString *query =[NSString stringWithFormat:@"INSERT INTO transfusioninfo (date,ttype,unit,date_to_order,blood_type) VALUES (\"%@\", \"%@\", \"%@\",\"%@\" ,\"%@\") ",[dictTransfusion valueForKey:@"date"],[dictTransfusion valueForKey:@"type"],[dictTransfusion valueForKey:@"unit"],[dictTransfusion valueForKey:@"date_to_order"],[dictTransfusion valueForKey:@"bloodtype"]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
}
//CREATE TABLE "transfusioninfo" ("trowid" INTEGER, "date" VARCHAR, "ttype" VARCHAR, "unit" VARCHAR)

-(BOOL)updatetTransfusion:(NSMutableDictionary *)dictTransfusion
{
    NSString *query =  [NSString stringWithFormat:@"UPDATE  transfusioninfo SET date = '%@',  ttype ='%@', unit = '%@' , date_to_order = '%@' , blood_type = '%@'  Where rowid ='%@'",[dictTransfusion valueForKey:@"date"],[dictTransfusion valueForKey:@"type"],[dictTransfusion valueForKey:@"unit"],[dictTransfusion valueForKey:@"date_to_order"],[dictTransfusion valueForKey:@"bloodtype"],[dictTransfusion valueForKey:@"rowid"]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
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
        NSLog(@"error: %s", sqlite3_errmsg(database));
        return NO;
    }
}

-(void)deleteTransfusion:(NSString *)forRow
{
    NSString *queryString3 = [NSString stringWithFormat:@"delete FROM transfusioninfo where rowid = %@",forRow];
    const char *insertSql3 = [queryString3  cStringUsingEncoding:NSUTF8StringEncoding];
    // delete FROM tbl_FriendList
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, insertSql3, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE)
    {
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"Row Deleted!!!:");
    }
}
-(NSMutableArray*)getAllTransusionForParticularBlood:(NSString *)strBloodCount
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    // NSString *queryString=[NSString stringWithFormat:@"SELECT date, unit FROM transfusioninfo where ttype LIKE  '%@' ORDER BY date_to_order ASC",strBloodCount];
     //NSString *queryString=[NSString stringWithFormat:@"SELECT date, unit FROM transfusioninfo where ttype LIKE  '%@' ORDER BY trowid ASC",strBloodCount];
    NSString *queryString=[NSString stringWithFormat:@"SELECT date, unit FROM transfusioninfo where ttype LIKE  '%@' ORDER BY date_to_order ASC",strBloodCount];
    
    
    const char *sqlSelect = [queryString UTF8String];
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) != SQLITE_OK)
    {
        
        NSLog(@"Error Occured:'%s'",sqlite3_errmsg(database));
        
    }
    else if(sqlite3_prepare_v2(database, sqlSelect, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dictObject=[[NSMutableDictionary alloc]init];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)] forKey:@"date"];
            [dictObject setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"value"];
            
            
            [arr addObject:dictObject];
        }
    }
    return arr;
}

-(void)InsertuserInfo:(NSMutableDictionary *)dictUser
{
    /*
    NSString *query =[NSString stringWithFormat:@"INSERT INTO userInfo (dob,gender,zipcode) VALUES (\"%@\", \"%@\", \"%@\") ",[dictUser valueForKey:@"date"],[dictUser valueForKey:@"type"],[dictUser valueForKey:@"unit"]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
        else
        {
            NSLog(@"updateContact SUCCESS - executed command %@",query);
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
    }
     */
    NSString *query =  [NSString stringWithFormat:@"UPDATE  userInfo SET dob = '%@',  gender ='%@', zipcode = '%@' Where rowid ='1'",[dictUser valueForKey:@"dob"],[dictUser valueForKey:@"gender"],[dictUser valueForKey:@"zipcode"]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK)
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
           
        }
        else
        {
            NSLog(@"update UserInfo SUCCESS - executed command %@",query);
           
        }
        //  sqlite3_reset(statement);
        //  sqlite3_step(statement);
        //  sqlite3_finalize(statement);
        
        // sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));
        
    }

}


@end

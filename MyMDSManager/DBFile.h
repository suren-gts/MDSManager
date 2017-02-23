
//  DBFile.h
//  Italic

//  Created by FOX-MAC-M on 29/03/14.
//  Copyright (c) 2014 fox. All rights reserved.


#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "MedicalObject.h"
#import "DiagnosisObject.h"
#import "LabResultObject.h"
#import "InsuranceCompanyObject.h"
#import "AppointementObject.h"
#import "SymptomObject.h"

static sqlite3 *database;

@interface DBFile : NSObject
{
    NSDateFormatter *formatter;
}

-(id)initWith;
-(NSMutableArray*)getAllDiagnosis;
-(void)insertDiagnosisHistory:(DiagnosisObject *)objDiagonsis;
-(NSMutableArray*)getAllSurgery;
-(void)insertSurgicalHistory:(DiagnosisObject *)objDiagonsis;
-(void)deleteMedicalHistory:(NSString *)forRow;

-(NSMutableArray*)getAllBloodCellOnGoingLabResult;
-(NSMutableArray*)getAllBloodCellInitialLabResult;
-(int)insertBloodCellOnGoingLabResult:(LabResultObject *)objLab;
-(int)insertBloodCellInitialLabResult:(LabResultObject *)objLab;

-(NSMutableArray*)getAllCurrentMedicines:(NSString *)strValue;;
-(NSMutableArray*)getAllPreviousMedicines:(NSString *)strValue;
-(int)insertMedicine:(MedicalObject *)objMedicine;
-(BOOL)updateMedicine:(MedicalObject *)objMedicine;
-(void)deleteMedicine:(NSString *)forRow;


-(NSMutableArray*)getInsuranceDetail;
-(BOOL)updateInsuranceDetail:(InsuranceCompanyObject *)objInsurance;

-(NSMutableArray*)GetTodaysAppointments:(NSDate *)forDate;
-(NSMutableArray*)GetAllCurrentAppointments;
//-(NSMutableArray*)GetAllPreviousAppointments;
-(int)insertAppointments:(AppointementObject *)objAppoint;
-(BOOL)updateAppointments:(AppointementObject *)objAppoint;
-(NSMutableDictionary *)GetAppointmentForCalaenderEvent;
-(void)deleteAppointment:(NSString *)forRow;
-(void)deleteBoneMarrowResult:(NSString *)forRow;

-(BOOL)updateInitialLabReuslts:(LabResultObject *)objLab; //update BloodCount & Diagnosis Test
-(BOOL)updateMedicalHistory:(DiagnosisObject *)objDiagonsis; //update Diagnosis & Surgery
-(void)deleteInitialLabReuslts:(NSString *)forRow;

-(NSMutableArray*)getAllSymptom:(NSString *)strCat;
-(void)createSymptom:(NSString *)strSymptom withDescription:(NSString *)strDesc;
-(NSMutableArray*)getAllSymptomWithId;
-(void)deleteUserCreateSymptom:(NSString *)forRow;

-(NSMutableArray*)GetAllNotes;
-(void)insertNotes:(NSMutableDictionary *)dictNotes;
-(BOOL)updatetNotes:(NSMutableDictionary *)dictNotes;
-(void)deleteNotes:(NSString *)forRow;

-(NSMutableArray*)GetAllBoneMarrowResult;
-(int)insertBoneMarrowResult:(NSMutableDictionary *)dictObject;
-(BOOL)updateBoneMarrowResult:(NSMutableDictionary *)dictObject;

-(NSMutableArray*)GetAllMDSTreatment;
-(int)insertMDSTreatment:(NSMutableDictionary *)dictObject;
-(BOOL)updateMDSTreatment:(NSMutableDictionary *)dictObject;
-(void)deleteMDSTreatment:(NSString *)forRow;

-(NSMutableArray*)GetAllBloodCountResult;
-(int)insertBloodCountResult:(NSMutableDictionary *)dictObject;
-(BOOL)updateBloodCountResult:(NSMutableDictionary *)dictObject;
-(void)deleteBloodCountResult:(NSString *)forRow;
-(NSMutableArray*)getAllBloodCountForParticularBlood:(NSString *)strBloodCount;

-(NSMutableArray*)GetAllMedicalProvider;
-(NSMutableArray*)GetAllMedicalProvidersName;
-(void)insertMedicalProvider:(NSMutableDictionary *)dictObject;
-(BOOL)updateMedicalProvider:(NSMutableDictionary *)dictObject;
-(void)deleteMedicalProffetional:(NSString *)forRow;


-(NSMutableArray*)getAllSymptomInfoList;
-(void)insertSymptomInfoList:(SymptomObject *)object;
-(BOOL)updateSymptomInfoList:(SymptomObject *)object;
-(void)deleteSymptom:(NSString *)forRow;
-(NSMutableArray*)getAllUniqueSymptomForChart;
-(NSMutableArray*)getAllSymptomForParticularSymptom:(NSString *)strSymptom;

-(NSMutableArray*)getSymptomInfoListForFilter:(NSString *)strFilter;
-(NSMutableArray*)getMedicinesForFilter:(NSString *)strFilter;
-(NSMutableArray*)GetAllMedicalProviderForFilter:(NSString *)strFilter;
-(NSMutableArray*)GetAllNotesForFilter:(NSString *)strFilter;

-(NSMutableArray*)GetAllMedicineName;
-(int)insertMDSTreatmentMedicine:(MedicalObject *)objMedicine;
-(NSMutableArray*)GetAllMDSTreatmentMedicine:(int)treatementId withType:(NSString *)type;
-(void)deleteMDSTreatmentMedicine:(NSString *)forRow;

-(int)insertOtherResult:(NSMutableDictionary *)dictObject;
-(NSMutableArray*)GetOtherLabResult:(NSInteger)forRowid;

-(NSMutableArray*)GetIPSSRScore;
-(void)insertIPSSRScore:(NSMutableDictionary *)dictObject;
-(BOOL)updateIPSSRScore:(NSMutableDictionary *)dictObject;
-(void)deleteIPSSRScore:(NSString *)forRow;

-(void)deleteTransfusion:(NSString *)forRow;
-(BOOL)updatetTransfusion:(NSMutableDictionary *)dictTransfusion;
-(void)insertTransfusion:(NSMutableDictionary *)dictTransfusion;
-(NSMutableArray*)GetAllTransfusion;
-(NSMutableArray*)getAllTransusionForParticularBlood:(NSString *)strBloodCount;

-(void)InsertuserInfo:(NSMutableDictionary *)dictUser;


//Chanchal add clinical trial methods

-(int)insertMDSClinicalTrial:(MedicalObject *)objMedicine;
-(NSMutableArray*)GetAllMDSClinicalTrial:(int)treatementId;
-(void)deleteMDSClinicalTrial:(NSString *)forRow;
-(NSMutableArray*)GetAllOtherTreatment;


@end


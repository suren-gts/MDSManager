//
//  ContentPickerVC.m
//  MyMDSManager
//
//  Created by CEPL on 04/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "ContentPickerVC.h"


@interface ContentPickerVC ()

@end

@implementation ContentPickerVC

@synthesize valueDelegate,arrPikerContent;
@synthesize rowId,sectionId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.EntryTag==ProfileScreen)
    {
        if (self.rowId==2)
        {
            arrPikerContent=[[NSMutableArray alloc]init];
            arrPikerContent2=[[NSMutableArray alloc]init];
            for (int i=0; i<11; i++)
            {
                [arrPikerContent addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            for (int i=0; i<12; i++)
            {
                [arrPikerContent2 addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            [pickerView reloadAllComponents];
            
            return;
        }
        else if (self.rowId==3)
        {
            arrPikerContent=[[NSMutableArray alloc]init];
            for (int i=1; i<301; i++)
            {
                [arrPikerContent addObject:[NSString stringWithFormat:@"%d",i]];
                
            }
            [arrPikerContent addObject:@"+"];
            
            [pickerView reloadAllComponents];
            
            return;
        }
        else if (self.rowId==4)
        {
            if ([App_Delegate.dictPrePopulated objectForKey:@"marital_status"])
            {
                arrPikerContent=[[App_Delegate.dictPrePopulated objectForKey:@"marital_status"]mutableCopy];
            }
            else
            {
                arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"marital_status"] mutableCopy];
            }
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MaritalState"])
            {
                NSMutableArray *arrLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"MaritalState"];
                for (int i=0; i<arrLocal.count; i++)
                {
                    [arrPikerContent addObject:[arrLocal objectAtIndex:i]];
                }
            }
            
            arrPikerContent = [self SortArray:arrPikerContent];
            
            [arrPikerContent addObject:@"Other"];
        }
        else if (self.rowId==5)
        {
            if ([App_Delegate.dictPrePopulated objectForKey:@"living_status"])
            {
                arrPikerContent=[[App_Delegate.dictPrePopulated objectForKey:@"living_status"] mutableCopy];
            }
            else
            {
                arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"living_status"] mutableCopy];
            }
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LivingState"])
            {
                NSMutableArray *arrLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"LivingState"];
                for (int i=0; i<arrLocal.count; i++)
                {
                    [arrPikerContent addObject:[arrLocal objectAtIndex:i]];
                }
            }
            
            arrPikerContent = [self SortArray:arrPikerContent];

            [arrPikerContent addObject:@"Other"];
        }
    }
    else if (self.EntryTag==InitialLabResult)
    {
        if (self.rowId==0)
        {
            arrPikerContent=[[NSMutableArray alloc]initWithArray:[App_Delegate.dictTest allKeys]];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisTest"])
            {
                NSMutableArray *arrLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisTest"];
                for (int i=0; i<arrLocal.count; i++)
                {
                    [arrPikerContent addObject:[arrLocal objectAtIndex:i]];
                }
            }
            
            arrPikerContent = [self SortArray:arrPikerContent];

            [arrPikerContent addObject:@"Other"];
        }
        else
        {
            if ([App_Delegate.dictPrePopulated valueForKey:@"units"])
            {
                arrPikerContent=[[App_Delegate.dictPrePopulated objectForKey:@"units"] mutableCopy];
            }
            else
            {
                arrPikerContent = [[NSMutableArray alloc] initWithObjects:@"mm3",@"gm/dL",@"lu/ml",@"mcg/ml",@"ng/ml",@"pg/ml", nil];
            }
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisUnits"])
            {
                NSMutableArray *arrLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisUnits"];
                for (int i=0; i<arrLocal.count; i++)
                {
                    [arrPikerContent addObject:[arrLocal objectAtIndex:i]];
                }
            }
            
            arrPikerContent = [self SortArray:arrPikerContent];

        }
    }
    else if (self.EntryTag==SymptomTracker)
    {
        if (self.rowId==0)
        {
            arrPikerContent = [[NSMutableArray alloc] initWithObjects:@"Symptoms",@"Practical Problems", nil];
        }

        if (self.rowId==1)
        {
            if ([App_Delegate.strSymptomCat isEqualToString:@"Symptoms"])
            {
                if ([App_Delegate.dictPrePopulated valueForKey:@"symptom"])
                {
                    arrPikerContent=[[App_Delegate.dictPrePopulated objectForKey:@"symptom"] mutableCopy];
                }
                else
                {
                    arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"symptom"] mutableCopy];
                }
                [arrPikerContent addObjectsFromArray:[App_Delegate.dbObj getAllSymptom:App_Delegate.strSymptomCat]];
                
            }
            else
            {
                if ([App_Delegate.dictPrePopulated valueForKey:@"practical_problems"])
                {
                    arrPikerContent=[[App_Delegate.dictPrePopulated objectForKey:@"practical_problems"] mutableCopy];
                }
                else
                {
                    arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"practical_problems"] mutableCopy];
                }
                [arrPikerContent addObjectsFromArray:[App_Delegate.dbObj getAllSymptom:App_Delegate.strSymptomCat]];
            }
            
            arrPikerContent = [self SortArray:arrPikerContent];

            [arrPikerContent addObject:@"Other"];
        }
        else if (self.rowId==4)
        {
            arrPikerContent=[[NSMutableArray alloc]init];
            for (int i=1; i<50; i++)
            {
                [arrPikerContent addObject:[NSString stringWithFormat:@"%d",i]];
            }
            arrPikerContent2=[[NSMutableArray alloc]initWithObjects:@"Minutes",@"Hours",@"Days",@"Weeks",@"Months",@"Years", nil];
            
            [pickerView reloadAllComponents];
            
            return;
        }
        else if (self.rowId==5)
        {
            arrPikerContent=[[NSMutableArray alloc]init];
            for (int i=1; i<50; i++)
            {
                [arrPikerContent addObject:[NSString stringWithFormat:@"%d",i]];
            }
            arrPikerContent2=[[NSMutableArray alloc]initWithObjects:@"times per minute",@"times per hour",@"times per day",@"times per week",@"times per month",@"times per year", nil];
            
            [pickerView reloadAllComponents];
            
            return;
        }
    }
    else if (self.EntryTag==AddMedicine)
    {
        if (self.rowId==0)
        {
            arrPikerContent=[[NSMutableArray alloc]initWithObjects:@"Prescription",@"Over-the-Counter",@"Supplements/Other", nil ];
        }
        else if(self.rowId==4)
        {
            if ([App_Delegate.dictPrePopulated valueForKey:@"frequency"])
            {
                arrPikerContent=[App_Delegate.dictPrePopulated objectForKey:@"frequency"];
            }
            else
            {
                arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"frequency"] mutableCopy];
            }
            
        }
        else if(self.rowId==9)
        {
            if ([App_Delegate.dictPrePopulated valueForKey:@"refill_frequency"])
            {
                arrPikerContent=[App_Delegate.dictPrePopulated objectForKey:@"refill_frequency"];
            }
            else
            {
                arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"refill_frequency"] mutableCopy];
            }
        }
        
        arrPikerContent = [self SortArray:arrPikerContent];

        
    }
    else if (self.EntryTag==Insurance)
    {
         arrPikerContent=[[NSMutableArray alloc]initWithObjects:@"Self",@"Spouse",@"Parent", nil ];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if (self.EntryTag==AddBoneMerrow)
    {
        arrPikerContent=[[NSMutableArray alloc]initWithObjects:@"< 1%",@"1%",@"2%",@"3%",@"5%",@"10%",@"15%",@"20%",@">20%", nil ];
        
        [pickerView reloadAllComponents];

        return;
    }
    else if (self.EntryTag==ManagingProvider)
    {
        arrPikerContent=[App_Delegate.dbObj GetAllMedicalProvidersName];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if(self.EntryTag==AddTreatmentMedicine)
    {
        arrPikerContent=[App_Delegate.dbObj GetAllMedicineName];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if(self.EntryTag==ReminderSound)
    {
        mymusicPlayer=[[MusicePlayerClass alloc]init];
        arrPikerContent=[[NSMutableArray alloc]initWithObjects:@"Default",@"Attention",@"Frenzy",@"Gentlealarm",@"Jingle bell",@"Msg posted",@"Soft play once", nil ];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if (self.EntryTag==Transfusion)
    {
         arrPikerContent=[[NSMutableArray alloc]initWithObjects:@"A+",@"A-",@"B+",@"B-",@"Ab+",@"AB-",@"O+",@"O-", nil ];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if(self.EntryTag == MedicalHistoryDiagnosis)
    {
        if ([App_Delegate.dictPrePopulated valueForKey:@"medical_diagnosis"])
        {
            arrPikerContent=[[App_Delegate.dictPrePopulated objectForKey:@"medical_diagnosis"] mutableCopy];
        }
        else
        {
            arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"medical_diagnosis"] mutableCopy];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OtherMedicalDiagnosis"])
        {
            NSMutableArray *arrLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"OtherMedicalDiagnosis"];
            for (int i=0; i<arrLocal.count; i++)
            {
                [arrPikerContent addObject:[arrLocal objectAtIndex:i]];
            }
        }
        
        arrPikerContent = [self SortArray:arrPikerContent];

        [arrPikerContent addObject:@"Other"];
    }
    else if (self.EntryTag == TreatmentServerList)
    {
        if ([App_Delegate.dictPrePopulated valueForKey:@"mds_treatment_medine"])
        {
            arrPikerContent=[[App_Delegate.dictPrePopulated objectForKey:@"mds_treatment_medine"] mutableCopy];
        }
        else
        {
            arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"mds_treatment_medine"] mutableCopy];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Other_mds_treatment_medine"])
        {
            NSMutableArray *arrLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"Other_mds_treatment_medine"];
            for (int i=0; i<arrLocal.count; i++)
            {
                [arrPikerContent addObject:[arrLocal objectAtIndex:i]];
            }
        }
        
        arrPikerContent = [self SortArray:arrPikerContent];

        [arrPikerContent addObject:@"Other"];
    }
    else if (self.EntryTag == SymptomListTag)
    {
        arrPikerContent=[App_Delegate.dbObj getAllUniqueSymptomForChart];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if (self.EntryTag == CountryPhoneCode)
    {
        arrPikerContent=[App_Delegate.arrCountryPhoneCode mutableCopy];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if (self.EntryTag == BloodCountTag)
    {
        arrPikerContent=[[NSMutableArray alloc]initWithObjects:@"HGB",@"WBC",@"ANC",@"PLATELETS",@"FERRITIN", nil];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if (self.EntryTag == TransfusionTag)
    {
        arrPikerContent=[[NSMutableArray alloc]initWithObjects:@"PRBCs",@"PLATELETS",nil];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    else if (self.EntryTag == AddTreatment) //Add MDS Treatment
    {
        NSMutableArray *arrOthers =[App_Delegate.dbObj GetAllOtherTreatment];
        
        NSMutableArray *arrDropDown = [[NSMutableArray alloc] initWithObjects:@"MDS Treatment",@"Clinical Trial", nil];
        
        /*
        for (int i=0;i<arrOthers.count; i++)
        {
            MedicalObject *obj = [arrOthers objectAtIndex:i];
            
            [arrDropDown addObject:obj.strOtherTreatmentName];
        }
        */
        arrDropDown = [self SortArray:arrDropDown];
        
        [arrDropDown addObject:@"Other"];

        arrPikerContent = arrDropDown;
        
    }
    else if (self.EntryTag == Suregery)
    {
        arrPikerContent=[[[NSUserDefaults standardUserDefaults]objectForKey:@"medical_surgery"] mutableCopy];
        
        arrPikerContent = [self SortArray:arrPikerContent];

    }
    
    
    /*
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [arrPikerContent sortedArrayUsingDescriptors:sortDescriptors];
    
    arrPikerContent = [sortedArray mutableCopy];
    */
    
    [pickerView reloadAllComponents];
    
}

-(NSMutableArray *)SortArray : (NSMutableArray *)arrActualList
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [arrActualList sortedArrayUsingDescriptors:sortDescriptors];
    
    arrActualList = [sortedArray mutableCopy];
    
    return arrActualList ;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (App_Delegate.isNewAddedInList == YES)
    {
        App_Delegate.isNewAddedInList =NO;
        selectedRowForComonent1 = arrPikerContent.count-2;
        [pickerView selectRow:selectedRowForComonent1 inComponent:0 animated:YES];
    }
    else
    {
        [pickerView selectRow:0 inComponent:0 animated:YES];
        [pickerView reloadComponent:0];
    }
   
}


- (IBAction)performDone:(id)sender
{
    
    if (mymusicPlayer)
    {
        [mymusicPlayer stopSound];
    }
    
    if(self.valueDelegate && [(id) self.valueDelegate respondsToSelector:@selector(didSelectValueFromPicker: withValue: forSection:andForRow:)])
    {
        if (self.EntryTag==ProfileScreen)
        {
            if (self.rowId==2)
            {
                NSString *strValue=[NSString stringWithFormat:@"%@,%@",[arrPikerContent objectAtIndex:selectedRowForComonent1],[arrPikerContent2 objectAtIndex:selectedRowForComonent2]];
                [self.valueDelegate didSelectValueFromPicker:selectedRowForComonent1 withValue:strValue forSection:self.sectionId andForRow:self.rowId];
                
            }
            else
            {
                [self.valueDelegate didSelectValueFromPicker:selectedRowForComonent1 withValue:[arrPikerContent objectAtIndex:selectedRowForComonent1] forSection:self.sectionId andForRow:self.rowId];
            }
        }
        else if (self.EntryTag==SymptomTracker)
        {
            if (self.rowId==0 || self.rowId==1)
            {
                [self.valueDelegate didSelectValueFromPicker:selectedRowForComonent1 withValue:[arrPikerContent objectAtIndex:selectedRowForComonent1] forSection:self.sectionId andForRow:self.rowId];

            }
            else if (self.rowId==4)
            {
                NSString *strValue=[NSString stringWithFormat:@"%@ %@",[arrPikerContent objectAtIndex:selectedRowForComonent1],[arrPikerContent2 objectAtIndex:selectedRowForComonent2]];
                [self.valueDelegate didSelectValueFromPicker:selectedRowForComonent1 withValue:strValue forSection:self.sectionId andForRow:self.rowId];
            }
            else if (self.rowId==5)
            {
                NSString *strValue=[NSString stringWithFormat:@"%@ %@",[arrPikerContent objectAtIndex:selectedRowForComonent1],[arrPikerContent2 objectAtIndex:selectedRowForComonent2]];
                [self.valueDelegate didSelectValueFromPicker:selectedRowForComonent1 withValue:strValue forSection:self.sectionId andForRow:self.rowId];
            }
        }
        else if (self.EntryTag==MedicalHistoryDiagnosis)
        {
             [self.valueDelegate didSelectValueFromPicker:self.EntryTag withValue:[arrPikerContent objectAtIndex:selectedRowForComonent1] forSection:self.sectionId andForRow:self.rowId];
        }
        else if (self.EntryTag== Suregery)
        {
            [self.valueDelegate didSelectValueFromPicker:self.EntryTag withValue:[arrPikerContent objectAtIndex:selectedRowForComonent1] forSection:self.sectionId andForRow:self.rowId];
        }
        else if (self.EntryTag==CountryPhoneCode)
        {
            [self.valueDelegate didSelectValueFromPicker:selectedRowForComonent1 withValue:@"" forSection:self.sectionId andForRow:self.rowId];
        }
        else
        {
            [self.valueDelegate didSelectValueFromPicker:selectedRowForComonent1 withValue:[arrPikerContent objectAtIndex:selectedRowForComonent1] forSection:self.sectionId andForRow:self.rowId];
            
        }
    }

    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.view removeFromSuperview];
                     }];
    
    
}


- (IBAction)performCancel:(id)sender
{
    if (mymusicPlayer)
    {
        [mymusicPlayer stopSound];
    }
    if(self.valueDelegate && [(id) self.valueDelegate respondsToSelector:@selector(didCancelPicker)])
    {
        [self.valueDelegate didCancelPicker];
    }
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.view removeFromSuperview];
                     }];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.EntryTag==0)
    {
        if (self.rowId==2)
        {
            return 2;
        }
        return 1;
    }
    else if(self.EntryTag==SymptomTracker)
    {
        if (self.rowId==0 || self.rowId==1)
        {
            return 1;
        }
        return 2;
    }
    else
    {
        return 1;
    }
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.EntryTag==0)
    {
        if (self.rowId==2)
        {
            if (component==0)
            {
                return arrPikerContent.count;
            }
            else
            {
                return arrPikerContent2.count;
            }
        }
        
    }
    else if(self.EntryTag==SymptomTracker)
    {
        if (self.rowId==0)
        {
            return arrPikerContent.count;
        }
        if (self.rowId==1)
        {
            return arrPikerContent.count;
        }
        else
        {
            if (component==0)
            {
                return arrPikerContent.count;
            }
            else
            {
                return arrPikerContent2.count;
            }
        }
        
    }
    return arrPikerContent.count;
    
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (self.EntryTag==ProfileScreen)
    {
        if (component==0)
        {
            NSString *str=@"";
            str=[arrPikerContent objectAtIndex:row];
            if (self.rowId==2)
            {
                str=[NSString stringWithFormat:@"%@ feet",str];
            }
            else if (self.rowId==3)
            {
                if (![str isEqualToString:@"+"])
                {
                    str=[NSString stringWithFormat:@"%@ lbs",str];    
                }
                
            }
            return str;
        }
        else
        {
            NSString *str=@"";
            str=[arrPikerContent2 objectAtIndex:row];
            if (self.rowId==2)
            {
                str=[NSString stringWithFormat:@"%@ Inch",str];
            }
            return str;
            
        }
    }
    else if (self.EntryTag==SymptomTracker)
    {
        if (self.rowId==0)
        {
            NSString *str=@"";
            str=[arrPikerContent objectAtIndex:row];
            return str;
        }
        if (self.rowId==1)
        {
            NSString *str=@"";
            str=[arrPikerContent objectAtIndex:row];
            return str;
        }
        else
        {
            if (component==0)
            {
                NSString *str=@"";
                str=[arrPikerContent objectAtIndex:row];
                return str;
            }
            else
            {
                NSString *str=@"";
                str=[arrPikerContent2 objectAtIndex:row];
                return str;
                
            }
        }
    }
    else if (self.EntryTag==CountryPhoneCode)
    {
        NSString *str=@"";
        NSMutableDictionary *dictValue = [arrPikerContent objectAtIndex:row];
        str = [dictValue valueForKey:@"CountryName"];
        return str;
    }
    else
    {
        NSString *str=@"";
        str=[arrPikerContent objectAtIndex:row];
        return str;
    }
    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if (component==0)
    {
        selectedRowForComonent1=row;
    }
    else
    {
        selectedRowForComonent2=row;
    }
    if (self.EntryTag == ReminderSound)
    {
        if (selectedRowForComonent1>0)
        {
            NSString *strSound = [App_Delegate.arrSoundFiles objectAtIndex:selectedRowForComonent1-1];
            NSLog(@"soundFile: %@",strSound);
            [mymusicPlayer configureAudioPlayer:strSound];
            [mymusicPlayer tryPlayMusic];
        }
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end



//  AddMDSTreatmentVC.m
//  MyMDSManager

//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "AddMDSTreatmentVC.h"
#import "AddNotesCell.h"
#import "ProfileContentDisplayCell.h"
#import "SymptomButtonCell.h"
#import "ThreeLableContentCell.h"
#import "ThreeLableHeaderCell.h"
#import "ButtonCell.h"
#import "AddTreatementMedicinVC.h"
#import "AddClinicalTrialVC.h"


@interface AddMDSTreatmentVC ()

@end

@implementation AddMDSTreatmentVC


#define AlertConfirmTag 112

@synthesize editFlag,dictTreatment;

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    //Add done button on keyboard
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    
    if (!self.dictTreatment)
    {
        self.dictTreatment=[[NSMutableDictionary alloc]init];
    }
    
    if (self.editFlag==0)
    {
        lblPageTitle.text=@"ADD TREATMENTS";
        App_Delegate.arrMDSTreatement = [[NSMutableArray alloc] init];
        
       
    }
    else
    {
        lblPageTitle.text=@"UPDATE TREATMENTS";
        App_Delegate.arrTreatementMedicine =[App_Delegate.dbObj GetAllMDSTreatmentMedicine:[[self.dictTreatment valueForKey:@"rowid"] intValue]withType:@"M"];
        App_Delegate.arrMDSTreatement =[App_Delegate.dbObj GetAllMDSTreatmentMedicine:[[self.dictTreatment valueForKey:@"rowid"] intValue]withType:@"T"];
        
        NSMutableArray *arrClinicalTrial = [App_Delegate.dbObj GetAllMDSClinicalTrial:[[self.dictTreatment valueForKey:@"rowid"] intValue]];
        
        [App_Delegate.arrMDSTreatement addObjectsFromArray:arrClinicalTrial];

         //NSLog(@"Count %lu",(unsigned long)App_Delegate.arrMDSTreatement.count);

    }
    //NSLog(@"Count %lu",(unsigned long)arrOthers);
}

-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *arrOther =[App_Delegate.dbObj GetAllOtherTreatment];
    
    MedicalObject *objTreatement = [[MedicalObject alloc] initDefaults];
    MedicalObject *objClinical  =   [[MedicalObject alloc] initDefaults];
    MedicalObject *objOther     =   [[MedicalObject alloc] initDefaults];
    
    objTreatement.strNotes = @"MDS Treatment";
    objClinical.strNotes    =   @"Clinical Trial";
    objOther.strNotes   =   @"Other";
    
    arrDropDown = [[NSMutableArray alloc] initWithObjects:objClinical,objTreatement, nil];
    [arrDropDown addObjectsFromArray:arrOther];
    [arrDropDown addObject:objOther];
    

    
    [tblView reloadData];
}


#pragma mark - Alertview Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertConfirmTag)
    {
        if (buttonIndex ==0)
        {
            if (App_Delegate.arrMDSTreatement)
            {
                [App_Delegate.arrMDSTreatement removeAllObjects];
            }
            if (App_Delegate.arrTreatementMedicine)
            {
                [App_Delegate.arrTreatementMedicine removeAllObjects];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (section==DateTiemSection)
    {
        return 2;
    }
    else if (section==TreatementSection)
    {
        if (App_Delegate.arrMDSTreatement.count>0)
        {
            return App_Delegate.arrMDSTreatement.count+2;
        }
        else
        {
            return 1;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Row in Tableview
    if (indexPath.section==DateTiemSection)
    {
        return 44;
    }
    else if(indexPath.section==TreatementSection)
    {
        if (App_Delegate.arrMDSTreatement.count>0)
        {
            if (indexPath.row==0)
            {
                return 30;
            }
            else if (indexPath.row==App_Delegate.arrMDSTreatement.count+1)
            {
                return 60;
            }
            return 44;
        }
        else
        {
            return 60;
        }
    }
    else if (indexPath.section==NotesSection)
    {
        return 120;
    }
    else
    {
        return 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    if(section==TreatementSection)
    {
        if (App_Delegate.arrTreatementMedicine.count>0)
        {
            return 10;
        }
        
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==TreatementSection)
    {
        if (App_Delegate.arrMDSTreatement.count>0)
        {
            UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
            [headerView setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]];
            return headerView;
            
        }
        
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==DateTiemSection)
    {
        NSString *CellIdentifier = @"ProfileContentDisplayCell";
        
        ProfileContentDisplayCell *cell = (ProfileContentDisplayCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileContentDisplayCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        cell.lblValue.hidden=YES;
        cell.txtField.delegate=self;
        cell.txtField.tag=indexPath.row;
        cell.txtField.superview.tag=indexPath.section;
        
        if (indexPath.row==0)
        {
            cell.lblTitle.text=@"Start Date *";
            if ([self.dictTreatment valueForKey:@"startdate"])
            {
                cell.txtField.text=[self.dictTreatment valueForKey:@"startdate"];
            }
        }
        else
        {
            cell.lblTitle.text=@"End Date";
            if ([self.dictTreatment valueForKey:@"enddate"])
            {
                cell.txtField.text=[self.dictTreatment valueForKey:@"enddate"];
            }
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.section==TreatementSection)
    {
        if (App_Delegate.arrMDSTreatement.count>0)
        {
            if (indexPath.row==0)
            {
                NSString *CellIdentifier = @"ThreeLableHeaderCell";
                
                ThreeLableHeaderCell *cell = (ThreeLableHeaderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableHeaderCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                cell.lblHeading1.text=@"Drug Name";
                cell.lblHeading2.text=@"Dosage";
                cell.lblHeading3.text=@"Days";
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else if (indexPath.row==App_Delegate.arrMDSTreatement.count+1)
            {
                NSString *CellIdentifier = @"ButtonCell";
                
                ButtonCell *cell = (ButtonCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                [cell.btnAction setTitle:@"Add Treatment" forState:UIControlStateNormal];
                [cell.btnAction addTarget:self action:@selector(clickOnAddTreatmentButton:) forControlEvents:UIControlEventTouchUpInside];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                //Add Clinical Trial List Here
                NSString *CellIdentifier = @"ThreeLableContentCell";
                
                ThreeLableContentCell *cell = (ThreeLableContentCell *) [tableView
                                                                         dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableContentCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                MedicalObject *objMedicine=[App_Delegate.arrMDSTreatement objectAtIndex:indexPath.row-1];
                
                if (objMedicine.strDrugName.length>0)
                {
                    cell.lblTitle1.text=objMedicine.strDrugName;
                    cell.lblTitle2.text=objMedicine.strDosage;
                    cell.lblTitle3.text=objMedicine.strFrequency;
                }
                else if (objMedicine.strTrialNumber.length>0)  // Clinical Trial
                {
                    cell.lblTitle1.text = objMedicine.strNameOfTrial;
                    cell.lblTitle2.text = @"Clinical Trial";
                    cell.lblTitle3.text = @"";
                }
                else
                {
                    cell.lblTitle1.text = objMedicine.strNotes;
                    
                    cell.lblTitle2.text = objMedicine.strOtherTreatmentName;
                    cell.lblTitle3.text = @"";
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else
        {
            NSString *CellIdentifier = @"ButtonCell";
            
            ButtonCell *cell = (ButtonCell *) [tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            [cell.btnAction setTitle:@"Add Treatment" forState:UIControlStateNormal];
            [cell.btnAction addTarget:self action:@selector(clickOnAddTreatmentButton:) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    else if(indexPath.section==NotesSection)
    {
        static NSString *CellIdentifier = @"AddNotesCell";
        
        AddNotesCell *cell = (AddNotesCell *) [tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddNotesCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.tvNotes.delegate=self;
        cell.tvNotes.superview.tag=indexPath.section;
        cell.tvNotes.inputAccessoryView=numberToolbar;
        cell.lblTitle.text = @"Notes";
        if ([self.dictTreatment valueForKey:@"note"])
        {
            cell.tvNotes.text=[self.dictTreatment valueForKey:@"note"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"SymptomButtonCell";
        
        SymptomButtonCell *cell = (SymptomButtonCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomButtonCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.backgroundColor=[UIColor clearColor];
        [cell.btnChart setTitle:@"Save" forState:UIControlStateNormal];
        [cell.btnChart addTarget:self action:@selector(clickOnSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    return nil;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == TreatementSection)
    {
        NSLog(@"Section =%ld  Row =%ld",indexPath.section,(long)indexPath.row);
        
        MedicalObject *obj = [App_Delegate.arrMDSTreatement objectAtIndex:indexPath.row-1];

        
        UIStoryboard *objStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        if (obj.strDrugName.length>0) //MDStreatment
        {
            AddTreatementMedicinVC *objmed=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddTreatementMedicin"];
            objmed.treatmentType = 1;
            objmed.isShowData = YES;
            objmed.objMedTemp = obj ;
            [self.navigationController pushViewController:objmed animated:YES];
        }
        else if (obj.strTrialNumber.length>0)  // Clinical Trial
        {
            AddClinicalTrialVC *objTrial=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddClinicalTrialVC"];
            objTrial.isShow = YES;
            objTrial.objMedTemp = obj;
            [self.navigationController pushViewController:objTrial animated:YES];
        }
        else // Other
        {
            AddTreatementMedicinVC *objmed=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddTreatementMedicin"];
            objmed.treatmentType = 2;
            objmed.isShowData = YES;
            objmed.objMedTemp = obj ;
            [self.navigationController pushViewController:objmed animated:YES];
        }
    }
}

#pragma mark Function Methods


-(void)clickOnAddTreatmentButton:(id)sender
{
    if (!isActionSheetVisible )
    {
        isActionSheetVisible = YES;
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
   
        objPicker.EntryTag=17;
        objPicker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             objPicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
        [self.view addSubview:objPicker.view];
    }
}

-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger)section andForRow:(NSInteger)row
{
    isActionSheetVisible=NO;
    
    MedicalObject *obj = [arrDropDown objectAtIndex:intIndex];
    
    // jitendra   // Don't know why this selection is done in that way , resulting in wrong selection on other selection
    //NSString *strSelected = obj.strNotes;
    NSString *strSelected = strValue;
    
    
    UIStoryboard *objStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if ([strSelected isEqualToString:@"MDS Treatment"])
    {
        AddTreatementMedicinVC *objmed=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddTreatementMedicin"];
        objmed.treatmentType = 1;
        [self.navigationController pushViewController:objmed animated:YES];
    }
    else if ([strSelected isEqualToString:@"Clinical Trial"])
    {
        AddClinicalTrialVC *objmed=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddClinicalTrialVC"];
        [self.navigationController pushViewController:objmed animated:YES];
    }
    else if ([strSelected isEqualToString:@"Other"])
    {
        AddTreatementMedicinVC *objmed=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddTreatementMedicin"];
        objmed.treatmentType = 2;
        [self.navigationController pushViewController:objmed animated:YES];
    }
    else
    {
        NSLog(@"%@",App_Delegate.arrMDSTreatement);
        
        [App_Delegate.arrMDSTreatement addObject:obj];
        NSLog(@"%@",App_Delegate.arrMDSTreatement);
        [tblView reloadData];
    }
     
    [tblView reloadData];
}

-(void)didCancelPicker
{
    isActionSheetVisible=NO;
}



-(IBAction)clickOnSaveButton:(id)sender
{
    if ([self.dictTreatment valueForKey:@"startdate"])
    {
        /*
        BOOL checkDate=NO;
        
        
        if ([self.dictTreatment valueForKey:@"startNSDate"] && [self.dictTreatment valueForKey:@"endNSDate"])
        {
            checkDate=[self isEndDateIsSmallerThanCurrent:[self.dictTreatment valueForKey:@"endNSDate"] withStart:[self.dictTreatment valueForKey:@"startNSDate"]];
            NSLog(@"checkDate: %d",checkDate);
        }
        */
        
        
        if (![self.dictTreatment valueForKey:@"note"])
        {
            [self.dictTreatment setValue:@"" forKey:@"note"];
        }
        
        if (![self.dictTreatment valueForKey:@"enddate"])
        {
            [self.dictTreatment setValue:@"" forKey:@"enddate"];
        }
        
        
        if (self.editFlag==0)  // Add Clinical trial insert method here  // T for other and add new field to database table to store data
        {
            
            int strRowid = [App_Delegate.dbObj insertMDSTreatment:self.dictTreatment];
            
            for (int i=0;i<App_Delegate.arrTreatementMedicine.count; i++)
            {
                MedicalObject *objMedi=[App_Delegate.arrTreatementMedicine objectAtIndex:i];
                objMedi.strId=[NSString stringWithFormat:@"%d",strRowid];
                objMedi.strType = @"M";
                [App_Delegate.dbObj insertMDSTreatmentMedicine:objMedi];
            }
            [App_Delegate.arrTreatementMedicine removeAllObjects];
            
            for (int i=0;i<App_Delegate.arrMDSTreatement.count; i++)
            {
                MedicalObject *objMedi=[App_Delegate.arrMDSTreatement objectAtIndex:i];
                objMedi.strId=[NSString stringWithFormat:@"%d",strRowid];
                
                //Save data in clinincal trial
                if (objMedi.strTrialNumber.length >0)
                {
                    [App_Delegate.dbObj insertMDSClinicalTrial:objMedi];
                }
                else   // Save data in treatment 
                {
                    //objMedi.strType = @"T";
                    [App_Delegate.dbObj insertMDSTreatmentMedicine:objMedi];
                }
          
            }
            [App_Delegate.arrMDSTreatement removeAllObjects];
            
        }
        else
        {
            [App_Delegate.dbObj deleteMDSTreatmentMedicine:[self.dictTreatment valueForKey:@"rowid"]];
            [App_Delegate.dbObj deleteMDSClinicalTrial:[self.dictTreatment valueForKey:@"rowid"]];
            
            [App_Delegate.dbObj updateMDSTreatment:self.dictTreatment];
            for (int i=0;i<App_Delegate.arrTreatementMedicine.count; i++)
            {
                MedicalObject *objMedi=[App_Delegate.arrTreatementMedicine objectAtIndex:i];
                objMedi.strId=[self.dictTreatment valueForKey:@"rowid"];
                objMedi.strType = @"M";
                [App_Delegate.dbObj insertMDSTreatmentMedicine:objMedi];
            }
            [App_Delegate.arrTreatementMedicine removeAllObjects];
            for (int i=0;i<App_Delegate.arrMDSTreatement.count; i++)
            {
                MedicalObject *objMedi=[App_Delegate.arrMDSTreatement objectAtIndex:i];
                objMedi.strId=[self.dictTreatment valueForKey:@"rowid"];
                
                if (objMedi.strTrialNumber.length >0)
                {
                    [App_Delegate.dbObj insertMDSClinicalTrial:objMedi];
                    
                }
                else   // Save data in treatment
                {
                    
                    objMedi.strType = @"T";
                    [App_Delegate.dbObj insertMDSTreatmentMedicine:objMedi];
                }

      
            }
            [App_Delegate.arrMDSTreatement removeAllObjects];
            
        }
        if (App_Delegate.arrMDSTreatement)
        {
            [App_Delegate.arrMDSTreatement removeAllObjects];
        }
        if (App_Delegate.arrTreatementMedicine)
        {
            [App_Delegate.arrTreatementMedicine removeAllObjects];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsLatestUpdate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        [App_Delegate CheckBeforeUploadMainDB];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
        SomeEdit = 0;
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
    }

}

- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate withStart:(NSDate *)checkStartDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = checkStartDate;
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}

-(IBAction)clickOnBack:(id)sender
{
    if (SomeEdit ==0)
    {
        if (App_Delegate.arrMDSTreatement)
        {
            [App_Delegate.arrMDSTreatement removeAllObjects];
        }
        if (App_Delegate.arrTreatementMedicine)
        {
            [App_Delegate.arrTreatementMedicine removeAllObjects];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You haven’t saved data yet. Do you really want to cancel the process?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        
        altView.tag = AlertConfirmTag;
        [altView show];
    }
}

-(void)doneWithNumberPad
{
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewDown];
         }
                         completion:^(BOOL finished)
         {}];
    }
}

-(IBAction)clickOnOpenDatePicker:(id)sender
{
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }

    objDatePicker=[[DatePickerVC alloc] initWithNibName:@"DatePickerVC" bundle:nil];
    objDatePicker.datePickerDel=self;
    objDatePicker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         objDatePicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    [self.view addSubview:objDatePicker.view];
    
    
}

-(void)didSelectDate:(NSDate *)selectedDate
{
    IsActionSheetVisible=NO;
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateStyle:NSDateFormatterMediumStyle];
    if (dateTag==0)
    {
        [self.dictTreatment setValue:selectedDate forKey:@"startNSDate"];
        [self.dictTreatment setValue:[dateformater stringFromDate:selectedDate] forKey:@"startdate"];
    }
    else
    {
        [self.dictTreatment setValue:selectedDate forKey:@"endNSDate"];
       [self.dictTreatment setValue:[dateformater stringFromDate:selectedDate] forKey:@"enddate"];
    }
    [tblView reloadData];
    
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIStoryboard *objStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (buttonIndex == 0)
    {
        AddTreatementMedicinVC *objmed=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddTreatementMedicin"];
        objmed.treatmentType = 1;
        [self.navigationController pushViewController:objmed animated:YES];
    }
    else if (buttonIndex == 1)
    {
        AddTreatementMedicinVC *objmed=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddTreatementMedicin"];
        objmed.treatmentType = 2;
        [self.navigationController pushViewController:objmed animated:YES];
    }
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SomeEdit =1;
    if (IsActionSheetVisible==NO)
    {
        if (textField.tag==0)
        {
            dateTag=0;
        }
        else
        {
            dateTag=1;
        }
        IsActionSheetVisible=YES;
        [self clickOnOpenDatePicker:nil];
    }
    return NO;
}


-(void)MoveViewUp
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,-175,self.view.frame.size.width,self.view.frame.size.height)];
}

-(void)MoveViewDown
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}

#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    SomeEdit = 1;
    
    tvTemp=textView;
    if (textView.superview.tag!=0)
    {
        IsUp=YES;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewUp];
         }
                         completion:^(BOOL finished)
         {}];

    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (IsUp)
    {
        IsUp=NO;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewDown];
         }
                         completion:^(BOOL finished)
         {}];
    }
    
    [textView resignFirstResponder];
    if (textView.superview.tag==0)
    {
        [self.dictTreatment setValue:textView.text forKey:@"treatment"];
        
    }
    else
    {
        [self.dictTreatment setValue:textView.text forKey:@"note"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)range
{
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

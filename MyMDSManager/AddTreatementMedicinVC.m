//
//  AddTreatementMedicinVC.m
//  MyMDSManager
//
//  Created by CEPL on 01/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "AddTreatementMedicinVC.h"
#import "PrescribedByCell.h"
#import "ProfileContentDisplayCell.h"
#import "SymptomButtonCell.h"
#import "AddMedicineVC.h"
#import "AddNotesCell.h"
#import "TreatementMessageCell.h"

#define OtherListTableTag 333

#define AlertConfirmTag 251

@interface AddTreatementMedicinVC ()

@end

@implementation AddTreatementMedicinVC

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
    
    
    if (self.isShowData)
    {
        objLocalMedicine = self.objMedTemp;
    }
    else
    {
       objLocalMedicine=[[MedicalObject alloc] initDefaults];
    }
    
    if (self.treatmentType == MedicineCreate)
    {
        lblTitle.text = @"Attach Medicine";
        
    }
    else if (self.treatmentType == MDSTreatment)
    {
        lblTitle.text = @"MDS Treatment";
    }
    else
    {
        lblTitle.text = @"Other Treatment";
    }
    
    [self.view bringSubviewToFront:lblTitle];
    [self createViewOtherFromList];
}
-(void)doneWithNumberPad
{
    [tvTemp resignFirstResponder];
    [txtTemp resignFirstResponder];
    
}
-(IBAction)clickOnBack:(id)sender
{
    if (isEdit)
    {
            UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You haven’t saved data yet. Do you really want to cancel the process?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            altView.tag = AlertConfirmTag;
            [altView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == OtherListTableTag)
    {
        return arrOtherList.count;
    }
    else
    {
        //count of row in section
        if (self.treatmentType == MedicineCreate)
        {
            return 4;
        }
        else if (self.treatmentType == MDSTreatment)
        {
            if (self.isShowData)
            {
                return 4;
            }
            return 6;
        }
        
        if (self.isShowData)
        {
            return 2;
        }
        else
        {
           return 3;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Section Header in TableView
    if (tableView.tag == OtherListTableTag)
    {
        return 44;
    }
    else
    {
        //Height of Row in Tableview
        if (self.treatmentType == MedicineCreate)
        {
            if (indexPath.row==0)
            {
                return 84;
            }
            else if (indexPath.row==3)
            {
                return 60;
            }
            
        }
        else if (self.treatmentType == MDSTreatment)
        {
            if (indexPath.row == 5)
            {
                return 60;
            }
            return 44;
        }
        else if (self.treatmentType == OtherTreatment)
        {
            if (indexPath.row == 1)
            {
                return 110;
            }
        }
        return 44;
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    if (tableView.tag == OtherListTableTag)
    {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == OtherListTableTag)
    {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tblOtherList.frame.size.width, 30)];
       
        [headerView setBackgroundColor:[UIColor yellowColor]];
        UILabel *lblTitleHeader=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, tblOtherList.frame.size.width-20, 21)];
        lblTitleHeader.textColor=[UIColor whiteColor];
        [lblTitleHeader setText:@"User's Custom List"];
        [headerView addSubview:lblTitleHeader];
        return headerView;
        
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == OtherListTableTag)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier] ;
        }
        if (arrOtherList.count>0)
        {
            cell.textLabel.text = [arrOtherList objectAtIndex:indexPath.row];
        }
        return cell;

    }
    else
    {
        if (self.treatmentType == MedicineCreate)
        {
            if (indexPath.row==0)
            {
                static NSString *CellIdentifier = @"PrescribedByCell";
                
                PrescribedByCell  *cell = (PrescribedByCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PrescribedByCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                cell.lblValue.hidden=YES;
                
                cell.txtField.delegate=self;
                cell.txtField.hidden=NO;
                cell.txtField.userInteractionEnabled=YES;
                cell.txtField.tag=indexPath.row;
                cell.txtField.superview.tag=indexPath.section;
                cell.btnAddProvider.hidden=NO;
                cell.btnAddProvider.userInteractionEnabled=YES;
                
                
                cell.lblTitle.text=@"Medicine";
                cell.lblValue.text=objLocalMedicine.strDrugName;
                cell.txtField.text=objLocalMedicine.strDrugName;
                [cell.btnAddProvider setTitle:@"Add Medicine" forState:UIControlStateNormal];
                [cell.btnAddProvider addTarget:self action:@selector(clickOnAddMedicine) forControlEvents:UIControlEventTouchUpInside];
                
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }
            if (indexPath.row==3)
            {
                static NSString *CellIdentifier = @"SymptomButtonCell";
                
                SymptomButtonCell *cell = (SymptomButtonCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomButtonCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.backgroundColor=[UIColor clearColor];
                [cell.btnChart setTitle:@"Add Medicine" forState:UIControlStateNormal];
                [cell.btnChart addTarget:self action:@selector(clickOnSaveMedicine:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.backgroundColor=[UIColor clearColor];
                return cell;
            }
            else
            {
                static NSString *CellIdentifier = @"ProfileContentDisplayCell";
                
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
                cell.txtField.inputAccessoryView = numberToolbar;
                
                //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                
                if (indexPath.row==1)
                {
                    cell.lblTitle.text=@"Dosage";
                    cell.txtField.text=objLocalMedicine.strDosage;
                }
                else
                {
                    cell.lblTitle.text=@"Days";
                    cell.txtField.text=objLocalMedicine.strFrequency;
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
        else if (self.treatmentType == MDSTreatment)
        {
            if (indexPath.row==5)
            {
                {
                    NSString *CellIdentifier = @"TreatementMessageCell";
                    
                    TreatementMessageCell *cell = (TreatementMessageCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TreatementMessageCell" owner:self options:nil];
                        cell=[nib objectAtIndex:0];
                    }
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    return cell;
                }
            }
            else if (indexPath.row==4)
            {
                NSString *CellIdentifier = @"SymptomButtonCell";
                
                SymptomButtonCell *cell = (SymptomButtonCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomButtonCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.backgroundColor=[UIColor clearColor];
                [cell.btnChart setTitle:@"Create Treatement" forState:UIControlStateNormal];
                [cell.btnChart addTarget:self action:@selector(clickOnSaveMedicine:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.backgroundColor=[UIColor clearColor];
                return cell;
            }
            else
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
                cell.txtField.inputAccessoryView = numberToolbar;
                
                //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                
                if (indexPath.row==0)
                {
                    cell.lblTitle.text=@"Medicine *";
                    cell.txtField.text=objLocalMedicine.strDrugName;
                }
                else if (indexPath.row==1)
                {
                    cell.lblTitle.text=@"Dosage";
                    cell.txtField.text=objLocalMedicine.strDosage;
                    //cell.txtField.keyboardType=UIKeyboardTypeDecimalPad;
                }
                else if (indexPath.row==2)
                {
                    cell.lblTitle.text=@"Days";
                    cell.txtField.text=objLocalMedicine.strFrequency;
                }
                if (indexPath.row==3)
                {
                    cell.lblTitle.text=@"Cycle Number";
                    cell.txtField.text=objLocalMedicine.strRefillFrequency;
                    //cell.txtField.keyboardType=UIKeyboardTypeDecimalPad;
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
        else
        {
            if (indexPath.row==2)
            {
                NSString *CellIdentifier = @"SymptomButtonCell";
                
                SymptomButtonCell *cell = (SymptomButtonCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomButtonCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.backgroundColor=[UIColor clearColor];
                [cell.btnChart setTitle:@"Create Treatement" forState:UIControlStateNormal];
                [cell.btnChart addTarget:self action:@selector(clickOnSaveMedicine:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.backgroundColor=[UIColor clearColor];
                return cell;
            }
            else if (indexPath.row == 0)
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
                cell.txtField.inputAccessoryView = numberToolbar;
                
                cell.lblTitle.text=@"Name *";
                cell.txtField.text=objLocalMedicine.strOtherTreatmentName;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
                cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                
                
                return cell;
            }
            else
            {
                NSString *CellIdentifier = @"AddNotesCell";
                
                AddNotesCell *cell = (AddNotesCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddNotesCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.lblTitle.text = @"Notes";
                cell.tvNotes.delegate=self;
                cell.tvNotes.superview.tag=indexPath.section;
                cell.tvNotes.inputAccessoryView=numberToolbar;
                cell.tvNotes.text = objLocalMedicine.strNotes;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    
    if (tableView.tag == OtherListTableTag)
    {
        return  YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==OtherListTableTag)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            [arrOtherList removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults]setObject:arrOtherList forKey:@"Other_mds_treatment_medine"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (arrOtherList.count>0)
            {
                tblOtherList.hidden=NO;
                [tblOtherList reloadData];
            }
            else
            {
                tblOtherList.hidden=YES;
            }
        }
    }
}
#pragma mark Function Methos

-(void)clickOnAddMedicine
{
    UIStoryboard *objStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    objAddMedicine=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddMedicineVC"];
    objAddMedicine.strActionValue=@"Add";
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.5];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[objAddMedicine.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    [self.view addSubview:objAddMedicine.view];

}
-(void)clickOnSaveMedicine:(id)sender
{
    [self.view endEditing:YES];

    if (self.treatmentType == MedicineCreate)
    {
        if (objLocalMedicine.strDrugName.length>0 && objLocalMedicine.strDosage.length>0  && objLocalMedicine.strFrequency.length>0)
        {
            if (!App_Delegate.arrTreatementMedicine)
            {
                App_Delegate.arrTreatementMedicine=[[NSMutableArray alloc] init];
            }
            [App_Delegate.arrTreatementMedicine addObject:objLocalMedicine];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [altView show];
        }
    }
    else if (self.treatmentType == MDSTreatment)
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        objLocalMedicine.strDrugName = [objLocalMedicine.strDrugName stringByTrimmingCharactersInSet:whitespace];
        objLocalMedicine.strDosage = [objLocalMedicine.strDosage stringByTrimmingCharactersInSet:whitespace];
        objLocalMedicine.strFrequency = [objLocalMedicine.strFrequency stringByTrimmingCharactersInSet:whitespace];
        objLocalMedicine.strRefillFrequency = [objLocalMedicine.strRefillFrequency stringByTrimmingCharactersInSet:whitespace];
        
        if (objLocalMedicine.strDrugName.length>0)
        {
            if (!App_Delegate.arrMDSTreatement)
            {
                App_Delegate.arrMDSTreatement=[[NSMutableArray alloc] init];
            }
            [App_Delegate.arrMDSTreatement addObject:objLocalMedicine];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [altView show];
        }
    }
    else
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        objLocalMedicine.strOtherTreatmentName = [objLocalMedicine.strOtherTreatmentName stringByTrimmingCharactersInSet:whitespace];
        objLocalMedicine.strNotes = [objLocalMedicine.strNotes stringByTrimmingCharactersInSet:whitespace];
        
        if (objLocalMedicine.strOtherTreatmentName.length>0)
        {
            if (!App_Delegate.arrMDSTreatement)
            {
                App_Delegate.arrMDSTreatement=[[NSMutableArray alloc] init];
            }
            [App_Delegate.arrMDSTreatement addObject:objLocalMedicine];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [altView show];
        }
    }
}

-(void)clickOnValuePicker
{
    [txtTemp resignFirstResponder];
    if (self.treatmentType == MedicineCreate)
    {
        if ([App_Delegate.dbObj GetAllMedicineName].count<=0)
        {
            IsActionSheetVisible=NO;
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Medicine list not found! Please add Medicine." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            altView.tag=105;
            [altView show];
        }
        else
        {
            objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
            objPicker.valueDelegate=self;
            objPicker.rowId=0;
            objPicker.sectionId=0;
            objPicker.EntryTag=7;
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
    else
    {
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
        objPicker.rowId=0;
        objPicker.sectionId=0;
        objPicker.EntryTag=11;
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
    IsActionSheetVisible=NO;
    
    if ([strValue isEqualToString:@"Other"])
    {
        [self clickOnOtherFromList];
    }
    else
    {
        objLocalMedicine.strDrugName=strValue;
        [tblView reloadData];
    }
}

-(void)clickOnOpenDatePicker
{
    IsActionSheetVisible = YES;
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    objDatePicker=[[DatePickerVC alloc] initWithNibName:@"DatePickerVC" bundle:nil];
    objDatePicker.datePickerDel=self;
    objDatePicker.entryTag=101;
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
    [dateformater setDateFormat:@"MMM dd, YYYY  hh:mm a"];
    objLocalMedicine.strStartDate=[dateformater stringFromDate:selectedDate];
    
    [tblView reloadData];
}

-(void)didCancelPicker
{
    IsActionSheetVisible=NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==105)   //for Add Provider
    {
        [self clickOnAddMedicine];
    }
    else if (alertView.tag == AlertConfirmTag)
    {
        if (buttonIndex ==0) //Cancel
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - Mehtods for OtherValue Fields
-(void)createViewOtherFromList
{
    if (!viewOtherValue)
    {
        viewOtherValue=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [viewOtherValue setBackgroundColor:[UIColor lightTextColor]];
    }
    UIView *viewBack = [[UIView alloc] init];
    viewBack.frame = viewOtherValue.frame;
    [viewBack setBackgroundColor:[UIColor darkTextColor]];
    viewBack.alpha = 0.8;
    [viewOtherValue addSubview:viewBack];
    [viewOtherValue sendSubviewToBack:viewBack];
    
    UIView *subResultView=[[UIView alloc]initWithFrame:CGRectMake(5, 0, 310, self.view.frame.size.height-100)];
    subResultView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [subResultView setBackgroundColor:[UIColor whiteColor]];
    subResultView.layer.cornerRadius=5.0;
    subResultView.layer.masksToBounds=YES;
    [viewOtherValue addSubview:subResultView];
    
    UILabel *lblTitleOther=[[UILabel alloc]initWithFrame:CGRectMake(15, 50, 280, 29)];
    [lblTitleOther setText:@"Add"];
    [lblTitleOther setTextAlignment:NSTextAlignmentCenter];
    [lblTitleOther setTextColor:[UIColor redColor]];
    [lblTitleOther setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0]];
    
    [subResultView addSubview:lblTitleOther];
    
    txtOtherValue=[[UITextField alloc]initWithFrame:CGRectMake(15, 105, 280, 35)];
    [txtOtherValue setBorderStyle:UITextBorderStyleLine];
    txtOtherValue.delegate=self;
    txtOtherValue.tag=101;
    txtOtherValue.placeholder=@"Enter Value";
    txtOtherValue.inputAccessoryView = numberToolbar;
    
    [subResultView addSubview:txtOtherValue];
    
    UIButton *btnOtherValue=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnOtherValue setFrame:CGRectMake(15, 215, 280, 35)];
    [btnOtherValue setTitle:@"Save" forState:UIControlStateNormal];
    [btnOtherValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOtherValue setBackgroundImage:[UIImage imageNamed:@"btn_add_diagnosis.png"] forState:UIControlStateNormal];
    [btnOtherValue addTarget:self action:@selector(clickOnDoneForOtherFromList:) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnOtherValue];
    
    UIButton *btnclose=[[UIButton alloc]initWithFrame:CGRectMake(275,0, 35, 35)];
    [btnclose setTitle:@"X" forState:UIControlStateNormal];
    [btnclose.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [btnclose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclose setBackgroundColor:[UIColor redColor]];
    [btnclose addTarget:self action:@selector(clickOnRemoveView) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnclose];
    
    tblOtherList = [[UITableView alloc] initWithFrame:CGRectMake(0,265, 310, subResultView.frame.size.height-275) style:UITableViewStylePlain];
    tblOtherList.delegate=self;
    tblOtherList.dataSource=self;
    tblOtherList.tag=OtherListTableTag;
    tblOtherList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [subResultView addSubview:tblOtherList];
    
    
    [self.view addSubview:viewOtherValue];
    viewOtherValue.hidden=YES;
    
}

-(IBAction)clickOnOtherFromList
{
    txtOtherValue.text=@"";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Other_mds_treatment_medine"])
    {
        arrOtherList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Other_mds_treatment_medine"] mutableCopy];
    }
    else
    {
        arrOtherList = [[NSMutableArray alloc] init];
    }
    if (arrOtherList.count>0)
    {
        tblOtherList.hidden = NO;
        [tblOtherList reloadData];
    }
    else
    {
        tblOtherList.hidden = YES;
        
    }
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        viewOtherValue.hidden = NO;
                    } completion:NULL];
    
    
}

//Code To Close Add Other List View

-(void)clickOnRemoveView
{
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        viewOtherValue.hidden=YES;
                    } completion:NULL];
    
    
}

//Handle Done Action of Other List View
-(IBAction)clickOnDoneForOtherFromList:(id)sender
{
    if (txtOtherValue.text.length>0)
    {
        NSMutableArray *arrOther;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Other_mds_treatment_medine"])
        {
            arrOther = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Other_mds_treatment_medine"] mutableCopy];
            [arrOther addObject:txtOtherValue.text];
        }
        else
        {
            arrOther = [[NSMutableArray alloc] init];
            [arrOther addObject:txtOtherValue.text];
        }
        objLocalMedicine.strDrugName = txtOtherValue.text;
        [[NSUserDefaults standardUserDefaults]setObject:arrOther forKey:@"Other_mds_treatment_medine"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self clickOnRemoveView];
        txtOtherValue.text=@"";
        [tblView reloadData];
        
        
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter value before submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alt show];
    }
    
}
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    isEdit = YES;
    
    if (self.treatmentType == MedicineCreate || self.treatmentType == MDSTreatment)
    {
        if (textField.tag == 0)
        {
            if (IsActionSheetVisible==NO)
            {
                IsActionSheetVisible=YES;
                [self clickOnValuePicker];
            }
            return NO;
        }
    }
   else if (self.treatmentType == OtherTreatment)
    {
          return YES;
    }
     return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtTemp=textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //count of row in section
    if (textField.tag ==0)
    {
        objLocalMedicine.strOtherTreatmentName = textField.text;
    }
    else if (textField.tag==1)
    {
        objLocalMedicine.strDosage=textField.text;
    }
    else if (textField.tag==2)
    {
        objLocalMedicine.strFrequency=textField.text;
    }
    else if (textField.tag==3)
    {
        objLocalMedicine.strRefillFrequency=textField.text;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isEdit = YES;
    tvTemp=textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    objLocalMedicine.strNotes=textView.text;
    
    [textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

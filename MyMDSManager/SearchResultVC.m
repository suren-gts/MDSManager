
//  SearchResultVC.m
//  MyMDSManager

//  Created by CEPL on 26/08/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "SearchResultVC.h"
#import "ThreeLableContentCell.h"
#import "ThreeLableHeaderCell.h"
#import "MProffesionalContentCell.h"
#import "TwoLableNotesContentCell.h"
#import "TwoLableNotesHeaderCell.h"
#import "AddNotestVC.h"
#import "SymptomListVC.h"
#import "MediaProfessionalListVC.h"
#import "MedicalScreenVC.h"


@interface SearchResultVC ()

@end

@implementation SearchResultVC

@synthesize strFilter,filterTag;

- (void)viewDidLoad
{
    [super viewDidLoad];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    arrSearchFilter=[[NSArray alloc] initWithObjects:@"Symptom Tracker Notes",@"Medical Professionals",@"Medicine",@"Notes Section", nil];
    lblSearchFilter.text=@"Where would you like to search?";
    selectedSearchFilter=-1;
    txtSearchField.returnKeyType=UIReturnKeySearch;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
}


-(void)loadDBData
{
    tblView.hidden = NO;
    switch (self.filterTag)
    {
        case 0:
            arrSearchContent=[App_Delegate.dbObj getSymptomInfoListForFilter:self.strFilter];
            break;
        case 1:
            arrSearchContent=[App_Delegate.dbObj GetAllMedicalProviderForFilter:self.strFilter];
            break;
        case 2:
            arrSearchContent=[App_Delegate.dbObj getMedicinesForFilter:self.strFilter];
            break;
        case 3:
            arrSearchContent=[App_Delegate.dbObj GetAllNotesForFilter:self.strFilter];
            break;
            
        default:
            break;
    }
    if (arrSearchContent.count>0)
    {
        [tblView reloadData];
    }
}

#pragma mark IBActions Methods

-(IBAction)clickOnBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrSearchContent count] == 0) {
        return 1; // a single cell to report no data
    }
    if (self.filterTag==1)
    {
        return [arrSearchContent count];
    }
    return [arrSearchContent count]+1;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arrSearchContent count] == 0)
    {
        return 44; // a single cell to report no data
    }
    else if (indexPath.row==0)
    {
        if (self.filterTag==1)
        {
            return 70;
        }
        return 30;
    }
    else
    {
        return 44;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //View for Section Header of TableView
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arrSearchContent count] == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"No records to display";
        //whatever else to configure your one cell you're going to return
        return cell;
    }
    else
    {
        if (self.filterTag==0)
        {
            if (indexPath.row==0)
            {
                static NSString *CellIdentifier = @"ThreeLableHeaderCell";
                
                ThreeLableHeaderCell *cell = (ThreeLableHeaderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableHeaderCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.lblHeading1.text=@"Date";
                cell.lblHeading2.text=@"Symptom";
                cell.lblHeading3.text=@"Severity";
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;

            }
            else
            {
                static NSString *CellIdentifier = @"ThreeLableContentCell";
                
                ThreeLableContentCell *cell = (ThreeLableContentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableContentCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                SymptomObject *object=[arrSearchContent objectAtIndex:indexPath.row-1];
                
                cell.lblTitle1.text=object.strDate;
                cell.lblTitle2.text=object.strSymptom;
                cell.lblTitle3.text=object.strServirty;
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }

        }
        else if (self.filterTag==1)
        {
            static NSString *CellIdentifier = @"MProffesionalContentCell";
            
            MProffesionalContentCell *cell = (MProffesionalContentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MProffesionalContentCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            cell.lblName.text=@"";
            cell.lblSpeciality.text=@"";
            cell.lblPhone.text=@"Contact Info not available";
            if (arrSearchContent.count>0)
            {
                NSMutableDictionary *dicValue=[arrSearchContent objectAtIndex:indexPath.row];
                cell.lblName.text = [dicValue valueForKey:@"name"];
                cell.lblSpeciality.text = [dicValue valueForKey:@"speciality"];
                NSString *strPhoneNo=[dicValue valueForKey:@"phone"];
                if (strPhoneNo.length>0)
                {
                    cell.lblPhone.text=strPhoneNo;
                }
                else
                {
                    cell.btnCallMe.enabled=NO;
                }
                
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (self.filterTag==2)
        {
            if (indexPath.row==0)
            {
                static NSString *CellIdentifier = @"ThreeLableHeaderCell";
                
                ThreeLableHeaderCell *cell = (ThreeLableHeaderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableHeaderCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                cell.lblHeading1.text=@"Drug Name";
                cell.lblHeading2.text=@"Generic Name";
                cell.lblHeading3.text=@"Dosage";
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else
            {
                static NSString *CellIdentifier = @"ThreeLableContentCell";
                
                ThreeLableContentCell *cell = (ThreeLableContentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableContentCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                MedicalObject *objMedicine=[arrSearchContent objectAtIndex:indexPath.row-1];
                cell.lblTitle1.text=objMedicine.strDrugName;
                cell.lblTitle2.text=objMedicine.strGenericName;
                cell.lblTitle3.text=objMedicine.strDosage;
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else
        {
            if (indexPath.row==0)
            {
                static NSString *CellIdentifier = @"TwoLableNotesHeaderCell";
                
                TwoLableNotesHeaderCell *cell = (TwoLableNotesHeaderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TwoLableNotesHeaderCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.lblHeading1.text=@"Date";
                cell.lblHeading2.text=@"Topic";
                cell.lblHeading3.text=@"Notes";
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else
            {
                static NSString *CellIdentifier = @"TwoLableNotesContentCell";
                
                TwoLableNotesContentCell *cell = (TwoLableNotesContentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TwoLableNotesContentCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                NSMutableDictionary *dicValue=[arrSearchContent objectAtIndex:indexPath.row-1];
                NSArray *arr=[[dicValue valueForKey:@"date"] componentsSeparatedByString:@"  "];
                if (arr.count>1)
                {
                    cell.lblTitle1.text=[arr objectAtIndex:0];
                }
                else
                {
                    cell.lblTitle1.text=[dicValue valueForKey:@"date"];
                }
                
                cell.lblTitle2.text=[dicValue valueForKey:@"topic"];
            
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }

        }
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (self.filterTag==1)
    {
        if (arrSearchContent.count>0)
        {
            MediaProfessionalListVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"MediaProfessionalListVC"];
            [self.navigationController pushViewController:objMedicalScreen animated:YES];
        }
    }
    else
    {
        if (arrSearchContent.count>0 && indexPath.row>0)
        {
           if (self.filterTag==0)
            {
                SymptomListVC *objSymptom=[objStoryboard instantiateViewControllerWithIdentifier:@"SymptomListVC"];
                [self.navigationController pushViewController:objSymptom animated:YES];
                
            }
            else if (self.filterTag==2)
            {
                MedicalScreenVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"MedicalScreenVC"];
                [self.navigationController pushViewController:objMedicalScreen animated:YES];
            }
            else
            {
                AddNotestVC *objView=[objStoryboard instantiateViewControllerWithIdentifier:@"AddNotestVC"];
                objView.dictLocal=[arrSearchContent objectAtIndex:indexPath.row-1];
                objView.editTag=1;
                [self.navigationController pushViewController:objView animated:YES];
            }
        }

    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    txtSearchField.text=@"";
    [self.view endEditing:YES];
}


-(IBAction)showSearchFilterView:(id)sender
{
    if (viewSearchFilter.hidden==NO)
    {
        [UIView animateWithDuration:0.25 animations:^{
        
            viewSearchFilter.hidden=YES;
        }];
        
    }
    else
    {
        viewSearchFilter.hidden=NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            
        }];
        btnFilter1.hidden=NO;
        btnFilter2.hidden=NO;
        btnFilter3.hidden=NO;
        btnFilter4.hidden=NO;
    }
}

-(IBAction)clickOnSearchFilterOption:(UIButton *)sender
{
    
    lblSearchFilter.text=[arrSearchFilter objectAtIndex:sender.tag];
    viewSearchFilter.hidden=YES;
    selectedSearchFilter=(int)sender.tag;
    self.filterTag = (int)sender.tag;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (selectedSearchFilter!=-1)
    {
        return YES;
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select a search category before searching" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alt show];
        return NO;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"txt: %@",txtSearchField.text);
    NSLog(@"txt: %@",textField.text);
    self.strFilter = txtSearchField.text;
    if (txtSearchField.text.length>0)
    {
        [self loadDBData];
    }
    [textField resignFirstResponder];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( IsUp)
    {
        if (self.view.frame.size.height<=568)
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
    [textField resignFirstResponder];
    return YES;
    
}

-(void)MoveViewUp
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,-200,self.view.frame.size.width,self.view.frame.size.height)];
}

-(void)MoveViewDown
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end

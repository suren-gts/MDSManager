//
//  MedicalHistoryScreenVC.m
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "MedicalHistoryScreenVC.h"
#import "ProfileHeaderCell.h"
#import "TwoLableNotesContentCell.h"
#import "TwoLableNotesHeaderCell.h"

#import "ButtonCell.h"
#import "AddMedicalHistoryVC.h"
#import "DiagnosisObject.h"
#import "CustomIOSAlertView.h"

@interface MedicalHistoryScreenVC ()

@end

@implementation MedicalHistoryScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    dictColleps=[[NSMutableDictionary alloc]init];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self laodDBData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self laodDBData];
}
-(void)laodDBData
{
    arrDiagnosisHistory=[App_Delegate.dbObj getAllDiagnosis];
    arrSurgicalHistory=[App_Delegate.dbObj getAllSurgery];
    
    // getAllBloodCellInitialLabResult
    [tblView reloadData];
}
#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (section==DiagnosisHistory)
    {
        NSString *strSection=[NSString stringWithFormat:@"Section%ld",section];
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        if (arrDiagnosisHistory.count>0)
        {
            NSLog(@"Count: %lu",(unsigned long)arrDiagnosisHistory.count);
            return arrDiagnosisHistory.count+2;
        }
        else
        {
            return 1;
        }
    }
    else if (section==SurgicalHistory)
    {
        NSString *strSection=[NSString stringWithFormat:@"Section%ld",section];
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        if (arrSurgicalHistory.count>0)
        {
            return arrSurgicalHistory.count+2;
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
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",indexPath.section];
    if ([dictColleps valueForKey:strSection])
    {
        return 0;
    }
    if (indexPath.section==DiagnosisHistory)
    {
        if (arrDiagnosisHistory.count>0)
        {
            if (indexPath.row==0)
            {
                return 30;
            }
            else if (indexPath.row==arrDiagnosisHistory.count+1)
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
    else if (indexPath.section==SurgicalHistory)
    {
        if (arrSurgicalHistory.count>0)
        {
            if (indexPath.row==0)
            {
                return 30;
            }
            else if (indexPath.row==arrSurgicalHistory.count+1)
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
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 44)];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 11, 272, 21)];
    [lblTitle setFont:[UIFont fontWithName:@"NexaRegular" size:16]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    UIButton *btnCollops =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCollops setFrame:CGRectMake(self.view.frame.size.width-32, 11, 22, 22)];
    [headerView addSubview:lblTitle];
    [headerView addSubview:btnCollops];
   
    
    if (section==DiagnosisHistory)
    {
        lblTitle.text=@"Diagnosis History";
    }
    else if (section==SurgicalHistory)
    {
        lblTitle.text=@"Surgical History";
    }
    
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",section];
    
    if ([dictColleps valueForKey:strSection])
    {
        [btnCollops setImage:[UIImage imageNamed:@"icn_arrow_down_aboutlabel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnCollops setImage:[UIImage imageNamed:@"icn_arrowup_aboutlabel.png"] forState:UIControlStateNormal];
    }
    
    btnCollops.tag=section;
    [btnCollops addTarget:self action:@selector(clickOnCollepsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    headerView.backgroundColor=[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section==DiagnosisHistory)
    {
        if (arrDiagnosisHistory.count>0)
        {
            if (indexPath.row==0)
            {
                static NSString *CellIdentifier = @"TwoLableNotesHeaderCell";
                
                TwoLableNotesHeaderCell *cell = (TwoLableNotesHeaderCell *) [tableView
                                                                     dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TwoLableNotesHeaderCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.lblHeading1.text=@"Diagnosis";
                cell.lblHeading2.text=@"Date";
                cell.lblHeading3.text=@"Notes";
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else if (indexPath.row==arrDiagnosisHistory.count+1)
            {
                static NSString *CellIdentifier = @"ButtonCell";
                
                ButtonCell *cell = (ButtonCell *) [tableView
                                                   dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                [cell.btnAction setTitle:@"Add Diagnosis" forState:UIControlStateNormal];
                [cell.btnAction addTarget:self action:@selector(clickOnAddDiagnosis:) forControlEvents:UIControlEventTouchUpInside];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                static NSString *CellIdentifier = @"TwoLableNotesContentCell";
                
                TwoLableNotesContentCell *cell = (TwoLableNotesContentCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TwoLableNotesContentCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                DiagnosisObject *objDia=[arrDiagnosisHistory objectAtIndex:indexPath.row-1];
                cell.lblTitle1.text=objDia.strDiagnosis;
                cell.lblTitle2.text=objDia.strDate;

                cell.btnNotes.superview.tag=indexPath.section;
                cell.btnNotes.tag=indexPath.row-1;
                [cell.btnNotes addTarget:self action:@selector(clickOnShowNotes:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }

        }
        else
        {
            static NSString *CellIdentifier = @"ButtonCell";
            
            ButtonCell *cell = (ButtonCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            [cell.btnAction setTitle:@"Add Diagnosis" forState:UIControlStateNormal];
            [cell.btnAction addTarget:self action:@selector(clickOnAddDiagnosis:) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (indexPath.section==SurgicalHistory)
    {
        if (arrSurgicalHistory.count>0)
        {
            if (indexPath.row==0)
            {
                static NSString *CellIdentifier = @"TwoLableNotesHeaderCell";
                
                TwoLableNotesHeaderCell *cell = (TwoLableNotesHeaderCell *) [tableView
                                                                     dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TwoLableNotesHeaderCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.lblHeading1.text=@"Surgical Procedure";
                cell.lblHeading2.text=@"Date";
                cell.lblHeading3.text=@"Notes";
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else if (indexPath.row==arrSurgicalHistory.count+1)
            {
                static NSString *CellIdentifier = @"ButtonCell";
                
                ButtonCell *cell = (ButtonCell *) [tableView
                                                   dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                [cell.btnAction setTitle:@"Add Surgery" forState:UIControlStateNormal];
                [cell.btnAction addTarget:self action:@selector(clickOnAddSurgery:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                static NSString *CellIdentifier = @"TwoLableNotesContentCell";
                
                TwoLableNotesContentCell *cell = (TwoLableNotesContentCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TwoLableNotesContentCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                DiagnosisObject *objDia=[arrSurgicalHistory objectAtIndex:indexPath.row-1];
                cell.lblTitle1.text=objDia.strDiagnosis;
                cell.lblTitle2.text=objDia.strDate;
                
                cell.btnNotes.superview.tag=indexPath.section;
                cell.btnNotes.tag=indexPath.row-1;
                [cell.btnNotes addTarget:self action:@selector(clickOnShowNotes:) forControlEvents:UIControlEventTouchUpInside];
            
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            
        }
        else
        {
            static NSString *CellIdentifier = @"ButtonCell";
            
            ButtonCell *cell = (ButtonCell *) [tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            
            [cell.btnAction setTitle:@"Add Surgery" forState:UIControlStateNormal];
            [cell.btnAction addTarget:self action:@selector(clickOnAddSurgery:) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.section==DiagnosisHistory)
    {
        if (indexPath.row != arrDiagnosisHistory.count+1 && indexPath.row>0)
        {
            AddMedicalHistoryVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddMedicalHistoryVC"];
            objView.entryTag=0;
            objView.editFlag=1;
            objView.objDiagnosis=[arrDiagnosisHistory objectAtIndex:indexPath.row-1];
            [self.navigationController pushViewController:objView animated:YES];

        }
    }
    else
    {
        if (indexPath.row != arrSurgicalHistory.count+1 && indexPath.row>0)
        {
            AddMedicalHistoryVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddMedicalHistoryVC"];
            objView.entryTag=1;
            objView.editFlag=1;
            objView.objDiagnosis=[arrSurgicalHistory objectAtIndex:indexPath.row-1];
            
            [self.navigationController pushViewController:objView animated:YES];
            
        }
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// for some items. By default, all items are editable.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (indexPath.section == DiagnosisHistory)
    {
        if (indexPath.row != arrDiagnosisHistory.count+1 && indexPath.row>0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        if (indexPath.row != arrSurgicalHistory.count+1 && indexPath.row>0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return  YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == DiagnosisHistory)
        {
            LabResultObject *objDel = [arrDiagnosisHistory objectAtIndex:indexPath.row-1];
            [App_Delegate.dbObj deleteMedicalHistory:objDel.strId];
            arrDiagnosisHistory=[App_Delegate.dbObj getAllDiagnosis];
        }
        else
        {
            LabResultObject *objDel = [arrSurgicalHistory objectAtIndex:indexPath.row-1];
            [App_Delegate.dbObj deleteMedicalHistory:objDel.strId];
            arrSurgicalHistory=[App_Delegate.dbObj getAllSurgery];
            
        }
        [tblView reloadData];
    }
    
}

#pragma mark - Function Methods

-(IBAction)clickOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickOnShowNotes:(UIButton *)sender
{
    DiagnosisObject *objDia;
    if (sender.superview.tag==DiagnosisHistory)
    {
        objDia=[arrDiagnosisHistory objectAtIndex:sender.tag];
    }
    else
    {
        objDia=[arrSurgicalHistory objectAtIndex:sender.tag];
    }
    NSString *strNotes=objDia.strNotes;
    
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    
    if (!tvShowNotes)
    {
        tvShowNotes=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300,250)];
        //  tvShowNotes.center=alertView.center;
        tvShowNotes.inputAccessoryView=nil;
        tvShowNotes.backgroundColor=[UIColor clearColor];
        [tvShowNotes setFont:[UIFont fontWithName:@"Helvetica Neue" size:18.0f]];
    }
    tvShowNotes.text=strNotes;
    [alertView setContainerView:tvShowNotes];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", nil]];
    [alertView setDelegate:nil];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
}

-(void)clickOnAddDiagnosis:(id)sender
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMedicalHistoryVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddMedicalHistoryVC"];
    objView.entryTag=0;
    [self.navigationController pushViewController:objView animated:YES];
}


-(void)clickOnAddSurgery:(id)sender
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMedicalHistoryVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddMedicalHistoryVC"];
    objView.entryTag=1;
    [self.navigationController pushViewController:objView animated:YES];

}


-(void)clickOnCollepsAction:(id)sender
{
    
    UIButton *btnSender=(UIButton *)sender;
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",btnSender.tag];
    
    if ([dictColleps valueForKey:strSection])
    {
        [dictColleps setValue:nil forKey:strSection];
    }
    else
    {
        [dictColleps setValue:@"YES" forKey:strSection];
    }
    [UIView transitionWithView:tblView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [tblView reloadData];
                    } completion:NULL];
    
}

- (void) dealloc
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

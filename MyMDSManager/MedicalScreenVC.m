//
//  MedicalScreenVC.m
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "MedicalScreenVC.h"
#import "MedicalDisplayHeaderCell.h"

#import "ThreeLableHeaderCell.h"
#import "ThreeLableContentCell.h"
#import "ButtonCell.h"

#import "AddMedicineVC.h"
#import "MedicalObject.h"
#import "AddMediaProfessionalVC.h"



@interface MedicalScreenVC ()

@end

@implementation MedicalScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    arrMedicinType=[[NSArray alloc]initWithObjects:@"Prescription",@"Over-the-Counter",@"Supplements/Other", nil ];
    currentlySelctecdTab=0;
    [btnAddMedication addTarget:self action:@selector(clickOnAddMedicineButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddMedication setTitle:@"Add Medication" forState:UIControlStateNormal];
}


-(void)viewDidAppear:(BOOL)animated
{
    [self loadDatafromDB];
}

-(void)loadDatafromDB
{
    if (arrCurrentMedicine)
    {
        [arrCurrentMedicine removeAllObjects];
    }
    
    arrCurrentMedicine=[App_Delegate.dbObj getAllCurrentMedicines:[arrMedicinType objectAtIndex:currentlySelctecdTab]];
    if (arrPreviousMedicine)
    {
        [arrPreviousMedicine removeAllObjects];
    }
     arrPreviousMedicine=[App_Delegate.dbObj getAllPreviousMedicines:[arrMedicinType objectAtIndex:currentlySelctecdTab]];
    
    [self.view endEditing:YES];
    [tblView reloadData];
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (arrPreviousMedicine.count>0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
        //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (section==CurrentMedicine)
    {
        if (arrCurrentMedicine.count>0)
        {
            return arrCurrentMedicine.count+1;
        }
        else
        {
            return 1;
        }
        
    }
    else if (section==PreviousMedicine)
    {
        if (arrPreviousMedicine.count>0)
        {
            return arrPreviousMedicine.count;
        }
        else
        {
            return 0;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==CurrentMedicine)
    {
        if (arrCurrentMedicine.count>0)
        {
            if (indexPath.row==0)
            {
                return 30;
            }
            else if (indexPath.row==arrCurrentMedicine.count+1)
            {
                return 30;
            }
            return 44;
        }
        else
        {
            return 30;
        }
    }
    if (indexPath.section==PreviousMedicine)
    {
        if (arrPreviousMedicine.count>0)
        {
            if (indexPath.row==0)
            {
                return 30;
            }
            else
            {
                return 44;
            }
        }
        else
        {
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    //View for Section Header of TableView
    
    static NSString *CellIdentifier = @"MedicalDisplayHeaderCell";
    
    MedicalDisplayHeaderCell *cell = (MedicalDisplayHeaderCell *) [tableView
                                                     dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MedicalDisplayHeaderCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    if (section==CurrentMedicine)
    {
        cell.lblHeaderTitle.text=@"Current Medicine";
    }
    else if (section==PreviousMedicine)
    {
        cell.lblHeaderTitle.text=@"Previous Medicine";
    }
    
    cell.btnTab1.tag=0;
    [cell.btnTab1 addTarget:self action:@selector(clickOnMedicineTab:) forControlEvents:UIControlEventTouchUpInside];
   
    cell.btnTab2.tag=1;
    [cell.btnTab2 addTarget:self action:@selector(clickOnMedicineTab:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnTab3.tag=2;
    [cell.btnTab3 addTarget:self action:@selector(clickOnMedicineTab:) forControlEvents:UIControlEventTouchUpInside];
    switch (currentlySelctecdTab) {
        case 0:
            [cell.btnTab1 setSelected:YES];
            [cell.contentView bringSubviewToFront:cell.btnTab1];
            break;
        case 1:
            [cell.btnTab2 setSelected:YES];
            [cell.contentView bringSubviewToFront:cell.btnTab2];
            break;
        case 2:
            [cell.btnTab3 setSelected:YES];
            [cell.contentView bringSubviewToFront:cell.btnTab3];
            break;
            
        default:
            break;
    }
    cell.tag=100;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);

    [headerView addSubview:cell];
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==CurrentMedicine)
    {
        if (indexPath.row==0)
        {
            static NSString *CellIdentifier = @"ThreeLableHeaderCell";
            
            ThreeLableHeaderCell *cell = (ThreeLableHeaderCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
            
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
            
            ThreeLableContentCell *cell = (ThreeLableContentCell *) [tableView
                                                                   dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableContentCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            
            MedicalObject *objMedicine=[arrCurrentMedicine objectAtIndex:indexPath.row-1];
            cell.lblTitle1.text=objMedicine.strDrugName;
            cell.lblTitle2.text=objMedicine.strGenericName;
            cell.lblTitle3.text=objMedicine.strDosage;

            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }
    else if (indexPath.section==PreviousMedicine)
    {
        if (indexPath.row==0)
        {
            static NSString *CellIdentifier = @"ThreeLableHeaderCell";
            
            ThreeLableHeaderCell *cell = (ThreeLableHeaderCell *) [tableView
                                                                       dequeueReusableCellWithIdentifier:CellIdentifier];
            
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
            
            ThreeLableContentCell *cell = (ThreeLableContentCell *) [tableView
                                                                               dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableContentCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            
            MedicalObject *objMedicine=[arrPreviousMedicine objectAtIndex:indexPath.row-1];
            
            cell.lblTitle1.text=objMedicine.strDrugName;
            cell.lblTitle2.text=objMedicine.strGenericName;
            cell.lblTitle3.text=objMedicine.strDosage;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==CurrentMedicine)
    {
        if (indexPath.row<=arrCurrentMedicine.count && indexPath.row!=0)
        {
            UIStoryboard *objStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            objAddMedicine=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddMedicineVC"];
            objAddMedicine.strActionValue=@"View";
            objAddMedicine.objLocalMedical=[arrCurrentMedicine objectAtIndex:indexPath.row-1];
          
            CATransition *applicationLoadViewIn =[CATransition animation];
            [applicationLoadViewIn setDuration:0.5];
            [applicationLoadViewIn setType:kCATransitionReveal];
            [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [[objAddMedicine.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
            objAddMedicine.medicineUpdateDelegte=self;
            [self.view addSubview:objAddMedicine.view];
        }
 
    }
    else
    {
        if (indexPath.row<=arrPreviousMedicine.count && indexPath.row!=0)
        {
            UIStoryboard *objStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            objAddMedicine=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddMedicineVC"];
            objAddMedicine.strActionValue=@"View";
            objAddMedicine.objLocalMedical=[arrPreviousMedicine objectAtIndex:indexPath.row-1];            
            CATransition *applicationLoadViewIn =[CATransition animation];
            [applicationLoadViewIn setDuration:0.5];
            [applicationLoadViewIn setType:kCATransitionReveal];
            [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [[objAddMedicine.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
            objAddMedicine.medicineUpdateDelegte=self;
            [self.view addSubview:objAddMedicine.view];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (indexPath.row>0)
    {
        return  YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == CurrentMedicine)
        {
            if (indexPath.row>0 && indexPath.row !=arrCurrentMedicine.count+1)
            {
                MedicalObject *objMedical = [arrCurrentMedicine objectAtIndex:indexPath.row-1];
                [self deleteReminder:[objMedical.strId intValue]];
                [App_Delegate.dbObj deleteMedicine:objMedical.strId];
                
                
                [App_Delegate CheckBeforeUploadMainDB];
                
                 [self performSelector:@selector(loadDatafromDB) withObject:nil afterDelay:0.5];
            }
            
        }
        else
        {
            if (indexPath.row>0 && indexPath.row !=arrPreviousMedicine.count+1)
            {
                MedicalObject *objMedical = [arrPreviousMedicine objectAtIndex:indexPath.row-1];
                [self deleteReminder:[objMedical.strId intValue]];
                [App_Delegate.dbObj deleteMedicine:objMedical.strId];
                
                [App_Delegate CheckBeforeUploadMainDB];
                
               [self performSelector:@selector(loadDatafromDB) withObject:nil afterDelay:0.5];

            }

        }
        
        
    }
}

-(void)deleteReminder:(int)meditionId
{
    //For delete locat notification
    
    UIApplication *app1 = [UIApplication sharedApplication];
    NSArray *eventArray = [app1 scheduledLocalNotifications];
    
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        
        if ([[userInfoCurrent objectForKey:@"medicineID"]intValue] == meditionId )
        {
            // Cancelling local notification
            [app1 cancelLocalNotification:oneEvent];
            NSLog(@"reminder Delete");
        }
    }
}

#pragma mark - Function Methods

-(IBAction)clickOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickOnMedicineTab:(id)sender
{
    UIButton *btnTab=(UIButton *)sender;
    MedicalDisplayHeaderCell *cell=(MedicalDisplayHeaderCell *) [tblView viewWithTag:100];
    currentlySelctecdTab=btnTab.tag;
    switch (btnTab.tag)
    {
        case 0:
            [cell.contentView bringSubviewToFront:btnTab];
            [cell.btnTab1 setSelected:YES];
            [cell.btnTab2 setSelected:NO];
            [cell.btnTab3 setSelected:NO];
            break;
        case 1:
            [cell.contentView bringSubviewToFront:btnTab];
            [cell.btnTab1 setSelected:NO];
            [cell.btnTab2 setSelected:YES];
            [cell.btnTab3 setSelected:NO];
            break;
        case 2:
            [cell.contentView bringSubviewToFront:btnTab];
            [cell.btnTab1 setSelected:NO];
            [cell.btnTab2 setSelected:NO];
            [cell.btnTab3 setSelected:YES];
            break;
            
        default:
            break;
    }
    [self loadDatafromDB];
    [tblView reloadData];
    
}


-(void)clickOnAddMedicineButton:(id)sender
{
    
    UIStoryboard *objStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    objAddMedicine=[objStoryBoard instantiateViewControllerWithIdentifier:@"AddMedicineVC"];
    objAddMedicine.strActionValue=@"Add";
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.5];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[objAddMedicine.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    objAddMedicine.medicineUpdateDelegte=self;
    [self.view addSubview:objAddMedicine.view];
  
}

#pragma mark NewMedicineUpdateDelegate

-(void)newMedicineAdd
{
    [self loadDatafromDB];
    [tblView reloadData];
}
-(void)addManagingProvider
{
    App_Delegate.strReminderString=@"";
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMediaProfessionalVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"AddMediaProfessionalVC"];
    [self.navigationController pushViewController:objMedicalScreen animated:YES];
    
}


- (void) dealloc
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

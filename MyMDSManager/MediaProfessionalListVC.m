//
//  MediaProfessionalListVC.m
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "MediaProfessionalListVC.h"
#import "ProfileHeaderCell.h"
#import "ButtonCell.h"
#import "MProffesionalContentCell.h"
#import "AddMediaProfessionalVC.h"

@interface MediaProfessionalListVC ()

@end

@implementation MediaProfessionalListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];

    [self loadDBData];
    
    [btnAddMD addTarget:self action:@selector(clickOnAddContact:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddMD setTitle:@"Add Contact" forState:UIControlStateNormal];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData];
}

-(void)loadDBData
{
    arrMediaProffetional=[App_Delegate.dbObj GetAllMedicalProvider];
    
    [self.view endEditing:YES];
    [tblView reloadData];
}
#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrMediaProffetional.count>0)
    {
        return arrMediaProffetional.count;
    }
    else
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 70;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //View for Section Header of TableView
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"MProffesionalContentCell";
        
        MProffesionalContentCell *cell = (MProffesionalContentCell *) [tableView
                                           dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MProffesionalContentCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.lblName.text=@"";
        cell.lblSpeciality.text=@"";
        cell.lblPhone.text=@"Contact Info not available";
        if (arrMediaProffetional.count>0)
        {
            NSMutableDictionary *dicValue=[arrMediaProffetional objectAtIndex:indexPath.row];
            cell.lblName.text = [dicValue valueForKey:@"name"];
            cell.lblSpeciality.text = [dicValue valueForKey:@"speciality"];
            NSString *strPhoneNo=[dicValue valueForKey:@"phone"];
            if (strPhoneNo.length>0)
            {
                cell.lblPhone.text=[NSString stringWithFormat:@"%@ %@",[dicValue valueForKey:@"countrycode"],strPhoneNo];
                cell.btnCallMe.tag=indexPath.row;
                [cell.btnCallMe addTarget:self action:@selector(clickOnCallMe:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.btnCallMe.enabled=NO;
            }
           
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
      
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != arrMediaProffetional.count)
    {
        UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddMediaProfessionalVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"AddMediaProfessionalVC"];
        objMedicalScreen.dictLocal=[arrMediaProffetional objectAtIndex:indexPath.row];
        objMedicalScreen.editTag=1;
        [self.navigationController pushViewController:objMedicalScreen animated:YES];
        
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
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableDictionary *dict = [arrMediaProffetional objectAtIndex:indexPath.row];
        [App_Delegate.dbObj deleteMedicalProffetional:[dict valueForKey:@"rowid"]];
        
        
        [App_Delegate CheckBeforeUploadMainDB];
        
        [arrMediaProffetional removeObject:dict];
        [tblView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Function Methods

-(void)clickOnCallMe:(id)sender
{
    UIButton *btnSedner=(UIButton *)sender;
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] )
    {
        UIAlertView *altView =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to make call this person?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
        altView.tag=btnSedner.tag;
        [altView show];
        
        
        
    } else
    {
        
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [warning show];
    }

}

-(IBAction)clickOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickOnAddContact:(id)sender
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMediaProfessionalVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"AddMediaProfessionalVC"];
    objMedicalScreen.editTag=0;
    [self.navigationController pushViewController:objMedicalScreen animated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"YES"])
    {
        NSMutableDictionary *dict=[arrMediaProffetional objectAtIndex:alertView.tag];
        NSString *cellNameStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"phone"]];
        NSString *phoneNumber = [@"tel://" stringByAppendingString:cellNameStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else if([title isEqualToString:@"NO"])
    {
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

//
//  MDSTreatmentListVC.m
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "MDSTreatmentListVC.h"
#import "AddMDSTreatmentVC.h"
#import "ButtonCell.h"
#import "TwoLableNotesHeaderCell.h"
#import "TwoLableNotesContentCell.h"
#import "CustomIOSAlertView.h"

@interface MDSTreatmentListVC ()

@end



@implementation MDSTreatmentListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self loadDBData];
    
    
    [btnAddTreatment addTarget:self action:@selector(clickOnAddTreatment:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddTreatment setTitle:@"Add Treatment" forState:UIControlStateNormal];
   
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData];
}
-(void)loadDBData
{
    arrTreatments=[App_Delegate.dbObj GetAllMDSTreatment];
    
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
    //count of row in section
    if (arrTreatments.count>0)
    {
        return arrTreatments.count+1;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (indexPath.row==0)
        {
            return 30;
        }
        else
            return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
            cell.lblHeading1.text=@"Date";
            cell.lblHeading2.text=@"";
            cell.lblHeading3.text=@"Notes";
            
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
            NSMutableDictionary *dicValue=[arrTreatments objectAtIndex:indexPath.row-1];
            
           
            cell.lblTitle1.text=[dicValue objectForKey:@"startdate"];
            
            cell.lblTitle2.text=@"";
            
            cell.btnNotes.superview.tag=indexPath.section;

            [cell.btnNotes addTarget:self action:@selector(clickOnShowNotes:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row !=arrTreatments.count+1 && indexPath.row>0)
    {
        UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddMDSTreatmentVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddMDSTreatmentVC"];
        objView.dictTreatment=[arrTreatments objectAtIndex:indexPath.row-1];
        objView.editFlag=1;
        [self.navigationController pushViewController:objView animated:YES];
        
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
    
    if (indexPath.row>0 && indexPath.row !=arrTreatments.count+1)
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
        if (indexPath.row>0 && indexPath.row !=arrTreatments.count+1)
        {
            NSMutableDictionary *dict = [arrTreatments objectAtIndex:indexPath.row-1];
            [App_Delegate.dbObj deleteMDSTreatmentMedicine:[dict valueForKey:@"rowid"]];
            [App_Delegate.dbObj deleteMDSTreatment:[dict valueForKey:@"rowid"]];
            
            
            [App_Delegate CheckBeforeUploadMainDB];
            
           // [self loadDBData];
             [self performSelector:@selector(loadDBData) withObject:nil afterDelay:0.5];
        }
    }
}



#pragma mark - Function Methods

-(IBAction)clickOnBack:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickOnShowNotes:(UIButton *)sender
{
    NSMutableDictionary *dicValue=[arrTreatments objectAtIndex:sender.tag];
    NSString *strNotes=[dicValue valueForKey:@"note"];
    
    
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
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex)
     {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
    
}

-(void)clickOnAddTreatment:(id)sender
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMDSTreatmentVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddMDSTreatmentVC"];
    [self.navigationController pushViewController:objView animated:YES];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

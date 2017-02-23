
//  NotesListVC.m
//  MyMDSManager

//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "NotesListVC.h"
#import "ProfileHeaderCell.h"
#import "TwoLableNotesHeaderCell.h"
#import "TwoLableNotesContentCell.h"
#import "ButtonCell.h"
#import "AddNotestVC.h"
#import "CustomIOSAlertView.h"

@interface NotesListVC ()

@end

@implementation NotesListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
   [self loadDBData];
    
    [btnAddNotes addTarget:self action:@selector(clickOnAddNotes:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddNotes setTitle:@"Add Notes" forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData];
}

-(void)loadDBData
{
    arrNotes=[App_Delegate.dbObj GetAllNotes];
    
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
    if (arrNotes.count>0)
    {
        return arrNotes.count+1;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (arrNotes.count>0)
    //{
        if (indexPath.row==0)
        {
            return 30;
        }
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
        NSMutableDictionary *dicValue=[arrNotes objectAtIndex:indexPath.row-1];
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
        cell.btnNotes.tag=indexPath.row-1;
        [cell.btnNotes addTarget:self action:@selector(clickOnShowNotes:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
        
   
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0 && indexPath.row !=arrNotes.count+1)
    {
        UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddNotestVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddNotestVC"];
        objView.dictLocal=[arrNotes objectAtIndex:indexPath.row-1];
        objView.editTag=1;
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

// for some items. By default, all items are editable.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (arrNotes.count>0)
    {
        if (indexPath.row == 0)
        {
            return NO;
        }
        
        return YES;
    }
    return  NO;
}

// Override to support editing the table view.

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.row>0 && indexPath.row !=arrNotes.count+1)
        {
            NSMutableDictionary *dict = [arrNotes objectAtIndex:indexPath.row-1];
            [App_Delegate.dbObj deleteNotes:[dict valueForKey:@"rowid"]];
            
            [App_Delegate CheckBeforeUploadMainDB];
            
            [self performSelector:@selector(loadDBData) withObject:nil afterDelay:0.5];
        }
    }
}


#pragma mark - Function Methods

-(void)clickOnShowNotes:(UIButton *)sender
{
    NSMutableDictionary *dicValue=[arrNotes objectAtIndex:sender.tag];
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
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];

    
}

-(IBAction)clickOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickOnAddNotes:(id)sender
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddNotestVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddNotestVC"];
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
}


@end

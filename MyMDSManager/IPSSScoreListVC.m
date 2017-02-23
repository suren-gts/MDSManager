//
//  IPSSScoreListVC.m
//  MyMDSManager
//
//  Created by CEPL on 13/10/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "IPSSScoreListVC.h"
#import "ButtonCell.h"
#import "ADDIPSSScoreVC.h"

#import "TwoLableNotesContentCell.h"
#import "CustomIOSAlertView.h"

#import "TwoLableNotesHeaderCell.h"

@interface IPSSScoreListVC ()

@end

@implementation IPSSScoreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadDBData];
    
    [btnAddIPSSScore addTarget:self action:@selector(clickOnAddScore:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddIPSSScore setTitle:@"Add Score" forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData];
}

-(void)loadDBData
{
    arrrTableContent=[App_Delegate.dbObj GetIPSSRScore];
    
    [self.view endEditing:YES];
    [tblView reloadData];
}

-(void)clickOnAddScore:(id)sender
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ADDIPSSScoreVC *objIPSSR=[objStoryboard instantiateViewControllerWithIdentifier:@"ADDIPSSScoreVC"];
    objIPSSR.editTag=0;
    [self.navigationController pushViewController:objIPSSR animated:YES];
}


-(IBAction)clickOnBack:(id)sender
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
    if (arrrTableContent.count>0)
    {
        return arrrTableContent.count+1;
    }
    else
    {
        return 0;
    }
    return 0;
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
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //View for Section Header of TableView
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
        cell.lblHeading2.text=@"Score";
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
        NSMutableDictionary *dicValue=[arrrTableContent objectAtIndex:indexPath.row-1];
        NSArray *arr=[[dicValue valueForKey:@"IPSSRDate"] componentsSeparatedByString:@"  "];
        if (arr.count>1)
        {
            cell.lblTitle1.text=[arr objectAtIndex:0];
        }
        else
        {
            cell.lblTitle1.text=[dicValue valueForKey:@"IPSSRDate"];
        }
        cell.lblTitle2.text=[dicValue valueForKey:@"IPSSRSocre"];
        cell.btnNotes.tag=indexPath.row-1;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != arrrTableContent.count+1 && indexPath.row>0)
    {
        UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ADDIPSSScoreVC *objIPSSR=[objStoryboard instantiateViewControllerWithIdentifier:@"ADDIPSSScoreVC"];
        objIPSSR.dictLocal=[arrrTableContent objectAtIndex:indexPath.row-1];
        objIPSSR.editTag=1;
        [self.navigationController pushViewController:objIPSSR animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// for some items. By default, all items are editable.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrrTableContent.count>0)
    {
        if (indexPath.row == 0)
        {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableDictionary *dict = [arrrTableContent objectAtIndex:indexPath.row-1];
        [App_Delegate.dbObj deleteIPSSRScore:[dict valueForKey:@"rowid"]];
        [arrrTableContent removeObject:dict];
        
         [self performSelector:@selector(loadDBData) withObject:nil afterDelay:0.5];
       
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

//
//  BoneMarroResultVC.m
//  MyMDSManager

//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "BoneMarroResultVC.h"

#import "ButtonCell.h"
#import "AddBoneResultVC.h"

#import "ThreeLableHeaderCell.h"
#import "ThreeLableContentCell.h"


@interface BoneMarroResultVC ()

@end

@implementation BoneMarroResultVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDBData];
    [btnAddBoneMarro addTarget:self action:@selector(clickOnAddTreatment:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddBoneMarro setTitle:@"Add Result" forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData];
    
}

-(void)loadDBData
{
    arrBoneMerrowResults=[App_Delegate.dbObj GetAllBoneMarrowResult];
    
    [self.view endEditing: YES];
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
    if (arrBoneMerrowResults.count>0)
    {
        return arrBoneMerrowResults.count+1;
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
    //if (arrBoneMerrowResults.count>0)
    //{
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
            cell.lblHeading1.text=@"Date";
            cell.lblHeading2.text=@"Description";
            cell.lblHeading3.text=@"Bone Blast";
            
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
            NSMutableDictionary *dicValue=[arrBoneMerrowResults objectAtIndex:indexPath.row-1];
            
            cell.lblTitle1.text=[dicValue valueForKey:@"date"];
            
            cell.lblTitle2.text=[dicValue valueForKey:@"description"];
            cell.lblTitle3.text=[dicValue valueForKey:@"boneblast"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row !=arrBoneMerrowResults.count+1 && indexPath.row>0)
    {
        UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddBoneResultVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddBoneResultVC"];
        objView.dictBoneMerrow=[arrBoneMerrowResults objectAtIndex:indexPath.row-1];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    
    if (indexPath.row>0 && indexPath.row !=arrBoneMerrowResults.count+1)
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
        if (indexPath.row>0 && indexPath.row !=arrBoneMerrowResults.count+1)
        {
            NSMutableDictionary *dict = [arrBoneMerrowResults objectAtIndex:indexPath.row-1];
            [self deleteAllImageFromLocal:dict];
            [App_Delegate.dbObj deleteBoneMarrowResult:[dict valueForKey:@"rowid"]];
            
            
            [App_Delegate CheckBeforeUploadMainDB];
            
            [self performSelector:@selector(loadDBData) withObject:nil afterDelay:0.5];
            
        }
    }
}


#pragma mark - Function Methods

-(void)deleteAllImageFromLocal:(NSMutableDictionary *)dict
{
    NSArray *arrImageName;
    NSString *strBoneImage=[dict valueForKey:@"boneimages"];
    if (strBoneImage.length>0)
    {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
        arrImageName=[[strBoneImage componentsSeparatedByString:@","] mutableCopy];

        for (int j=0; j<arrImageName.count; j++)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *filePath = [dataPath stringByAppendingPathComponent:[arrImageName objectAtIndex:j]];
            [fileManager removeItemAtPath:filePath error:NULL];
        }
    }
}

-(IBAction)clickOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickOnAddTreatment:(id)sender
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddBoneResultVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddBoneResultVC"];
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

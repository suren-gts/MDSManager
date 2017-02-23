//
//  InicialLabResultVC.m
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "InicialLabResultVC.h"
#import "ProfileHeaderCell.h"
#import "ButtonCell.h"
#import "LabResultObject.h"
#import "AddInitialLabResultVC.h"
#import "ThreeLableContentCell.h"
#import "ThreeLableHeaderCell.h"

@interface InicialLabResultVC ()

@end

@implementation InicialLabResultVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    dictColleps=[[NSMutableDictionary alloc]init];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    
    if ([self.strEntryFlag isEqualToString:@"I"])
    {
        lblPageTitle.text = @"Initial Lab Results";
        arrBloodCellsTest=[App_Delegate.dbObj getAllBloodCellInitialLabResult];
    }
    else
    {
        lblPageTitle.text = @"Ongoing Lab Results";
        arrBloodCellsTest=[App_Delegate.dbObj getAllBloodCellOnGoingLabResult];
    }
    
    [btnAddInitial addTarget:self action:@selector(clickOnAddBloodCounts:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddInitial setTitle:@"Add Lab Result" forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDataFromDB];
}

-(void)loadDataFromDB
{
    if ([self.strEntryFlag isEqualToString:@"I"])
    {
        arrBloodCellsTest=[App_Delegate.dbObj getAllBloodCellInitialLabResult];
        [self.view endEditing:YES];
        [tblView reloadData];
    }
    else
    {
        arrBloodCellsTest=[App_Delegate.dbObj getAllBloodCellOnGoingLabResult];
        [self.view endEditing:YES];
        [tblView reloadData];
    }
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (section==BloodCount)
    {
        NSString *strSection=[NSString stringWithFormat:@"Section%ld",section];
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        if (arrBloodCellsTest.count>0)
        {
           return arrBloodCellsTest.count+1;
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
    //Height of Row in Tableview
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",indexPath.section];
    if ([dictColleps valueForKey:strSection])
    {
        return 0;
    }
    if (indexPath.section==BloodCount)
    {
        if (arrBloodCellsTest.count>0)
        {
            if (indexPath.row==0)
            {
                return 30;
            }
            return 44;
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
    
    
    //to remove expand and collapse function 
    btnCollops.hidden=YES;
    
    
    lblTitle.text=@"Blood Counts & Diagnostic Tests";
    
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
    if (indexPath.section==BloodCount)
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
            cell.lblHeading1.text=@"Diagnosis Test";
            cell.lblHeading2.text=@"Normal Result";
            cell.lblHeading3.text=@"My Result";

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
            LabResultObject *objDia=[arrBloodCellsTest objectAtIndex:indexPath.row-1];
            cell.lblTitle1.text=objDia.strDiagnosisTest;
            
            
            NSMutableDictionary *dictNormal;
            if ([App_Delegate.dictNormal objectForKey:objDia.strDiagnosisTest])
            {
                
                dictNormal = [App_Delegate.dictNormal objectForKey:objDia.strDiagnosisTest];
            }
            if (!dictNormal)
            {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:objDia.strDiagnosisTest])
                {
                    dictNormal = [[NSUserDefaults standardUserDefaults] objectForKey:objDia.strDiagnosisTest];
                }
            }
            
            if (dictNormal)
            {
                if ([App_Delegate.objAppPerson.strGender isEqualToString:@"Male"])
                {
                    cell.lblTitle2.text = [NSString stringWithFormat:@"%@ %@",[dictNormal valueForKey:@"normal_value_male"],[dictNormal valueForKey:@"unit"]];
                }
                else
                {
                    cell.lblTitle2.text = [NSString stringWithFormat:@"%@ %@",[dictNormal valueForKey:@"normal_value_female"],[dictNormal valueForKey:@"unit"]];
                }
            }
            else
            {
                
                cell.lblTitle2.text = @"N/A";
            }
            cell.lblTitle3.text=objDia.strResult;;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.section==BloodCount)
    {
        if (indexPath.row != arrBloodCellsTest.count+1 && indexPath.row>0)
        {
            AddInitialLabResultVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddInitialLabResultVC"];
            if ([self.strEntryFlag isEqualToString:@"I"])
            {
                objView.entryTag=0;
            }
            else
            {
                objView.entryTag=1;
            }
            
            objView.editFlag=1;
            objView.objLabResult=[arrBloodCellsTest objectAtIndex:indexPath.row-1];
            [self.navigationController pushViewController:objView animated:YES];
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

// for some items. By default, all items are editable.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.

    if (indexPath.section == BloodCount)
    {
        if (indexPath.row != arrBloodCellsTest.count+1 && indexPath.row>0)
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
        LabResultObject *objDel = [arrBloodCellsTest objectAtIndex:indexPath.row-1];
        [self deleteAllImageFromLocal:objDel];
        [App_Delegate.dbObj deleteInitialLabReuslts:objDel.strId];
        
        
        [self performSelector:@selector(loadDBdata) withObject:nil afterDelay:0.5];
        
    }
    
}

-(void)loadDBdata
{
    arrBloodCellsTest=[App_Delegate.dbObj getAllBloodCellInitialLabResult];
    [self.view endEditing:YES];
    [tblView reloadData];
}

#pragma mark - Function Methods
-(void)deleteAllImageFromLocal:(LabResultObject *)objDel
{
    NSArray *arrImageName;
    NSString *strLabImage=objDel.strLabImages;
    if (strLabImage.length>0)
    {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
        arrImageName=[[strLabImage componentsSeparatedByString:@","] mutableCopy];
        
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

-(void)clickOnAddBloodCounts:(id)sender
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddInitialLabResultVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddInitialLabResultVC"];
    if ([self.strEntryFlag isEqualToString:@"I"])
    {
        objView.entryTag=0;
    }
    else
    {
        objView.entryTag=1;
    }
    [self.navigationController pushViewController:objView animated:YES];
}


-(void)clickOnAddDiagnosis:(id)sender
{
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddInitialLabResultVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddInitialLabResultVC"];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

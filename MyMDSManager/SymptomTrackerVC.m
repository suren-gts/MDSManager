//
//  SymptomTrackerVC.m
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "SymptomTrackerVC.h"
#import "SymptomAddNotesCell.h"
#import "SymptomTextFieldCell.h"
#import "SeverityCell.h"
#import "AddSymptomCell.h"
#import "SymptomDateTimeCell.h"
#import "SymptomButtonCell.h"
#import "SymptomListVC.h"
#import "ProfileHeaderCell.h"

@interface SymptomTrackerVC ()

@end
#define SymptomTableTag             101

#define SymptomBackAlertTag         202


@implementation SymptomTrackerVC
@synthesize objLocalSymptom,strEntrValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuContainerViewController.panMode=MFSideMenuPanModeNone;
    if (!self.objLocalSymptom)
    {
        objLocalSymptom=[[SymptomObject alloc]initDefaults];
        
    }
    else
    {
        btnHistory.hidden=YES;
    }
    //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    txtTemp.delegate=self;
    tvTemp.delegate=self;
    
    
    [self createAddSymptomView];
    
    SomeEdit = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
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
    if (tableView.tag == SymptomTableTag)
    {
        return arrOtherSymptomeList.count;
    }
    else
    {
        if (section==0)
        {
            if ([self.strEntrValue isEqualToString:@"view"])
            {
                return 7;
            }
            else  if ([self.strEntrValue isEqualToString:@"edit"])
            {
                return 8;
            }
            return 9;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Row in Tableview
    if (tableView.tag == SymptomTableTag)
    {
        return 44;
    }
    else
    {
        if (indexPath.row==SymptomSeverity)
        {
            return 130;
        }
        else if (indexPath.row==SymptomNotes)
        {
            return 140;
        }
        else if (indexPath.row==SymptomDuration || indexPath.row==SymptomFrequency)
        {
            return 70;
        }
        else if (indexPath.row==SymptomHistory)
        {
            return 44;
        }
        return 60;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    if (tableView.tag ==SymptomTableTag)
    {
        return 30;
    }
    else
    {
        return 0;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag ==SymptomTableTag)
    {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 30)];
        headerView.backgroundColor=[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0];
        UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, tblView.frame.size.width-20, 21)];
        lblTitle.textColor=[UIColor whiteColor];
        [lblTitle setText:@"User's Custom Symptom List"];
        [headerView addSubview:lblTitle];
        return headerView;
    }
    else
    {
        return nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==SymptomTableTag)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier] ;
        }
        if (arrOtherSymptomeList.count>0)
        {
            NSMutableDictionary *dict = [arrOtherSymptomeList objectAtIndex:indexPath.row];
            cell.textLabel.text = [dict valueForKey:@"Symptom"];
        }

        return cell;
    }
    else
    {
        if (indexPath.row==SymptomCat)
        {
            static NSString *CellIdentifier = @"AddSymptomCell";
            
            AddSymptomCell *cell = (AddSymptomCell *) [tableView
                                                       dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddSymptomCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            
            if ([self.strEntrValue isEqualToString:@"view"])
            {
               cell.btnSelectSymptom.userInteractionEnabled=NO;
            }
            else
            {
                cell.btnSelectSymptom.tag=indexPath.row;
                cell.btnSelectSymptom.superview.tag=indexPath.section;
                [cell.btnSelectSymptom addTarget:self action:@selector(clickOnValuePicker:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.txtValue.text=objLocalSymptom.strSymptom;
            cell.txtValue.placeholder = @"Select Symptom Category *";
            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }
        else if (indexPath.row==SymptomSubCat)
        {
            static NSString *CellIdentifier = @"AddSymptomCell";
            
            AddSymptomCell *cell = (AddSymptomCell *) [tableView
                                                       dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddSymptomCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            
            if ([self.strEntrValue isEqualToString:@"view"])
            {
                cell.btnSelectSymptom.userInteractionEnabled=NO;
            }
            else
            {
                cell.btnSelectSymptom.tag=indexPath.row;
                cell.btnSelectSymptom.superview.tag=indexPath.section;
                [cell.btnSelectSymptom addTarget:self action:@selector(clickOnValuePicker:) forControlEvents:UIControlEventTouchUpInside];

            }
            cell.txtValue.text=objLocalSymptom.strSymptomSubCat;
            cell.txtValue.placeholder = @"Select Symptom Sub Category *";
            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }
        else if (indexPath.row==SymptomSeverity)
        {
            static NSString *CellIdentifier = @"SeverityCell";
            
            SeverityCell *cell = (SeverityCell *) [tableView
                                                   dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SeverityCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
                [cell setupAppearance];
            }
            if ([self.strEntrValue isEqualToString:@"view"])
            {
                cell.sliderSeverity.userInteractionEnabled=NO;
            }
            else
            {
                [cell.sliderSeverity addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.sliderSeverity.value=[objLocalSymptom.strServirty intValue];
            
            cell.backgroundColor=[UIColor clearColor];
            return cell;
            
        }
        else if (indexPath.row==SymptomDateNTime)
        {
            static NSString *CellIdentifier = @"SymptomDateTimeCell";
            
            SymptomDateTimeCell *cell = (SymptomDateTimeCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomDateTimeCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            
            if ([self.strEntrValue isEqualToString:@"view"])
            {
                cell.btnDate.userInteractionEnabled=NO;
                cell.btnTime.userInteractionEnabled=NO;
            }
            else
            {
                cell.btnTime.tag=100;
                
                [cell.btnTime addTarget:self action:@selector(clickOnOpenDatePicker:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnDate.tag=0;
                
                [cell.btnDate addTarget:self action:@selector(clickOnOpenDatePicker:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            cell.txtTime.text=objLocalSymptom.strTime;
            cell.txtDate.text=objLocalSymptom.strDate;
            
            cell.backgroundColor=[UIColor clearColor];
            return cell;
            
        }
        else if (indexPath.row==SymptomNotes)
        {
            static NSString *CellIdentifier = @"SymptomAddNotesCell";
            
            SymptomAddNotesCell *cell = (SymptomAddNotesCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomAddNotesCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            cell.tvNotes.text=objLocalSymptom.strNotes;
            if ([self.strEntrValue isEqualToString:@"view"])
            {
                cell.tvNotes.editable=NO;
            }
            else
            {
                cell.tvNotes.delegate=self;
                cell.tvNotes.inputAccessoryView = numberToolbar;
            }
            
            cell.backgroundColor=[UIColor clearColor];
            return cell;
            
        }
        else if (indexPath.row==SymptomButton)
        {
            static NSString *CellIdentifier = @"SymptomButtonCell";
            
            SymptomButtonCell *cell = (SymptomButtonCell *) [tableView
                                                             dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomButtonCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            cell.backgroundColor=[UIColor clearColor];
            [cell.btnChart setTitle:@"Save Symptom" forState:UIControlStateNormal];
            [cell.btnChart addTarget:self action:@selector(clickOnSaveSymptom:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }
        else if (indexPath.row==SymptomHistory)
        {
            static NSString *CellIdentifier = @"ProfileHeaderCell";
            
            ProfileHeaderCell *cell = (ProfileHeaderCell *) [tableView
                                                             dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileHeaderCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            cell.btnActions.hidden=YES;
            cell.btnActions.userInteractionEnabled=NO;
            cell.btnColleps.userInteractionEnabled=NO;
            
            [cell.btnColleps setImage:[UIImage imageNamed:@"icn_forward.png"] forState:UIControlStateNormal];
            
            cell.contentView.backgroundColor=[UIColor colorWithRed:33.0/255.0 green:148.0/255.0 blue:205.0/255.0 alpha:1.0];
            cell.lblHeaderTitle.text = @"View Symptom History";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else
        {
            static NSString *CellIdentifier = @"SymptomTextFieldCell";
            
            SymptomTextFieldCell *cell = (SymptomTextFieldCell *) [tableView
                                                                   dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomTextFieldCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            if ([self.strEntrValue isEqualToString:@"view"])
            {
                cell.txtValue.userInteractionEnabled=NO;
            }
            else
            {
                cell.txtValue.delegate=self;
                cell.txtValue.tag=indexPath.row;
                cell.txtValue.superview.tag=indexPath.section;
                //cell.txtValue.keyboardType=UIKeyboardTypeNumberPad;
                cell.txtValue.inputAccessoryView=numberToolbar;
                cell.txtValue.userInteractionEnabled=YES;
            }
            
            if (indexPath.row==SymptomDuration)
            {
                cell.lblTitle.text=@"Duration - Lasts for...";
                cell.txtValue.placeholder=@"Enter Duration";
                cell.txtValue.text=objLocalSymptom.strDuration;
            }
            else  if (indexPath.row==SymptomFrequency)
            {
                cell.lblTitle.text=@"Frequency - Happens every...";
                cell.txtValue.placeholder=@"Enter Frequency";
                cell.txtValue.text=objLocalSymptom.strFrequency;
                
            }
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==SymptomHistory)
    {
        [self clickOnShowSymptomHistory:nil];
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
    
    if (tableView.tag == SymptomTableTag)
    {
        return  YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==SymptomTableTag)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            if (tableView.tag==SymptomTableTag)
            {
                NSMutableDictionary *dict = [arrOtherSymptomeList objectAtIndex:indexPath.row];
                [App_Delegate.dbObj deleteUserCreateSymptom:[dict valueForKey:@"rowid"]];
                arrOtherSymptomeList = [App_Delegate.dbObj getAllSymptomWithId];
                if (arrOtherSymptomeList.count>0)
                {
                    tblSymptomList.hidden=NO;
                    [tblSymptomList reloadData];
                }
                else
                {
                    tblSymptomList.hidden=YES;
                }

                
            }
        }
    }
}

#pragma mark Action Sheet Methods

-(void)clickOnValuePicker:(id)sender
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
    UIButton *btnSender=(UIButton *)sender;
    if (btnSender.tag == SymptomSubCat && [objLocalSymptom.strSymptom isEqualToString:@""])
    {
        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select Symptom Category before the selection of subcategory" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]; 
        [altView show];
    }
    else
    {
        if (!isActionSheetVisible)
        {
            isActionSheetVisible=YES;
            
            [txtTemp resignFirstResponder];
            objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
            objPicker.valueDelegate=self;
            objPicker.rowId=btnSender.tag;
            objPicker.sectionId=btnSender.superview.tag;
            objPicker.EntryTag=2;
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
}

-(void)clickOnValuePicker:(NSInteger)rowTag withSection:(NSInteger)sectionTag
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
    if (!isActionSheetVisible)
    {
        isActionSheetVisible = YES;
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
        objPicker.rowId=rowTag;
        objPicker.sectionId=sectionTag;
        objPicker.EntryTag=2;
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
    SomeEdit=1;
    
    isActionSheetVisible=NO;
    if (row==SymptomCat)
    {
        if ([strValue isEqualToString:@"Other"])
        {
            [self clickOnAddSymptom:nil];
        }
        else
        {
            if (![App_Delegate.strSymptomCat isEqualToString:strValue])
            {
                objLocalSymptom.strSymptomSubCat = @"";
            }
            App_Delegate.strSymptomCat = strValue;
            objLocalSymptom.strSymptom=strValue;
            
        }
    }
    else if (row==SymptomSubCat)
    {
        if ([strValue isEqualToString:@"Other"])
        {
            [self clickOnAddSymptom:nil];
        }
        else
        {
            objLocalSymptom.strSymptomSubCat=strValue;
        }

    }
    else if(row==SymptomDuration)
    {
        objLocalSymptom.strDuration=strValue;
    }
    else
    {
        objLocalSymptom.strFrequency=strValue;
    }
    
    [tblView reloadData];
}

-(void)clickOnOpenDatePicker:(id)sender
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }

    if (!isActionSheetVisible)
    {
        isActionSheetVisible=YES;
        UIButton *btnSender=(UIButton *)sender;
        entryTag=btnSender.tag;
        [txtTemp resignFirstResponder];
        objDatePicker=[[DatePickerVC alloc] initWithNibName:@"DatePickerVC" bundle:nil];
        objDatePicker.datePickerDel=self;
        objDatePicker.entryTag=btnSender.tag;
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
}

-(void)didSelectDate:(NSDate *)selectedDate
{
    isActionSheetVisible=NO;
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    
    if (entryTag==100)
    {
        [dateformater setDateFormat:@"hh:mm a"];
        objLocalSymptom.timeValue=selectedDate;
        objLocalSymptom.strTime=[dateformater stringFromDate:selectedDate];
    }
    else
    {
        [dateformater setDateFormat:@"MMM dd, yyyy"];
        objLocalSymptom.dateValue=selectedDate;
        objLocalSymptom.strDate=[dateformater stringFromDate:selectedDate];
        
        double DateInDouble=[selectedDate timeIntervalSince1970];
        objLocalSymptom.dateToOrder=DateInDouble;
        
    }
    
    SomeEdit=1;
    
    [tblView reloadData];
}

-(void)didCancelPicker
{
    isActionSheetVisible=NO;
}


#pragma mark - Function Methods

-(IBAction)clickOnShowSymptomHistory:(id)sender
{
    UIStoryboard *objStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SymptomListVC *objSymptom=[objStory instantiateViewControllerWithIdentifier:@"SymptomListVC"];
    [self.navigationController pushViewController:objSymptom animated:YES];
}

-(IBAction)clickOnSaveSymptom:(id)sender
{
    if (objLocalSymptom.strSymptom.length>0 && objLocalSymptom.strSymptomSubCat.length>0 && objLocalSymptom.strServirty.length>0 && objLocalSymptom.strDate.length>0 )
    {
        if ([self.strEntrValue isEqualToString:@"edit"])
        {
            [App_Delegate.dbObj updateSymptomInfoList:objLocalSymptom];
            
            UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Symptom is Updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            alt.tag = 212;
            [alt show];
           
        }
        else
        {
            [App_Delegate.dbObj insertSymptomInfoList:objLocalSymptom];
            [[NSUserDefaults standardUserDefaults]setValue:objLocalSymptom.strSymptomSubCat forKey:@"LastAddedSymptom"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            objLocalSymptom=nil;
            objLocalSymptom=[[SymptomObject alloc]initDefaults];
            [tblView reloadData];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsLatestUpdate"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Symptom is saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [alt show];
            
        }
        
        SomeEdit = 0;
        
        [self performSelector:@selector(Upload) withObject:nil afterDelay:1.0];
        
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the information before click on save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alt show];
    }
}

-(void)Upload
{
    [App_Delegate CheckBeforeUploadMainDB];
}



-(IBAction)clickOnBack:(id)sender
{
    if (SomeEdit==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *ai=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Do you want to go back without saving your changes?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        ai.tag=SymptomBackAlertTag;
        [ai show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 212)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag==SymptomBackAlertTag)
    {
        if (buttonIndex==1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


-(void)updateSliderValue:(UISlider *)senderSlider
{
    float sValue=senderSlider.value;
    float value=(int)sValue;
    value+=.50;
    int A;
    if (value>sValue)
    {
        A=(int)value;
    }
    else
    {
        A=(int)sValue+1;
    }
    objLocalSymptom.strServirty=[NSString stringWithFormat:@"%d",A];
    NSLog(@"Severity: %@",objLocalSymptom.strServirty);
    
    SomeEdit=1;
    
    [tblView reloadData];
}

-(void)createAddSymptomView
{
    if (!addSymptomView)
    {
        addSymptomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [addSymptomView setBackgroundColor:[UIColor lightTextColor]];
    }
    UIView *viewBack = [[UIView alloc] init];
    viewBack.frame = addSymptomView.frame;
    [viewBack setBackgroundColor:[UIColor darkTextColor]];
    viewBack.alpha = 0.8;
    [addSymptomView addSubview:viewBack];
    [addSymptomView sendSubviewToBack:viewBack];
    
    UIView *subResultView=[[UIView alloc]initWithFrame:CGRectMake(5, 0, 310, self.view.frame.size.height-100)];
    subResultView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [subResultView setBackgroundColor:[UIColor whiteColor]];
    subResultView.layer.cornerRadius=5.0;
    subResultView.layer.masksToBounds=YES;
    [addSymptomView addSubview:subResultView];
   
    UIButton *btnclose=[[UIButton alloc]initWithFrame:CGRectMake(275,0, 35, 35)];
    [btnclose setTitle:@"X" forState:UIControlStateNormal];
    [btnclose.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [btnclose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclose setBackgroundColor:[UIColor redColor]];
    [btnclose addTarget:self action:@selector(clickOnRemoveView) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnclose];
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 50, 280, 29)];
    [lblTitle setText:@"Symptoms"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor redColor]];
    [lblTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0]];
   
    [subResultView addSubview:lblTitle];
   
    
    txtsymptom=[[UITextField alloc]initWithFrame:CGRectMake(15, 105, 280, 35)];
    [txtsymptom setBorderStyle:UITextBorderStyleLine];
    txtsymptom.delegate=self;
    txtsymptom.tag=101;
    txtsymptom.placeholder=@"Enter Symptom";
    txtsymptom.inputAccessoryView = numberToolbar;
    [subResultView addSubview:txtsymptom];
 
    UIButton *btnAddSymptom=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddSymptom setFrame:CGRectMake(15, 215, 280, 35)];
    [btnAddSymptom setTitle:@"Add Symptom" forState:UIControlStateNormal];
    [btnAddSymptom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAddSymptom setBackgroundImage:[UIImage imageNamed:@"btn_add_diagnosis.png"] forState:UIControlStateNormal];
    [btnAddSymptom addTarget:self action:@selector(addOtherSymptom) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnAddSymptom];
    
    
    tblSymptomList = [[UITableView alloc] initWithFrame:CGRectMake(0,265, 310, subResultView.frame.size.height-265) style:UITableViewStylePlain];
    tblSymptomList.delegate=self;
    tblSymptomList.dataSource=self;
    tblSymptomList.tag=SymptomTableTag;
    tblSymptomList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [subResultView addSubview:tblSymptomList];

    arrOtherSymptomeList = [App_Delegate.dbObj getAllSymptomWithId];

}


-(void)addOtherSymptom
{
    if (txtsymptom.text.length>0)
    {
        objLocalSymptom.strSymptomSubCat = txtsymptom.text;
        
        [tblView reloadData];
        [App_Delegate.dbObj createSymptom:txtsymptom.text withDescription:App_Delegate.strSymptomCat];
        txtsymptom.text=@"";
        [addSymptomView removeFromSuperview];
   
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter symptom before submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alt show];
    }
    
}

-(void)clickOnAddSymptom:(id)sender
{
    arrOtherSymptomeList = [App_Delegate.dbObj getAllSymptomWithId];
    if (arrOtherSymptomeList.count > 0)
    {
        tblSymptomList.hidden = NO;
        [tblSymptomList reloadData];
    }
    else
    {
        tblSymptomList.hidden = YES;
        [tblView reloadData];
    }
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.view addSubview:addSymptomView];
                    } completion:NULL];
}

-(void)clickOnRemoveView
{
    txtsymptom.text=@"";
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [addSymptomView removeFromSuperview];
                    } completion:NULL];
    
    
}
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==101)
    {
        return YES;
    }
    else if(textField.tag == SymptomDuration || textField.tag == SymptomFrequency)
    {
        [self clickOnValuePicker:textField.tag withSection:textField.superview.tag];
    }
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtTemp=textField;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (IsUp)
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
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,-150,self.view.frame.size.width,self.view.frame.size.height)];
}

-(void)MoveViewDown
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}

-(void)doneWithNumberPad
{
    if (txtTemp)
    {
        [txtTemp resignFirstResponder];
    }
    if (tvTemp)
    {
        [tvTemp resignFirstResponder];
    }
    if (IsUp)
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

#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    tvTemp=textView;
    IsUp=YES;
    [UIView animateWithDuration:0.40f animations:
     ^{
         [self MoveViewUp];
     }
                     completion:^(BOOL finished)
     {}];
    
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    SomeEdit=1;
    
    objLocalSymptom.strNotes=textView.text;
    IsUp=NO;
    [UIView animateWithDuration:0.40f animations:
     ^{
         [self MoveViewDown];
     }
                     completion:^(BOOL finished)
     {}];

    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   return YES;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)range
{
    return YES;
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
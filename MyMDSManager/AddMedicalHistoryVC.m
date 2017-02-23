//
//  AddMedicalHistoryVC.m
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "AddMedicalHistoryVC.h"
#import "AddMediaProfessionalVC.h"
#define OtherListTableTag 333
@interface AddMedicalHistoryVC ()

@end

@implementation AddMedicalHistoryVC
@synthesize entryTag,objDiagnosis,editFlag;

#define AlertEditTag            666

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    if (!self.objDiagnosis)
    {
        objDiagnosis=[[DiagnosisObject alloc]initDefaults];    
    }
    
    if (self.entryTag==0)
    {
         btnDiagnosisList.hidden = NO;
        lblDiagnosis.text=@"Diagnosis *";
        lblDate.text=@"Date";
        if (self.editFlag==0)
        {
            lblPageTitle.text=@"ADD DIAGNOSIS";
        }
        else
        {
            lblPageTitle.text=@"UPDATE DIAGNOSIS";
            txtDiagnosis.text=objDiagnosis.strDiagnosis;
            txtNotes.text=objDiagnosis.strNotes;
            txtProvider.text=objDiagnosis.strManagingProvider;
            [btnDate setTitle:objDiagnosis.strDate forState:UIControlStateNormal];
            btnDiagnosisList.hidden = NO;
            btnDiagnosisList.userInteractionEnabled = YES;
            txtDiagnosis.userInteractionEnabled = NO;
        }
    }
    else
    {
         btnDiagnosisList.hidden = YES;
        lblDiagnosis.text=@"Surgery *";
        lblDate.text=@"Date *";
        if (self.editFlag==0)
        {
            lblPageTitle.text=@"ADD SURGERY";
        }
        else
        {
            lblPageTitle.text=@"UPDATE SURGERY";
            txtDiagnosis.text=objDiagnosis.strDiagnosis;
            txtNotes.text=objDiagnosis.strNotes;
            txtProvider.text=objDiagnosis.strManagingProvider;
            [btnDate setTitle:objDiagnosis.strDate forState:UIControlStateNormal];
          //  btnDiagnosisList.hidden = YES;
            btnDiagnosisList.userInteractionEnabled = YES;
           // [self.view sendSubviewToBack:btnDiagnosisList];
            txtDiagnosis.userInteractionEnabled = NO;
        }
    }
    //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    txtNotes.inputAccessoryView=numberToolbar;
    txtDiagnosis.inputAccessoryView=numberToolbar;
    [self createViewOtherFromList];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    if (![App_Delegate.strProviderForDiagnosis isEqualToString:@"0"])
    {
        objDiagnosis.strManagingProvider = App_Delegate.strProviderForDiagnosis;
        txtProvider.text = App_Delegate.strProviderForDiagnosis;
        App_Delegate.strProviderForDiagnosis = @"0";
    }
}

#pragma mark General Funtions

-(void)doneWithNumberPad
{
    [txtTemp resignFirstResponder];
    [txtNotes resignFirstResponder];
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


-(IBAction)clickOnSave:(id)sender
{
    UIButton *btnSender=(UIButton *)sender;
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
  
    objDiagnosis.strDiagnosis=txtDiagnosis.text;
    objDiagnosis.strManagingProvider=txtProvider.text;
    
    if (self.entryTag==0)
    {
        if (objDiagnosis.strDiagnosis.length>0)
        {
            if (self.editFlag==0)
            {
                [App_Delegate.dbObj insertDiagnosisHistory:objDiagnosis];
            }
            else
            {
                [App_Delegate.dbObj updateMedicalHistory:objDiagnosis];
            }
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsLatestUpdate"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            
            [App_Delegate CheckBeforeUploadMainDB];

            
            if (btnSender.tag==1)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [altView show];
        }
    }
    else
    {
        if (objDiagnosis.strDiagnosis.length>0 && objDiagnosis.strDate.length>0)
        {
            if (self.editFlag==0)
            {
                [App_Delegate.dbObj insertSurgicalHistory:objDiagnosis];
            }
            else
            {
                [App_Delegate.dbObj updateMedicalHistory:objDiagnosis];
            }
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsLatestUpdate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [App_Delegate CheckBeforeUploadMainDB];


            if (btnSender.tag==1)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
           
        }
        else
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [altView show];
            
        }
    }
    
}

-(IBAction)clickOnBack:(id)sender
{
    if (isEdit)
    {
        UIAlertView *ai=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Do you want to back without save changes" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        ai.tag = AlertEditTag;
        [ai show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(IBAction)clickOnValuePicker:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        btnDiagnosisList.enabled=NO;
        [txtTemp resignFirstResponder];
        [tvTemp resignFirstResponder];
        if (IsUp)
        {
            IsUp=NO;
            [self MoveViewDown];
        }
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
        
        if (self.entryTag==0)
        {
            objPicker.EntryTag=10;
        }
        else
        {
            objPicker.EntryTag=18;
        }
        
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
    else
    {
        if ([App_Delegate.dbObj GetAllMedicalProvidersName].count>0)
        {
            btnProvider.enabled=NO;
            [txtTemp resignFirstResponder];
            [tvTemp resignFirstResponder];
            if (IsUp)
            {
                IsUp=NO;
                [self MoveViewDown];
            }
            objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
            objPicker.valueDelegate=self;
            objPicker.EntryTag=6;
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
        else
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Provider list not found! Please add provider." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            altView.tag=105;
            [altView show];
        }
    }
    
}

-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger)section andForRow:(NSInteger)row
{
     isEdit = YES;
    if (intIndex == 10 || intIndex == 18)
    {
        btnDiagnosisList.enabled=YES;
        if ([strValue isEqualToString:@"Other"])
        {
            [self clickOnOtherFromList];
        }
        else
        {
            txtDiagnosis.text=strValue;
        }
    }
    else
    {
        btnProvider.enabled=YES;
        txtProvider.text=strValue;
    }
    
}

-(IBAction)clickOnOpenDatePicker:(id)sender
{
    btnDate.enabled=NO;
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
   
    objDatePicker=[[DatePickerVC alloc] initWithNibName:@"DatePickerVC" bundle:nil];
    objDatePicker.datePickerDel=self;
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

-(void)didSelectDate:(NSDate *)selectedDate
{
     isEdit = YES;
    btnDate.enabled=YES;
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateStyle:NSDateFormatterMediumStyle];
    objDiagnosis.strDate=[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]];
     [btnDate setTitle:objDiagnosis.strDate forState:UIControlStateNormal];
    
}

-(void)didCancelPicker
{
    btnProvider.enabled=YES;
    btnDate.enabled=YES;
    btnDiagnosisList.enabled=YES;
}

-(IBAction)clickOnAddContact:(id)sender
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMediaProfessionalVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"AddMediaProfessionalVC"];
    App_Delegate.strProviderForDiagnosis = @"1";
    [self.navigationController pushViewController:objMedicalScreen animated:YES];
}

//Code To Open Add Other List View
//Code to create View of add Other list Items

-(void)createViewOtherFromList
{
    if (!viewOtherValue)
    {
        viewOtherValue=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [viewOtherValue setBackgroundColor:[UIColor lightTextColor]];
    }
    UIView *viewBack = [[UIView alloc] init];
    viewBack.frame = viewOtherValue.frame;
    [viewBack setBackgroundColor:[UIColor darkTextColor]];
    viewBack.alpha = 0.8;
    [viewOtherValue addSubview:viewBack];
    [viewOtherValue sendSubviewToBack:viewBack];
    
    UIView *subResultView=[[UIView alloc]initWithFrame:CGRectMake(5, 0, 310, self.view.frame.size.height-100)];
    subResultView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [subResultView setBackgroundColor:[UIColor whiteColor]];
    subResultView.layer.cornerRadius=5.0;
    subResultView.layer.masksToBounds=YES;
    [viewOtherValue addSubview:subResultView];
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 50, 280, 29)];
    [lblTitle setText:@"Add"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor redColor]];
    [lblTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0]];
    
    [subResultView addSubview:lblTitle];
    
    txtOtherValue=[[UITextField alloc]initWithFrame:CGRectMake(15, 105, 280, 35)];
    [txtOtherValue setBorderStyle:UITextBorderStyleLine];
    txtOtherValue.delegate=self;
    txtOtherValue.tag=101;
    txtOtherValue.placeholder=@"Enter Value";
    txtOtherValue.inputAccessoryView = numberToolbar;
    
    [subResultView addSubview:txtOtherValue];
    
    UIButton *btnOtherValue=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnOtherValue setFrame:CGRectMake(15, 215, 280, 35)];
    [btnOtherValue setTitle:@"Save" forState:UIControlStateNormal];
    [btnOtherValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOtherValue setBackgroundImage:[UIImage imageNamed:@"btn_add_diagnosis.png"] forState:UIControlStateNormal];
    [btnOtherValue addTarget:self action:@selector(clickOnDoneForOtherFromList:) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnOtherValue];
    
    UIButton *btnclose=[[UIButton alloc]initWithFrame:CGRectMake(275,0, 35, 35)];
    [btnclose setTitle:@"X" forState:UIControlStateNormal];
    [btnclose.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [btnclose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclose setBackgroundColor:[UIColor redColor]];
    [btnclose addTarget:self action:@selector(clickOnRemoveView) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnclose];
    
    tblOtherList = [[UITableView alloc] initWithFrame:CGRectMake(0,265, 310, subResultView.frame.size.height-275) style:UITableViewStylePlain];
    tblOtherList.delegate=self;
    tblOtherList.dataSource=self;
    tblOtherList.tag=OtherListTableTag;
    tblOtherList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [subResultView addSubview:tblOtherList];
    
    
    [self.view addSubview:viewOtherValue];
    viewOtherValue.hidden=YES;
    
}

-(IBAction)clickOnOtherFromList
{
    txtOtherValue.text=@"";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OtherMedicalDiagnosis"])
    {
        arrOtherList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OtherMedicalDiagnosis"] mutableCopy];
    }
    else
    {
        arrOtherList = [[NSMutableArray alloc] init];
    }
    if (arrOtherList.count>0)
    {
        tblOtherList.hidden = NO;
        [tblOtherList reloadData];
    }
    else
    {
        tblOtherList.hidden = YES;
        
    }
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        viewOtherValue.hidden = NO;
                    } completion:NULL];
    
    
}

//Code To Close Add Other List View

-(void)clickOnRemoveView
{
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        viewOtherValue.hidden=YES;
                    } completion:NULL];
    
    
}

//Handle Done Action of Other List View
-(IBAction)clickOnDoneForOtherFromList:(id)sender
{
    if (txtOtherValue.text.length>0)
    {
        NSMutableArray *arrOther;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OtherMedicalDiagnosis"])
        {
            arrOther = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OtherMedicalDiagnosis"] mutableCopy];
            [arrOther addObject:txtOtherValue.text];
        }
        else
        {
            arrOther = [[NSMutableArray alloc] init];
            [arrOther addObject:txtOtherValue.text];
        }
        txtDiagnosis.text = txtOtherValue.text;
        [[NSUserDefaults standardUserDefaults]setObject:arrOther forKey:@"OtherMedicalDiagnosis"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self clickOnRemoveView];
        txtOtherValue.text=@"";
 
  
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter value before submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alt show];
    }
    
}

#pragma mark -
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertEditTag)
    {
        if (buttonIndex==1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if(alertView.tag==105)   //for Add Provider
    {
        [self clickOnAddContact:nil];
    }
}

#pragma mark -
#pragma mark - UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOtherList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Row in Tableview
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
   return 30;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tblOtherList.frame.size.width, 30)];
    headerView.backgroundColor=[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0];
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, tblOtherList.frame.size.width-20, 21)];
    lblTitle.textColor=[UIColor whiteColor];
    [lblTitle setText:@"User's Custom List"];
    [headerView addSubview:lblTitle];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier] ;
    }
    if (arrOtherList.count>0)
    {
        cell.textLabel.text = [arrOtherList objectAtIndex:indexPath.row];
    }
    
    return cell;
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
    
    if (tableView.tag == OtherListTableTag)
    {
        return  YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==OtherListTableTag)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            [arrOtherList removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults]setObject:arrOtherList forKey:@"OtherMedicalDiagnosis"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (arrOtherList.count>0)
            {
                tblOtherList.hidden=NO;
                
                
                [tblOtherList reloadData];
            }
            else
            {
                tblOtherList.hidden=YES;
            }
        }
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    isEdit = YES;
    
    txtTemp=textField;
    if (textField.tag==16 || textField.tag==17 || textField.tag==18 || textField.tag==19 )
    {
        if (self.view.frame.size.height<=568)
        {
            IsUp=YES;
            [UIView animateWithDuration:0.40f animations:
             ^{
                 [self MoveViewUp];
             }
                             completion:^(BOOL finished)
             {}];
        }
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.tag==16 || textField.tag==17 || textField.tag==18 ||  textField.tag==19 || IsUp)
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
#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isEdit = YES;
    tvTemp=textView;
    if (self.view.frame.size.height<=568)
    {
        IsUp=YES;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewUp];
         }
                         completion:^(BOOL finished)
         {}];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    objDiagnosis.strNotes=textView.text;
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
    [textView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

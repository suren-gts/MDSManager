//
//  AddTransfusionsVC.m
//  MyMDSManager
//
//  Created by CEPL on 14/01/16.
//  Copyright (c) 2016 sb. All rights reserved.
//

#import "AddTransfusionsVC.h"

@interface AddTransfusionsVC ()

@end


#define AlertConfirmTag     121
@implementation AddTransfusionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MMM-dd-YYYY"];
    [btnDate setTitle:[dateFormater stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    
    if (self.editFlag==0)
    {
        lblPageTitle.text=@"ADD TRANSFUSION";
        self.dictLocalValue = [[NSMutableDictionary alloc] init];
    }
    else
    {
        lblPageTitle.text=@"UPDATE TRANSFUSION";
        if ([self.dictLocalValue valueForKey:@"date"])
        {
            [btnDate setTitle:[self.dictLocalValue valueForKey:@"date"] forState:UIControlStateNormal];
        }
        if ([self.dictLocalValue valueForKey:@"type"])
        {
            txtTransfusiontype.text=[self.dictLocalValue valueForKey:@"type"];
        }
        if ([self.dictLocalValue valueForKey:@"unit"])
        {
            txtUnit.text=[self.dictLocalValue valueForKey:@"unit"];
        }
        if ([self.dictLocalValue valueForKey:@"bloodtype"])
        {
            [btnBloodtype setTitle:[self.dictLocalValue valueForKey:@"bloodtype"] forState:UIControlStateNormal];
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
    txtUnit.inputAccessoryView=numberToolbar;
    
    //txtUnit.keyboardType = UIKeyboardTypeDecimalPad;
    
    // Do any additional setup after loading the view from its nib.
}



-(void)viewWillAppear:(BOOL)animated
{
    if (self.editFlag==0)
    {
        NSString *strBloodType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserBloodType"];
        if ([strBloodType length] >0)
        {
            [self.dictLocalValue setValue:strBloodType forKey:@"bloodtype"];
            [btnBloodtype setTitle:[self.dictLocalValue valueForKey:@"bloodtype"] forState:UIControlStateNormal];
        }
    }

}



#pragma mark General Funtions

-(void)doneWithNumberPad
{
    [txtTemp resignFirstResponder];
    [txtUnit resignFirstResponder];
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



#pragma mark - Alertview Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertConfirmTag)
    {
        if (buttonIndex ==0)
        {
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - IBAction

-(IBAction)clickOnSave:(id)sender
{
    [txtTemp resignFirstResponder];
    
    if (btnBloodtype.titleLabel.text>0)
    {
        [self.dictLocalValue setValue:txtTransfusiontype.text forKey:@"type"];
        [self.dictLocalValue setValue:txtUnit.text forKey:@"unit"];
        
        if (!DateInDouble)
        {
            NSDate *todayDate = [NSDate date]; // get today date
            [self didSelectDate:todayDate];
        }
        
        NSLog(@" dict %@ = ",self.dictLocalValue);
        
        if (self.editFlag==0)
        {
            [App_Delegate.dbObj insertTransfusion:self.dictLocalValue];
        }
        else
        {
            [App_Delegate.dbObj updatetTransfusion:self.dictLocalValue];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsLatestUpdate"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
        [App_Delegate CheckBeforeUploadMainDB];

        
        [self.navigationController popViewControllerAnimated:YES];
        
        SomeEdit =0;
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
    }
    
}

-(IBAction)clickOnBack:(id)sender
{
    if (SomeEdit ==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You haven’t saved data yet. Do you really want to cancel the process?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        altView.tag = AlertConfirmTag;
        [altView show];
    }
}

-(IBAction)clickOnValuePicker:(UIButton *)sender
{
    [txtTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
    objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
    objPicker.valueDelegate=self;
    objPicker.rowId=2;
    objPicker.EntryTag=16;
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

-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger)section andForRow:(NSInteger)row
{
    
    if (row==0)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:strValue forKey:@"UserBloodType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.dictLocalValue setValue:strValue forKey:@"bloodtype"];
        
        [btnBloodtype setTitle:[self.dictLocalValue valueForKey:@"bloodtype"] forState:UIControlStateNormal];
        
        return;
    }
    
    SomeEdit =1;
    txtTransfusiontype.text=strValue;
    
}

-(IBAction)clickOnOpenDatePicker:(id)sender
{
    btnDate.enabled=NO;
    [txtTemp resignFirstResponder];
   
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
    SomeEdit = 1;
    
    btnDate.enabled=YES;
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"MMM dd, YYYY"];
    NSString *strDate =[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]];
    [btnDate setTitle:strDate forState:UIControlStateNormal];
    
    [self.dictLocalValue setValue:[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]] forKey:@"date"];
    
    DateInDouble=[selectedDate timeIntervalSince1970];
    [self.dictLocalValue setValue:[NSNumber numberWithDouble:DateInDouble] forKey:@"date_to_order"];
    
    
}

-(void)didCancelPicker
{
    btnDate.enabled=YES;
    btnTransfusion.enabled=YES;
}



#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    SomeEdit =1;
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


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (textField == txtUnit)
    {
        return stringIsValid;
    }
    else
    {
        return YES;
    }
    */
        
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



-(IBAction)clickOnValuePickerBloodGrp:(id)sender
{
    [txtTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
    objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
    objPicker.valueDelegate=self;
    objPicker.rowId=0;
    objPicker.EntryTag=9;
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


@end

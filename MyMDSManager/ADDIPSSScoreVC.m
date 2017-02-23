
//  ADDIPSSScoreVC.m
//  MyMDSManager

//  Created by CEPL on 13/10/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "ADDIPSSScoreVC.h"

@interface ADDIPSSScoreVC ()

@end

#define AlertConfirmTag 454

@implementation ADDIPSSScoreVC
@synthesize dictLocal;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MMM dd, YYYY"];
    txtDate.text=[dateFormater stringFromDate:[NSDate date]];
    
    if (!self.dictLocal)
    {
        self.dictLocal=[[NSMutableDictionary alloc]init];
        
    }
    else
    {
        txtScore.text=[self.dictLocal valueForKey:@"IPSSRSocre"];
        txtDate.text=[self.dictLocal valueForKey:@"IPSSRDate"];
        tvNotes.text=[self.dictLocal valueForKey:@"IPSSRNotes"];
    }
   
    //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    tvNotes.inputAccessoryView = numberToolbar;
    txtScore.inputAccessoryView = numberToolbar;
    
    //txtScore.keyboardType = UIKeyboardTypeDecimalPad;
    
}

#pragma mark Function Methods

-(IBAction)clickOnSaveButton:(id)sender
{
    if (txtDate.text.length>0 && txtScore.text.length>0)
    {
        [self.dictLocal setValue:txtScore.text forKey:@"IPSSRSocre"];
        [self.dictLocal setValue:txtDate.text forKey:@"IPSSRDate"];
        [self.dictLocal setValue:tvNotes.text forKey:@"IPSSRNotes"];
        
        if (self.editTag==0)
        {
            [App_Delegate.dbObj insertIPSSRScore:self.dictLocal];
        }
        else
        {
            [App_Delegate.dbObj updateIPSSRScore:self.dictLocal];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsLatestUpdate"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
        [App_Delegate CheckBeforeUploadMainDB];

        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
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

-(void)doneWithNumberPad
{
    [txtScore resignFirstResponder];
    [tvNotes resignFirstResponder];
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

-(IBAction)clickOnOpenDatePicker:(id)sender
{
    btnDate.enabled=NO;
    objDatePicker=[[DatePickerVC alloc] initWithNibName:@"DatePickerVC" bundle:nil];
    objDatePicker.datePickerDel=self;
    objDatePicker.entryTag=101;
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
    
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MMM dd, YYYY"];
    txtDate.text=[dateFormater stringFromDate:selectedDate];
    
}

-(void)didCancelPicker
{
    btnDate.enabled=YES;
}

#pragma mark UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    SomeEdit = 1;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (textField == txtScore)
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

#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    SomeEdit =1;
    
    if (self.view.frame.size.height<568)
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
    if (IsUp)
    {
        if (self.view.frame.size.height<568)
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
    [textView resignFirstResponder];
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
@end

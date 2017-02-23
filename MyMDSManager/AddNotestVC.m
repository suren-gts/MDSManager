//
//  AddNotestVC.m
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "AddNotestVC.h"

@interface AddNotestVC ()

@end

#define  AlertConfirmTag  564

@implementation AddNotestVC
@synthesize dictLocal;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MMM dd, YYYY  hh:mm a"];
    txtDate.text=[dateFormater stringFromDate:[NSDate date]];
    
    if (!self.dictLocal)
    {
        self.dictLocal=[[NSMutableDictionary alloc]init];
    }
    else
    {
        txtTopic.text=[dictLocal valueForKey:@"topic"];
        txtDate.text=[dictLocal valueForKey:@"date"];
        tvNotes.text=[dictLocal valueForKey:@"note"];
    }
    
   
    //Add done button on keyboard
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];

    txtTopic.delegate=self;
    tvNotes.delegate=self;
    tvNotes.inputAccessoryView = numberToolbar;
    txtTopic.inputAccessoryView = numberToolbar;

    
    // Do any additional setup after loading the view.
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

#pragma mark Function Methods

-(IBAction)clickOnSaveButton:(id)sender
{
    if (tvNotes.text.length > 0)
    {
        [dictLocal setValue:txtTopic.text forKey:@"topic"];
        [dictLocal setValue:txtDate.text forKey:@"date"];
        [dictLocal setValue:tvNotes.text forKey:@"note"];
        
        if (self.editTag==0)
        {
            [App_Delegate.dbObj insertNotes:dictLocal];
        }
        else
        {
            [App_Delegate.dbObj updatetNotes:dictLocal];
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
    [txtTopic resignFirstResponder];
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
    SomeEdit =1;
    btnDate.enabled=YES;
    
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MMM dd, YYYY  hh:mm a"];
    txtDate.text=[dateFormater stringFromDate:selectedDate];

}

-(void)didCancelPicker
{
    btnDate.enabled=YES;
}

#pragma mark UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    SomeEdit =1;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end

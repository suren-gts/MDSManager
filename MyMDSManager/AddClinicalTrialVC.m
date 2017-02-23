//
//  AddClinicalTrialVC.m
//  MyMDSManager
//
//  Created by Chanchal on 25/03/16.
//  Copyright © 2016 sb. All rights reserved.
//

#import "AddClinicalTrialVC.h"

@interface AddClinicalTrialVC ()

@end



#define txtLocationTag          121
#define txtNameOfTrialTag       131
#define txtTrialNoTag           141

#define AlertConfirmTag         551


@implementation AddClinicalTrialVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    txtLocation.tag     = txtLocationTag;
    txtNameOfTrial.tag  = txtNameOfTrialTag;
    txtTrialNo.tag      = txtTrialNoTag;
    
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    
    txtLocation.inputAccessoryView = numberToolbar;
    txtNameOfTrial.inputAccessoryView = numberToolbar;
    txtTrialNo.inputAccessoryView = numberToolbar;

    
    if (self.isShow)
    {
        objMedicine = self.objMedTemp;
        btnSave.hidden = YES;
        txtLocation.text = objMedicine.strLocation;
        txtNameOfTrial.text = objMedicine.strNameOfTrial;
        txtTrialNo.text = objMedicine.strTrialNumber;
    }
    else
    {
        objMedicine = [[MedicalObject alloc] initDefaults];
        btnSave.hidden = NO;
    }
}

-(void)doneWithNumberPad
{
    [self.view endEditing:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Text Field Delegate


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    isEdit = YES;
    
    if (textField.tag == txtLocationTag)
    {
        objMedicine.strLocation = textField.text;
    }
    else if (textField.tag == txtNameOfTrialTag)
    {
        objMedicine.strNameOfTrial = textField.text;
    }
    else if (textField.tag == txtTrialNoTag)
    {
        objMedicine.strTrialNumber = textField.text;
    }
}

#pragma mark - 
#pragma mark - Alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertConfirmTag)
    {
        if (buttonIndex ==0) //Cancel
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark -
#pragma mark - IBAction Method

- (IBAction)clickBack:(UIButton *)sender
{
    if (isEdit)
    {
        UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You haven’t saved data yet. Do you really want to cancel the process?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        altView.tag = AlertConfirmTag;
        [altView show];
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)clickOnSave:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    objMedicine.strTrialNumber = [objMedicine.strTrialNumber stringByTrimmingCharactersInSet:whitespace];
    objMedicine.strNameOfTrial = [objMedicine.strNameOfTrial stringByTrimmingCharactersInSet:whitespace];
    objMedicine.strLocation = [objMedicine.strLocation stringByTrimmingCharactersInSet:whitespace];
    
    if ( objMedicine.strNameOfTrial.length>0 )
    {
        if (!App_Delegate.arrMDSTreatement)
        {
            App_Delegate.arrMDSTreatement=[[NSMutableArray alloc] init];
        }
        
        [App_Delegate.arrMDSTreatement addObject:objMedicine];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
    }
}

@end

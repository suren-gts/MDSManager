//
//  EnquiryVC.m
//  MyMDSManager
//
//  Created by CEPL on 03/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "EnquiryVC.h"
#import "UnirestAsyncApi.h"

//#define Submit_Form @"https://tagsinfosoft.com/demo/mds_project/api/Centerofexcellence/contact_us"

#define Submit_Form @"http://mds.devsiteurl.com/mds_tracker/api/Centerofexcellence/contact_us"
@interface EnquiryVC ()

@end

@implementation EnquiryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,498);
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    
    tvComment.inputAccessoryView = numberToolbar;
    
    tfPhone.inputAccessoryView = numberToolbar;
    
    tvComment.text = @"Comment";
    tvComment.textColor = [UIColor lightGrayColor];
    tvComment.delegate = self;

}
-(void)doneWithNumberPad
{
    [tvComment resignFirstResponder];
    [tfPhone resignFirstResponder];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 498)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Textview Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,700);
    NSLog(@"%f",scrollView.contentOffset.y);
    
    if ([tvComment.text isEqualToString:@"Comment"])
    {
        tvComment.text = @"";
        tvComment.textColor = [UIColor blackColor];
        [scrollView setContentOffset:CGPointMake(0,145) animated:YES];
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (tvComment.text.length == 0)
    {
        tvComment.text = @"Comment *";
        tvComment.textColor = [UIColor grayColor];
    }
}


-(void) textViewDidChange:(UITextView *)textView
{
    if(tvComment.text.length == 0)
    {
        tvComment.textColor = [UIColor lightGrayColor];
        tvComment.text = @"Comment";
        [tvComment resignFirstResponder];
    }
}

#pragma mark -Textfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,700);
    NSLog(@"%f",scrollView.contentOffset.y);
    
    if (textField ==  tfName)
    {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (textField ==  tfPhone)
    {
        [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
    }
    else if (textField ==  tfEmail)
    {
        [scrollView setContentOffset:CGPointMake(0, 105) animated:YES];
    }
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return  YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,498);
    return  YES;
}

#pragma mark - IBAction Method
- (IBAction)didSelectBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didSelectSubmitForm:(UIButton *)sender
{
    if ([self validateData])
    {
        [self submitForm];
    }
    
}

- (IBAction)didSelectIAm:(UIButton *)sender
{
    if (sender == btnFamily)
    {
        if (sender.selected)
        {
            [sender setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
            sender.selected = NO;
        }
        else
        {
            [sender setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
            sender.selected = YES;
        }
    }
    else if (sender == btnFriend)
    {
        if (sender.selected)
        {
            [sender setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
            sender.selected = NO;
        }
        else
        {
            [sender setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
            sender.selected = YES;
        }
    }
    else if (sender == btnPatient)
    {
        if (sender.selected)
        {
            [sender setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
            sender.selected = NO;
        }
        else
        {
            [sender setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
            sender.selected = YES;
        }
    }
    else if (sender == btnCaregiver)
    {
        if (sender.selected)
        {
            [sender setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
            sender.selected = NO;
        }
        else
        {
            [sender setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
            sender.selected = YES;
        }
    }
}

#pragma mark - Validation
-(BOOL)validateData
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if ([tfName.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfName.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message
                                                             :@"Please enter name." delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([tfEmail.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfEmail.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message
                                                             :@"Please enter email." delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if(![self validateEmail:tfEmail.text])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message
                                                             :@"Please enter valid email." delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([tvComment.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tvComment.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] || [tvComment.text isEqualToString:@"Comment *"])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message
                                                             :@"Please add comment." delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

#pragma mark - API

-(void)submitForm
{
    btnSubmit.userInteractionEnabled = NO;
    
    NSString *name = tfName.text;
    NSString *email = tfEmail.text;
    
    email = [App_Delegate MD5String:email];

    
    NSString *comment = tvComment.text;
    NSString *phone;
    NSString *iAm;
    
    
    if (tfPhone.text.length == 0) { phone = @"";}
    else { phone = tfPhone.text;}
    
    
    if (btnFriend.selected) {iAm = [NSString stringWithFormat:@"Friend,"]; }
    if (btnFamily.selected) {iAm = [NSString stringWithFormat:@"Family,%@",iAm];}
    if (btnPatient.selected) {iAm = [NSString stringWithFormat:@"Patient,%@",iAm];}
    if (btnCaregiver.selected){iAm = [NSString stringWithFormat:@"Caregiver%@",iAm];}
    
    if (iAm.length == 0)
    {
        iAm = @"";
    }
    
    
    NSDictionary *Dic = @{@"name":name,
                                @"phone":phone,
                                @"email":email,
                                @"comment":comment,
                                @"i_am":iAm      };
    
    
    [UnirestAsyncApi callPostAsyncAPI:@"links.php" withParameter:Dic selector:@selector(callBackForEnquiryForm:) toTarget:self showHUD:YES];
}

-(void)callBackForEnquiryForm:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        btnSubmit.userInteractionEnabled = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successfully" message:@"Form successfully submitted." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Data couldn't be loaded! Please Try Again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altView show];
    }

}

#pragma mark - Alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

//
//  AddMediaProfessionalVC.m
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "AddMediaProfessionalVC.h"



@interface AddMediaProfessionalVC ()

@end

#define AlertConfirmTag  142

@implementation AddMediaProfessionalVC

RMPhoneFormat *_phoneFormat;
NSMutableCharacterSet *_phoneChars;
UITextField *_textField;

@synthesize dictLocal;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    txtProviderName.delegate=self;
    txtProviderSpeciality.delegate=self;
    txtReferredBy.delegate=self;
    txtPhone.delegate=self;
    txtFax.delegate=self;
    txtEmail.delegate=self;
    txtAddress.delegate=self;
    
    if (self.editTag==0)
    {
        lblPageTitle.text=@"Add Professionals";
        [btnSave setTitle:@"Save" forState:UIControlStateNormal];
        [btnCountryCode setTitle:@"+1" forState:UIControlStateNormal];
    }
    else
    {
        lblPageTitle.text=@"Update Professionals";
        [btnSave setTitle:@"Update" forState:UIControlStateNormal];

    }
    
    if (!self.dictLocal)
    {
        dictLocal=[[NSMutableDictionary alloc]init];
    }
    else
    {
        if ([dictLocal valueForKey:@"name"])
        {
            txtProviderName.text=[dictLocal valueForKey:@"name"];
        }
        if ([dictLocal valueForKey:@"speciality"])
        {
            txtProviderSpeciality.text=[dictLocal valueForKey:@"speciality"];
        }
        if ([dictLocal valueForKey:@"reference"])
        {
            txtReferredBy.text=[dictLocal valueForKey:@"reference"];
        }
        if ([dictLocal valueForKey:@"address"])
        {
            txtAddress.text=[dictLocal valueForKey:@"address"];
        }
        if ([dictLocal valueForKey:@"phone"])
        {
            txtPhone.text=[dictLocal valueForKey:@"phone"];
        }
        if ([dictLocal valueForKey:@"mail"])
        {
            txtEmail.text=[dictLocal valueForKey:@"mail"];
        }
        if ([dictLocal valueForKey:@"fax"])
        {
            txtFax.text=[dictLocal valueForKey:@"fax"];
        }
        [btnCountryCode setTitle:[dictLocal valueForKey:@"countrycode"] forState:UIControlStateNormal];
    }
    //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    txtProviderName.inputAccessoryView = numberToolbar;
    txtProviderSpeciality.inputAccessoryView = numberToolbar;
    txtReferredBy.inputAccessoryView = numberToolbar;
    txtPhone.inputAccessoryView = numberToolbar;
    txtFax.inputAccessoryView = numberToolbar;
    txtEmail.inputAccessoryView = numberToolbar;
    
    
    txtAddress.inputAccessoryView = numberToolbar;
    
    _phoneChars = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    [_phoneChars addCharactersInString:@"+*#,"];
    [self setupFormatter];
    
    // Listen for changes locale (if the user changes the Region Format settings)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeChanged) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)setupFormatter
{
    _phoneFormat = [[RMPhoneFormat alloc] init];
}
- (void)localeChanged {
    [self setupFormatter];
    
    // Reformat the current phone number
    if (_textField) {
        NSString *text = _textField.text;
        NSString *phone = [_phoneFormat format:text];
        _textField.text = phone;
    }
}

#pragma mark - Alertview Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertConfirmTag)
    {
        if (buttonIndex ==0)
        {
              App_Delegate.strProviderForDiagnosis = @"0";
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Function Methods

-(void)doneWithNumberPad
{
    [txtAddress resignFirstResponder];
    [txtTemp resignFirstResponder];
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
    SomeEdit =0;
    [txtAddress resignFirstResponder];
    
    if (txtProviderName.text.length>0)
    {
        [dictLocal setValue:txtProviderName.text forKey:@"name"];
        [dictLocal setValue:txtProviderSpeciality.text forKey:@"speciality"];
        [dictLocal setValue:txtPhone.text forKey:@"phone"];
        [dictLocal setValue:txtAddress.text forKey:@"address"];
        [dictLocal setValue:txtEmail.text forKey:@"mail"];
        [dictLocal setValue:txtReferredBy.text forKey:@"reference"];
        [dictLocal setValue:txtFax.text forKey:@"fax"];
        
        [dictLocal setValue:btnCountryCode.titleLabel.text forKey:@"countrycode"];
        
        if (self.editTag==0)
        {
            [App_Delegate.dbObj insertMedicalProvider:dictLocal];
        }
        else
        {
            [App_Delegate.dbObj updateMedicalProvider:dictLocal];
        }
        if ([App_Delegate.strProviderForDiagnosis isEqualToString:@"1"])
        {
            App_Delegate.strProviderForDiagnosis = txtProviderName.text;
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
         App_Delegate.strProviderForDiagnosis = @"0";
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You haven’t saved data yet. Do you really want to cancel the process?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        altView.tag = AlertConfirmTag;
        [altView show];
    }
}

-(IBAction)addToDeviceContact:(id)sender
{
    if (txtProviderName.text.length>0)
    {
        CFErrorRef error = NULL;
        
        ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(iPhoneAddressBook, ^(bool granted, CFErrorRef error)
            {
                if (granted)
                {
                    [self exprortContactToDevice];
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            [self exprortContactToDevice];
        }
        
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
        
    }
}

-(void)exprortContactToDevice
{
    CFErrorRef error = NULL;
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef newPerson = ABPersonCreate();
    
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(txtProviderName.text), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(@""), &error);
    
    NSString *strPhone=txtPhone.text;
    
    ABMutableMultiValueRef multiPhone =     ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(strPhone), kABPersonPhoneMainLabel, NULL);
    
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
    CFRelease(multiPhone);
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    
    ABAddressBookSave(iPhoneAddressBook, &error);
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    if (error != NULL)
    {
        CFStringRef errorDesc = CFErrorCopyDescription(error);
        NSLog(@"Contact not saved: %@", errorDesc);
        CFRelease(errorDesc);
    }
    else
    {
        UIAlertView *AV=[[UIAlertView alloc]initWithTitle:nil message:@"Successfully exported" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [AV show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark Action Sheet Methods

-(IBAction)clickOnSelectCountryCode:(id)sender
{
    [txtTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
    if (!isActionSheetVisible)
    {
        isActionSheetVisible=YES;
        
        [txtTemp resignFirstResponder];
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
        objPicker.EntryTag=14;
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
    isActionSheetVisible=NO;
   
    NSMutableDictionary *dictValue = [App_Delegate.arrCountryPhoneCode objectAtIndex:intIndex];
    NSString *strCode = [NSString stringWithFormat:@"+%@",[dictValue valueForKey:@"CountryCode"]];
    [btnCountryCode setTitle:strCode forState:UIControlStateNormal];
    
}

-(void)didCancelPicker
{
    isActionSheetVisible=NO;
}


#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    SomeEdit = 1;
    
    txtTemp=textField;
    if (textField == txtFax || textField == txtEmail  || textField == txtPhone )
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
    if ([textField isKindOfClass:[txtEmail class]] || [textField isKindOfClass:[txtPhone class]] || [textField isKindOfClass:[txtFax class]] || IsUp )
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
    if (self.view.frame.size.height<=560)
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtPhone || textField==txtFax)
    {
        UITextRange *selRange = textField.selectedTextRange;
        UITextPosition *selStartPos = selRange.start;
        UITextPosition *selEndPos = selRange.end;
        NSInteger start = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selStartPos];
        NSInteger end = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selEndPos];
        NSRange repRange;
        if (start == end)
        {
            if (string.length == 0)
            {
                repRange = NSMakeRange(start - 1, 1);
            } else {
                repRange = NSMakeRange(start, end - start);
            }
        } else
        {
            repRange = NSMakeRange(start, end - start);
        }
        
        // This is what the new text will be after adding/deleting 'string'
        NSString *txt = [textField.text stringByReplacingCharactersInRange:repRange withString:string];
        // This is the newly formatted version of the phone number
        NSString *phone = [_phoneFormat format:txt];
        BOOL valid = [_phoneFormat isPhoneNumberValid:phone];
        
        textField.textColor = valid ? [UIColor blackColor] : [UIColor redColor];
        
        // If these are the same then just let the normal text changing take place
        if ([phone isEqualToString:txt])
        {
            return YES;
        }
        else
        {
            // The two are different which means the adding/removal of a character had a bigger effect
            // from adding/removing phone number formatting based on the new number of characters in the text field
            // The trick now is to ensure the cursor stays after the same character despite the change in formatting.
            // So first let's count the number of non-formatting characters up to the cursor in the unchanged text.
            int cnt = 0;
            for (NSUInteger i = 0; i < repRange.location + string.length; i++)
            {
                if ([_phoneChars characterIsMember:[txt characterAtIndex:i]])
                {
                    cnt++;
                }
            }
            
            // Now let's find the position, in the newly formatted string, of the same number of non-formatting characters.
            NSUInteger pos = [phone length];
            int cnt2 = 0;
            for (NSUInteger i = 0; i < [phone length]; i++)
            {
                if ([_phoneChars characterIsMember:[phone characterAtIndex:i]])
                {
                    cnt2++;
                }
                
                if (cnt2 == cnt)
                {
                    pos = i + 1;
                    break;
                }
            }
            
            // Replace the text with the updated formatting
            textField.text = phone;
            
            // Make sure the caret is in the right place
            UITextPosition *startPos = [textField positionFromPosition:textField.beginningOfDocument offset:pos];
            UITextRange *textRange = [textField textRangeFromPosition:startPos toPosition:startPos];
            textField.selectedTextRange = textRange;
            
            return NO;
        }

    }
    return YES;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.view.frame.size.height<=560 ||  IsUp==YES)
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

@end

//
//  InsuranceDetailVC.m
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "InsuranceDetailVC.h"
#import "ProfileHeaderCell.h"
#import "ProfileContentDisplayCell.h"
#import "InsuranceCompanyObject.h"
#import "TakePicCell.h"
@interface InsuranceDetailVC ()

@end

#define AlertConfirmTag     515

@implementation InsuranceDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dictColleps=[[NSMutableDictionary alloc]init];
    dictEditAction=[[NSMutableDictionary alloc]init];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    arrInsurance=[App_Delegate.dbObj getInsuranceDetail];
    //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    // Do any additional setup after loading the view.
}
-(void)doneWithNumberPad
{
    [txtTemp resignFirstResponder];
    if (IsUp)
    {
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewDown];
         }
                         completion:^(BOOL finished)
         {}];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",section];
    //count of row in section
    if (section==0)
    {
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        return 11;
    }
    else if (section==1)
    {
        
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        return 11;
    }
   return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Row in Tableview
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",indexPath.section];
    if ([dictColleps valueForKey:strSection])
    {
        return 0;
    }
    if (indexPath.row==IImage)
    {
        return 100;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //View for Section Header of TableView
    
    static NSString *CellIdentifier = @"ProfileHeaderCell";
    
    ProfileHeaderCell *cell = (ProfileHeaderCell *) [tableView
                                                     dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileHeaderCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    cell.btnActions.hidden=NO;
    cell.btnActions.userInteractionEnabled=YES;
    cell.btnColleps.hidden=NO;
    cell.btnColleps.userInteractionEnabled=YES;
    
    if (section==0)
    {
        cell.lblHeaderTitle.text=@"Primary Insurance Company";
    }
    else if (section==1)
    {
        cell.lblHeaderTitle.text=@"Secondary Insurance Company";
    }
   
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",section];
    
    if ([dictColleps valueForKey:strSection])
    {
        [cell.btnColleps setImage:[UIImage imageNamed:@"icn_arrow_down_aboutlabel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnColleps setImage:[UIImage imageNamed:@"icn_arrowup_aboutlabel.png"] forState:UIControlStateNormal];
    }
    
    cell.btnColleps.tag=section;
    [cell.btnColleps addTarget:self action:@selector(clickOnCollepsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([dictEditAction valueForKey:strSection])
    {
        [cell.btnActions setImage:[UIImage imageNamed:@"icn_save.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnActions setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
    }
    cell.btnActions.tag=section;
    [cell.btnActions addTarget:self action:@selector(clickOnHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor=[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0];
    return cell;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",indexPath.section];
    InsuranceCompanyObject *objInsurance=[arrInsurance objectAtIndex:indexPath.section];
    
    
    if (indexPath.row==IImage)
    {
        static NSString *CellIdentifier = @"TakePicCell";
        TakePicCell *cell = (TakePicCell *) [tableView
                                                                         dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TakePicCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        if ([dictEditAction valueForKey:strSection])
        {
            [cell.btnAction addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnAction.tag=indexPath.section;
            cell.lbltCaption.hidden=NO;
        }
        else
        {
            cell.btnAction.userInteractionEnabled=NO;
            cell.lbltCaption.hidden=YES;
        }
                
        if (objInsurance.imgCompany)
        {
            [cell.imgView setImage:objInsurance.imgCompany];
        }
        else
        {
            [cell.imgView setImage:nil];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"ProfileContentDisplayCell";
        ProfileContentDisplayCell *cell = (ProfileContentDisplayCell *) [tableView
                                                                         dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileContentDisplayCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        
        
        if ([dictEditAction valueForKey:strSection])
        {
            cell.txtField.delegate=self;
            cell.txtField.hidden=NO;
            cell.txtField.userInteractionEnabled=YES;
            cell.txtField.tag=indexPath.row;
            cell.txtField.superview.tag=indexPath.section;
            cell.txtField.inputAccessoryView = numberToolbar;
            
        }
        else
        {
            cell.txtField.hidden=YES;
            cell.txtField.userInteractionEnabled=NO;
        }
        
        if (indexPath.row==IOption)
        {
            cell.lblTitle.text=@"Option";
            cell.lblValue.text=objInsurance.strOptions;
            cell.txtField.text=objInsurance.strOptions;
        }
        else if (indexPath.row==IName)
        {
            cell.lblTitle.text=@"Company Name";
            cell.lblValue.text=objInsurance.strCopanyName;
            cell.txtField.text=objInsurance.strCopanyName;
        }
        else if (indexPath.row==IPhoneNumber)
        {
            cell.lblTitle.text=@"Phone Number";
            cell.lblValue.text=objInsurance.strPhoneNumber;
            cell.txtField.text=objInsurance.strPhoneNumber;
            
            cell.txtField.inputAccessoryView = numberToolbar;
            cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
        }
        else  if (indexPath.row==IEmployer)
        {
            cell.lblTitle.text=@"Employer";
            cell.lblValue.text=objInsurance.strEmployer;
            cell.txtField.text=objInsurance.strEmployer;
        }
        
        else  if (indexPath.row==IGroup)
        {
            cell.lblTitle.text=@"Group #";
            cell.lblValue.text=objInsurance.strGroup;
            cell.txtField.text=objInsurance.strGroup;
        }
        
        else if (indexPath.row==IPrescription)
        {
            cell.lblTitle.text=@"Prescription #";
            cell.lblValue.text=objInsurance.strPrescription;
            cell.txtField.text=objInsurance.strPrescription;
        }
        
        else if (indexPath.row==IAddress)
        {
            cell.lblTitle.text=@"Address";
            cell.lblValue.text=objInsurance.strAddress;
            cell.txtField.text=objInsurance.strAddress;
        }
        else if (indexPath.row==ICity)
        {
            cell.lblTitle.text=@"City";
            cell.lblValue.text=objInsurance.strCity;
            cell.txtField.text=objInsurance.strCity;
        }
        else if (indexPath.row==IState)
        {
            cell.lblTitle.text=@"State";
            cell.lblValue.text=objInsurance.strState;
            cell.txtField.text=objInsurance.strState;
        }
        
        else if (indexPath.row==IZipcode)
        {
            cell.lblTitle.text=@"Zip Code";
            cell.lblValue.text=objInsurance.strZipCode;
            cell.txtField.text=objInsurance.strZipCode;
            
            cell.txtField.inputAccessoryView = numberToolbar;
            cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

#pragma mark - Alertview Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertConfirmTag)
    {
        if (buttonIndex ==0) //Cancel
        {
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Function Methods

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

-(void)clickOnHeaderAction:(id)sender
{

    
    UIButton *btnSender=(UIButton *)sender;
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",btnSender.tag];
    
    if ([dictEditAction valueForKey:strSection])
    {   SomeEdit --;
        
        InsuranceCompanyObject *objInsurance=[arrInsurance objectAtIndex:btnSender.tag];
        if (btnSender.tag==0)
        {
            if (objInsurance.imgCompany)
            {
                objInsurance.strImageName=@"PrimaryImage.png";
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
                
                NSString *filePath = [dataPath stringByAppendingPathComponent:objInsurance.strImageName];
                NSData *imageData = UIImagePNGRepresentation(objInsurance.imgCompany);
                [imageData writeToFile:filePath atomically:YES];
            }
            
            [dictEditAction setValue:nil forKey:strSection];
            [App_Delegate.dbObj updateInsuranceDetail:objInsurance];
        }
        else if (btnSender.tag==1)
        {
            if (objInsurance.imgCompany)
            {
                objInsurance.strImageName=@"SecondaryImage.png";
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
                
                NSString *filePath = [dataPath stringByAppendingPathComponent:objInsurance.strImageName];
                NSData *imageData = UIImagePNGRepresentation(objInsurance.imgCompany);
                [imageData writeToFile:filePath atomically:YES];
            }

            [dictEditAction setValue:nil forKey:strSection];
            [App_Delegate.dbObj updateInsuranceDetail:objInsurance];
        }
    }
    else
    {
          SomeEdit ++;
        [dictEditAction setValue:@"YES" forKey:strSection];
    }
    [UIView transitionWithView:tblView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [tblView reloadData];
                    } completion:NULL];

}

-(void)clickOnValuePicker:(NSInteger)rowTag withSection:(NSInteger)sectionTag
{
    [txtTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
   
    objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
    objPicker.valueDelegate=self;
    objPicker.rowId=rowTag;
    objPicker.sectionId=sectionTag;
    objPicker.EntryTag=4;
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

-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger )section andForRow:(NSInteger)row
{
    IsActionSheetVisible=NO;
    InsuranceCompanyObject *objInsurance=[arrInsurance objectAtIndex:section];
    objInsurance.strOptions=strValue;
    [arrInsurance replaceObjectAtIndex:section withObject:objInsurance];
    [tblView reloadData];
}
-(void)didCancelPicker
{
    IsActionSheetVisible=NO;
}
-(IBAction)addPhoto:(id)sender
{
    btnImageTag=(UIButton *)sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera", nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    
}

#pragma mark Image Picker delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!imagePicker)
    {
        imagePicker = [[UIImagePickerController alloc] init];    
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    switch (buttonIndex)
    {
        case 0: NSLog(@"Photo Butten Clicked");
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
            
        case 1: NSLog(@"Camera Butten Clicked");
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                UIAlertView *altnot=[[UIAlertView alloc]initWithTitle:@"Camera Not Available" message:@"Camera Not Available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [altnot show];
            }
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    InsuranceCompanyObject *object=[arrInsurance objectAtIndex:btnImageTag.tag];
    
    UIImage *selectedImage= info[UIImagePickerControllerEditedImage];
    object.imgCompany=selectedImage;
    [arrInsurance replaceObjectAtIndex:btnImageTag.tag withObject:object];
    [picker dismissViewControllerAnimated:NO completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [tblView reloadData];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==IOption)
    {
        if (IsActionSheetVisible==NO)
        {
            IsActionSheetVisible=YES;
            [self clickOnValuePicker:textField.tag withSection:textField.superview.tag];
        }

        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    InsuranceCompanyObject *object=[arrInsurance objectAtIndex:textField.superview.tag];
   
    if (textField.tag==IOption)
    {
        object.strOptions=textField.text;
    }
    else if (textField.tag==IName)
    {
        object.strCopanyName=textField.text;
    }
    else if (textField.tag==IPhoneNumber)
    {
        object.strPhoneNumber=textField.text;
    }
    else if (textField.tag==IEmployer)
    {
        object.strEmployer=textField.text;
    }
    else if (textField.tag==IGroup)
    {
        object.strGroup=textField.text;
    }
    else if (textField.tag==IPrescription)
    {
        object.strPrescription=textField.text;
    }
    else if (textField.tag==IAddress)
    {
        object.strAddress=textField.text;
    }
    else if (textField.tag==ICity)
    {
        object.strCity=textField.text;
    }
    else if (textField.tag==IState)
    {
        object.strState=textField.text;
    }
    else if (textField.tag==IZipcode)
    {
        object.strZipCode=textField.text;
    }
    [arrInsurance replaceObjectAtIndex:textField.superview.tag withObject:object];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtTemp=textField;
    if (textField.tag==3 || textField.tag==4 ||textField.tag==5 || textField.tag==6 || textField.tag==7 || textField.tag==8 || textField.tag==9 || textField.tag==10 )
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==3 || textField.tag==4 ||textField.tag==5 || textField.tag==6 || textField.tag==7 || textField.tag==8 || textField.tag==9 || textField.tag==10  || IsUp)
    {
        IsUp=NO;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewDown];
         }
                         completion:^(BOOL finished)
         {}];
    }
    [textField resignFirstResponder];
    return YES;
    
}

-(void)MoveViewUp
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,-250,self.view.frame.size.width,self.view.frame.size.height)];
}
-(void)MoveViewDown
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}

- (void) dealloc
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AddBloodCountVC.m
//  MyMDSManager
//
//  Created by CEPL on 20/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "AddBloodCountVC.h"
#import "ProfileContentDisplayCell.h"
#import "AddNotesCell.h"
#import "SymptomButtonCell.h"
#import "ButtonCell.h"
#import "AddFileNImagesCell.h"


@interface AddBloodCountVC ()

@end

#define AlertConfirmTag   121

@implementation AddBloodCountVC
@synthesize dictBloodCount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!dictBloodCount)
    {
        dictBloodCount=[[NSMutableDictionary alloc]init];
    }
    if (self.editFlag==0)
    {
        lblPageTitle.text=@"ADD RESULT";
    }
    else
    {
        lblPageTitle.text=@"UPDATE RESULT";
        arrLabResult =[App_Delegate.dbObj GetOtherLabResult:[[self.dictBloodCount valueForKey:@"rowid"] integerValue]];
    }
    
    NSString *strBoneImage=[self.dictBloodCount valueForKey:@"bloodcountsimages"];
    if (strBoneImage.length>0)
    {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
        arrImageName=[[strBoneImage componentsSeparatedByString:@","] mutableCopy];
        for (int i=0; i<arrImageName.count; i++)
        {
            NSString *filePath = [dataPath stringByAppendingPathComponent:[arrImageName objectAtIndex:i]];
            if (!arrFiles)
            {
                arrFiles=[[NSMutableArray alloc]init];
                arrFullSizeImage=[[NSMutableArray alloc]init];
            }
            
            UIImage *imglab=[UIImage imageWithContentsOfFile:filePath];
            [arrFiles addObject:[self createImageThumbView:imglab]];
            [arrFullSizeImage addObject:imglab];
            
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
    
    //txtTestValue.keyboardType = UIKeyboardTypeDecimalPad;
    
    txtTestValue.inputAccessoryView=numberToolbar;
    [tblView reloadData];
    
    NSString *strBloodType = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserBloodType"];
    
    
    if ([strBloodType length] >0)
    {
          [dictBloodCount setValue:strBloodType forKey:@"bloodtype"];
    }

    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TableSectionCount;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (section==BloodType)
    {
        return 3;
    }
    else if (section==BloodCounts)
    {
        return 6;
    }
    else if(section==LabTest)
    {
        if (arrLabResult.count>0)
        {
            return arrLabResult.count+1;
        }
        return 1;
    }
    else if (section==Notes)
    {
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Row in Tableview
    if (indexPath.section==BloodType)
    {
        if (indexPath.row == 0)
        {
            return 0;
        }
        else if (indexPath.row == 1)
        {
            return 130;
        }
        else
        {
            return 110;
        }
        
    }
    else if (indexPath.section==BloodCounts)
    {
        return 44;
    }
    else if (indexPath.section==LabTest)
    {
        if (arrLabResult.count>0)
        {
            if (indexPath.row==arrLabResult.count)
            {
                return 60;
            }
            return 44;
        }
         return 60;
    }
    else if (indexPath.section==Notes)
    {
        return 110;
    }
    else
    {
        return 60;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==BloodType)
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *cell=[[UITableViewCell alloc]init];
            return cell;
        }
        else if (indexPath.row==1)
        {
            static NSString *MyIdentifier = @"AddFileNImagesCell";
            
            AddFileNImagesCell *cell = (AddFileNImagesCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            
            if (cell == nil)
            {
                NSArray *arrNib=[[NSBundle mainBundle]loadNibNamed:@"AddFileNImagesCell" owner:self options:nil];
                cell=[arrNib objectAtIndex:0];
            }
            
            for (UIView *v in cell.scrollView.subviews)
            {
                [v removeFromSuperview];
            }
            CGFloat count=arrFiles.count+1;
            [cell.scrollView setContentSize:CGSizeMake(count*50, 50)];
            for (int j=0; j<count; j++)
            {
                UIView *view=[self creteScrollView:j];
                [cell.scrollView addSubview:view];
                [view setFrame:CGRectMake(j*50, 0, 50, 50)];
            }
            [cell.btnAddPhoto addTarget:self action:@selector(clickOnAddImage:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else
        {
            
            static NSString *CellIdentifier = @"AddNotesCell";
            
            AddNotesCell *cell = (AddNotesCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddNotesCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            cell.tvNotes.superview.tag = indexPath.section;
            cell.tvNotes.delegate=self;
            NSString *strNotes = [dictBloodCount valueForKey:@"bloodnotes"];
            if (strNotes.length>0)
            {
                cell.tvNotes.text=strNotes;
            }
            else
            {
                cell.tvNotes.text=@"";
            }
            cell.tvNotes.inputAccessoryView = numberToolbar;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    else if (indexPath.section==BloodCounts)
    {
        static NSString *CellIdentifier = @"ProfileContentDisplayCell";
        
        ProfileContentDisplayCell *cell = (ProfileContentDisplayCell *) [tableView
                                                                         dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileContentDisplayCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        cell.txtField.delegate=self;
        cell.txtField.hidden=NO;
        cell.txtField.userInteractionEnabled=YES;
        cell.txtField.tag=indexPath.row;
        cell.txtField.superview.tag=indexPath.section;
        cell.lblValue.hidden=YES;
        
        //cell.txtField.keyboardType=UIKeyboardTypeDecimalPad;
        
        cell.txtField.inputAccessoryView = numberToolbar;
        if (indexPath.row==0)
        {
            cell.lblTitle.text=@"Date *";
            if ([dictBloodCount valueForKey:@"date"])
            {
                cell.txtField.text=[dictBloodCount valueForKey:@"date"];
            }
            else
            {
                cell.txtField.text=@"";
            }
            
        }
        else if (indexPath.row==1)
        {
            cell.lblTitle.text=@"HGB (g/dl)";
            if ([dictBloodCount valueForKey:@"HGB"])
            {
                cell.txtField.text=[dictBloodCount valueForKey:@"HGB"];
            }
            else
            {
                cell.txtField.text=@"";
            }
            cell.txtField.inputAccessoryView = numberToolbar;
        }
        else  if (indexPath.row==2)
        {
            cell.lblTitle.text=@"WBC (k/ul)";
            if ([dictBloodCount valueForKey:@"WBC"])
            {
                cell.txtField.text=[dictBloodCount valueForKey:@"WBC"];
            }
            else
            {
                cell.txtField.text=@"";
            }
            cell.txtField.inputAccessoryView = numberToolbar;
        }
        else  if (indexPath.row==3)
        {
            cell.lblTitle.text=@"ANC (g/dl)";
            if ([dictBloodCount valueForKey:@"ANC"])
            {
                cell.txtField.text=[dictBloodCount valueForKey:@"ANC"];
            }
            else
            {
                cell.txtField.text=@"";
            }
            cell.txtField.inputAccessoryView = numberToolbar;
        }
        else  if (indexPath.row==4)
        {
            cell.lblTitle.text=@"Platelets (k/ul)";
            if ([dictBloodCount valueForKey:@"Platelets"])
            {
                cell.txtField.text=[dictBloodCount valueForKey:@"Platelets"];
            }
            else
            {
                cell.txtField.text=@"";
            }
            cell.txtField.inputAccessoryView = numberToolbar;
        }
        else  if (indexPath.row==5)
        {
            cell.lblTitle.text=@"Ferritin (ng/mL)";
            if ([dictBloodCount valueForKey:@"Ferritin"])
            {
                cell.txtField.text=[dictBloodCount valueForKey:@"Ferritin"];
            }
            else
            {
                cell.txtField.text=@"";
            }
            
            cell.txtField.inputAccessoryView = numberToolbar;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section==LabTest)
    {
        if (arrLabResult.count>0)
        {
            if (indexPath.row==arrLabResult.count)
            {
                static NSString *CellIdentifier = @"ButtonCell";
                
                ButtonCell *cell = (ButtonCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                [cell.btnAction setTitle:@"Add Lab" forState:UIControlStateNormal];
                [cell.btnAction addTarget:self action:@selector(clickOnAddLab:) forControlEvents:UIControlEventTouchUpInside];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                
                static NSString *CellIdentifier = @"ProfileContentDisplayCell";
                
                ProfileContentDisplayCell *cell = (ProfileContentDisplayCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileContentDisplayCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                cell.txtField.delegate=self;
                cell.txtField.hidden=NO;
                cell.txtField.userInteractionEnabled=YES;
                cell.txtField.tag=indexPath.row;
                cell.txtField.superview.tag=indexPath.section;
                cell.lblValue.hidden=YES;
                
                //cell.txtField.keyboardType=UIKeyboardTypeDecimalPad;
                
                cell.txtField.inputAccessoryView=numberToolbar;
                NSMutableDictionary *dicLocal = [arrLabResult objectAtIndex:indexPath.row];
                cell.lblTitle.text=[dicLocal valueForKey:@"labTitle"];
                if ([dicLocal valueForKey:@"labValue"])
                {
                    cell.txtField.text=[dicLocal valueForKey:@"labValue"];
                }
                else
                {
                    cell.txtField.text=@"";
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else
        {
            static NSString *CellIdentifier = @"ButtonCell";
            
            ButtonCell *cell = (ButtonCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            [cell.btnAction setTitle:@"Add Lab" forState:UIControlStateNormal];
            [cell.btnAction addTarget:self action:@selector(clickOnAddLab:) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    else if (indexPath.section==Notes)
    {
        static NSString *CellIdentifier = @"AddNotesCell";
        
        AddNotesCell *cell = (AddNotesCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddNotesCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.tvNotes.superview.tag = indexPath.section;
        cell.tvNotes.delegate=self;
        NSString *strNotes = [dictBloodCount valueForKey:@"notes"];
        if (strNotes.length>0)
        {
            cell.tvNotes.text=[dictBloodCount valueForKey:@"notes"];
        }
        else
        {
            cell.tvNotes.text=@"";
        }
        cell.tvNotes.inputAccessoryView = numberToolbar;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section==Button)
    {
        static NSString *CellIdentifier = @"SymptomButtonCell";
        
        SymptomButtonCell *cell = (SymptomButtonCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SymptomButtonCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.backgroundColor=[UIColor clearColor];
        [cell.btnChart setTitle:@"Save" forState:UIControlStateNormal];
        [cell.btnChart addTarget:self action:@selector(clickOnSave:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;


    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark General Funtions
-(IBAction)clickOnSaveLabResult:(id)sender
{
    [txtTemp resignFirstResponder];
    if (txtTest.text.length>0 && txtTestValue.text.length>0)
    {
        NSMutableDictionary *dictCare=[[NSMutableDictionary alloc]init];
        [dictCare setValue:txtTest.text forKey:@"labTitle"];
        [dictCare setValue:txtTestValue.text forKey:@"labValue"];
       
        if (!arrLabResult)
        {
            arrLabResult=[[NSMutableArray alloc] init];
        }
        [arrLabResult addObject:dictCare];
        
        [tblView reloadData];
        [self clickOnCanelLab:nil];
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the information before click on save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alt show];
        
    }
}

-(void)clickOnAddLab:(id)sender
{
    SomeEdit = 1;
    
    [txtTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }

    txtTest.text=@"";
    txtTestValue.text=@"";
    
    [self.view bringSubviewToFront:viewLabResult];
    [UIView transitionWithView:viewLabResult
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        
                        viewLabResult.hidden=NO;
                        
                        
                    } completion:NULL];
    
}

-(IBAction)clickOnCanelLab:(id)sender
{
    [UIView transitionWithView:viewLabResult
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        
                        viewLabResult.hidden=YES;
                        
                        
                    } completion:NULL];
    [self.view sendSubviewToBack:viewLabResult];
}

-(void)doneWithNumberPad
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
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

-(IBAction)clickOnSave:(id)sender
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    
    /*
    if (![self isCorrectDataTypeEntered])
    {
        return;
    }
    */
    
    
    if ([dictBloodCount valueForKey:@"date"])
    {
        if (![dictBloodCount valueForKey:@"HGB"])
        {
            [dictBloodCount setValue:@"" forKey:@"HGB"];
        }
        
        if (![dictBloodCount valueForKey:@"WBC"])
        {
            [dictBloodCount setValue:@"" forKey:@"WBC"];
        }
        
        if (![dictBloodCount valueForKey:@"ANC"])
        {
            [dictBloodCount setValue:@"" forKey:@"ANC"];
        }
        
        if (![dictBloodCount valueForKey:@"Platelets"])
        {
            [dictBloodCount setValue:@"" forKey:@"Platelets"];
        }
        if (![dictBloodCount valueForKey:@"Ferritin"])
        {
            [dictBloodCount setValue:@"" forKey:@"Ferritin"];
        }
        if (![dictBloodCount valueForKey:@"notes"])
        {
            [dictBloodCount setValue:@"" forKey:@"notes"];
        }
        
        [dictBloodCount setValue:@"" forKey:@"bloodcountsimages"];
        NSInteger lastRowid = -1;
        if (self.editFlag==0)
        {
            lastRowid = [App_Delegate.dbObj insertBloodCountResult:dictBloodCount];
            for (int i = 0; i<arrLabResult.count; i++)
            {
                NSMutableDictionary *dicValue=[arrLabResult objectAtIndex:i];
                [dicValue setValue:[NSString stringWithFormat:@"%ld",(long)lastRowid] forKey:@"browid"];
                [App_Delegate.dbObj insertOtherResult:dicValue];
            }
            [dictBloodCount setValue:[NSString stringWithFormat:@"%ld",(long)lastRowid] forKey:@"rowid"];
        }
        else
        {
            lastRowid = [[dictBloodCount valueForKey:@"rowid"] intValue];
            [App_Delegate.dbObj updateBloodCountResult:dictBloodCount];
        }
        if (lastRowid != -1)
        {
            NSString *strValue=@"";
            for (int i=0; i<arrFullSizeImage.count; i++)
            {
                NSString *strLocalImage=[NSString stringWithFormat:@"%ld_bloodcountResult_%d.png",(long)lastRowid,i];
                
                [self saveImage:strLocalImage withImage:[arrFullSizeImage objectAtIndex:i]];
                
                if ([strValue isEqualToString:@""])
                {
                    strValue=strLocalImage;
                }
                else
                {
                    strValue=[NSString stringWithFormat:@"%@,%@",strValue,strLocalImage];
                }
                [arrImageName removeObject:strLocalImage];
            }
            
            [dictBloodCount setValue:strValue forKey:@"bloodcountsimages"];
            [App_Delegate.dbObj updateBloodCountResult:dictBloodCount];
            [self deleteAllImageFromLocal];
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
    
    SomeEdit = 0;
    
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

-(void)clickOnOpenDatePicker
{
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
    
    
    IsActionSheetVisible=NO;
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"MMM d, YYYY"];
    [dictBloodCount setValue:[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]] forKey:@"date"];
    
    
    double DateInDouble=[selectedDate timeIntervalSince1970];
    [dictBloodCount setValue:[NSNumber numberWithDouble:DateInDouble] forKey:@"date_to_order"];
    [tblView reloadData];
}

-(void)didCancelPicker
{
    IsActionSheetVisible=NO;
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

#pragma mark General Funtions

-(UIView *)creteScrollView:(int)index
{
    NSLog(@"Inde No %d",index);
    UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    [imgView setContentMode:UIViewContentModeScaleToFill];
    imgView.center=subView.center;
    
    UIButton *btnAddImage=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddImage setFrame:CGRectMake(0, 0, 50, 50)];
    
    if (index==0)
    {
        [imgView setImage:[UIImage imageNamed:@"btn_add_documents.png"]];
        
        [btnAddImage addTarget:self action:@selector(clickOnAddImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [subView addSubview:imgView];
    }
    else
    {
        btnAddImage.tag=index-1;
        [btnAddImage addTarget:self action:@selector(clickOnShowImage:) forControlEvents:UIControlEventTouchUpInside];
        [imgView setImage:[arrFiles objectAtIndex:index-1]];
        [subView addSubview:imgView];
    }
    [subView addSubview:btnAddImage];
    return subView;

}

-(void)clickOnShowImage:(id)sender
{
    UIButton *btnSender=(UIButton *)sender;
    if (!showImageView)
    {
        [self createShowImageView];
    }
    showImageView.tag = btnSender.tag;
    [imgShowMe setImage:[arrFullSizeImage objectAtIndex:btnSender.tag]];
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.view addSubview:showImageView];
                    } completion:NULL];
    
}

-(IBAction)clickOnAddImage:(id)sender
{
    SomeEdit = 1;
    NSLog(@"Hello");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera", nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    
}

// mark Image Picker delegate
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
    
    
    UIImage *selectedImage= info[UIImagePickerControllerEditedImage];
    if (!arrFiles)
    {
        arrFiles=[[NSMutableArray alloc]init];
        arrFullSizeImage=[[NSMutableArray alloc]init];
    }
    
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
        });
    }
    
    
    [arrFiles addObject:[self createImageThumbView:selectedImage]];
    [arrFullSizeImage addObject:selectedImage];
    [picker dismissViewControllerAnimated:NO completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [tblView reloadData];
    
}

-(UIImage *)createImageThumbView:(UIImage *)thumbImage
{
    CGRect rect = CGRectMake(0,0,42,42);
    UIGraphicsBeginImageContext( rect.size );
    [thumbImage drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    return img;
    
}

-(NSString *)saveImage:(NSString *)strFileName withImage:(UIImage *)imgSave
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
    NSString *filePath = @"";
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    filePath = [dataPath stringByAppendingPathComponent:strFileName];
    
    NSData *imageData = UIImagePNGRepresentation(imgSave);
    [imageData writeToFile:filePath atomically:YES];
    return filePath;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void)createShowImageView
{
    if (!showImageView)
    {
        showImageView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [showImageView setBackgroundColor:[UIColor lightTextColor]];
    }
    UIView *viewBack = [[UIView alloc] init];
    viewBack.frame = showImageView.frame;
    [viewBack setBackgroundColor:[UIColor darkTextColor]];
    viewBack.alpha = 0.8;
    [showImageView addSubview:viewBack];
    [showImageView sendSubviewToBack:viewBack];
    
    if (!imgShowMe)
    {
        imgShowMe =[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-40)];
        [imgShowMe setContentMode:UIViewContentModeScaleAspectFit];
    }
    [showImageView addSubview:imgShowMe];
    UIButton *btnclose=[[UIButton alloc]initWithFrame:CGRectMake(showImageView.frame.size.width-35,20, 35, 35)];
    [btnclose setTitle:@"X" forState:UIControlStateNormal];
    [btnclose setFont:[UIFont systemFontOfSize:30]];
    [btnclose.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [btnclose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclose setBackgroundColor:[UIColor redColor]];
    [btnclose addTarget:self action:@selector(clickOnRemoveView) forControlEvents:UIControlEventTouchUpInside];
    [showImageView addSubview:btnclose];
    
    UIButton *btnDelete=[[UIButton alloc]initWithFrame:CGRectMake(0,20, 35, 35)];
    [btnDelete setImage:[UIImage imageNamed:@"btn_delete.png"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(clickOnDeleteImage) forControlEvents:UIControlEventTouchUpInside];
    [showImageView addSubview:btnDelete];
    
}
-(void)clickOnDeleteImage
{
    [arrFiles removeObjectAtIndex:showImageView.tag];
    [arrFullSizeImage removeObjectAtIndex:showImageView.tag];
    [self clickOnRemoveView];
    [tblView reloadData];
    
}
-(void)deleteAllImageFromLocal
{
    if (arrImageName.count>0)
    {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
        for (int j=0; j<arrImageName.count; j++)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *filePath = [dataPath stringByAppendingPathComponent:[arrImageName objectAtIndex:j]];
            [fileManager removeItemAtPath:filePath error:NULL];
        }
    }
}
-(void)clickOnRemoveView
{
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [showImageView removeFromSuperview];
                    } completion:NULL];
    
    
}


-(BOOL)isCorrectDataTypeEntered
{
    NSInteger testForValidType = 0 ;
    
    if ([dictBloodCount valueForKey:@"HGB"])
    {
        testForValidType =  testForValidType + [App_Delegate validateString:[dictBloodCount valueForKey:@"HGB"] withPattern:DecimalNumbersExpression];
    }
    
    if ([dictBloodCount valueForKey:@"WBC"])
    {
        testForValidType =  testForValidType + [App_Delegate validateString:[dictBloodCount valueForKey:@"WBC"] withPattern:DecimalNumbersExpression];
    }
    
    if ([dictBloodCount valueForKey:@"ANC"])
    {
        testForValidType =  testForValidType + [App_Delegate validateString:[dictBloodCount valueForKey:@"ANC"] withPattern:DecimalNumbersExpression];
    }
    
    if ([dictBloodCount valueForKey:@"Platelets"])
    {
        testForValidType =  testForValidType + [App_Delegate validateString:[dictBloodCount valueForKey:@"Platelets"] withPattern:DecimalNumbersExpression];
    }
    if ([dictBloodCount valueForKey:@"Ferritin"])
    {
        testForValidType =  testForValidType + [App_Delegate validateString:[dictBloodCount valueForKey:@"Ferritin"] withPattern:DecimalNumbersExpression];
    }
    
    if (testForValidType > 0)
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter numeric data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
        return NO;
    }
    else
    {
        return YES;
    }
    
}


#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SomeEdit = 1;
    
    if (textField.tag==500 || textField.tag==501)
    {
        return YES;
    }
    else if (textField.superview.tag==BloodCounts)
    {
        if (textField.tag==0)
        {
            if (IsActionSheetVisible==NO)
            {
                [txtTemp resignFirstResponder];
                [tvTemp resignFirstResponder];
                IsActionSheetVisible=YES;
                [self clickOnOpenDatePicker];
            }
            
            return NO;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtTemp=textField;
    if (self.view.frame.size.height<=568)
    {
        if (textField.tag==3 || textField.tag==4 || textField.tag==5 || textField.tag==6 || textField.tag==7 || textField.superview.tag==1)
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
    else
    {
        if (textField.tag==6 || textField.tag==7 || textField.superview.tag==1)
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


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.superview.tag==BloodCounts)
    {
        if (textField.tag==1)
        {
            [dictBloodCount setValue:textField.text forKey:@"HGB"];
        }
        if (textField.tag==2)
        {
            [dictBloodCount setValue:textField.text forKey:@"WBC"];
        }
        if (textField.tag==3)
        {
            [dictBloodCount setValue:textField.text forKey:@"ANC"];
        }
        if (textField.tag==4)
        {
            [dictBloodCount setValue:textField.text forKey:@"Platelets"];
        }
        if (textField.tag==5)
        {
            [dictBloodCount setValue:textField.text forKey:@"Ferritin"];
        }
    }
    else if (textField.superview.tag==LabTest)
    {
        NSMutableDictionary *dictCare =[arrLabResult objectAtIndex:textField.tag];
        [dictCare setValue:textField.text forKey:@"labValue"];
        [arrLabResult replaceObjectAtIndex:textField.tag withObject:dictCare];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.view.frame.size.height<=568)
    {
        if (textField.tag==3 || textField.tag==4 || textField.tag==5 || textField.tag==6 || textField.tag==7 || textField.superview.tag==1 || IsUp)
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
    else
    {
        if (textField.tag==6 || textField.tag==7 || textField.superview.tag==1 || IsUp)
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
    //jitendra
    /*
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (textField.superview.tag==BloodCounts)
    {
        if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4 || textField.tag == 5 )
        {
            return stringIsValid;
        }
        
        return YES;
    }
    else if (textField == txtTestValue)
    {
        return stringIsValid;
    }
    else*/
    {
        return YES;
    }
}


-(void)MoveViewUp
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,-200,self.view.frame.size.width,self.view.frame.size.height)];
}

-(void)MoveViewDown
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}
#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    SomeEdit = 1;
    tvTemp=textView;
    if (textView.superview.tag == Notes)
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
    if (textView.superview.tag == BloodType)
    {
        [dictBloodCount setValue:textView.text forKey:@"bloodnotes"];
    }
    else
    {
        [dictBloodCount setValue:textView.text forKey:@"notes"];
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
        [textView resignFirstResponder];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void) dealloc
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
}

@end

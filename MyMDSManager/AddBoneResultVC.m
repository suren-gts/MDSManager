//
//  AddBoneResultVC.m
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "AddBoneResultVC.h"

#import "ProfileContentDisplayCell.h"
#import "AddNotesCell.h"
#import "AddFileNImagesCell.h"

@interface AddBoneResultVC ()

@end

#define AlertConfirmTag 251

@implementation AddBoneResultVC
@synthesize dictBoneMerrow;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!dictBoneMerrow)
    {
        dictBoneMerrow=[[NSMutableDictionary alloc]init];
    }
    if (self.editFlag==0)
    {
        lblPageTitle.text=@"ADD RESULT";
    }
    else
    {
        lblPageTitle.text=@"UPDATE RESULT";
    }
    
    NSString *strBoneImage=[dictBoneMerrow valueForKey:@"boneimages"];
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
    [tblView reloadData];
    // Do any additional setup after loading the view from its nib.
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


#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (section==0)
    {
        return 4;
    }
    else if (section==1)
    {
        return 1;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Row in Tableview
    if (indexPath.section==0)
    {
        if (indexPath.row==3)
        {
            return 110;
        }
        return 44;
    }
    else if(indexPath.section==1)
    {
        return 130;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    if (section==0)
    {
        return 0;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    else
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 20)];
        [view setBackgroundColor:[UIColor clearColor]];
        return view;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==3)
        {
            static NSString *CellIdentifier = @"AddNotesCell";
            
            AddNotesCell *cell = (AddNotesCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddNotesCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            cell.tvNotes.delegate=self;
            if ([dictBoneMerrow valueForKey:@"notes"])
            {
                cell.tvNotes.text=[dictBoneMerrow valueForKey:@"notes"];
            }
            else
            {
                cell.tvNotes.text=@"";
            }
            cell.tvNotes.inputAccessoryView = numberToolbar;            
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
            cell.txtField.inputAccessoryView = numberToolbar;
            
            if (indexPath.row==0)
            {
                cell.lblTitle.text=@"Date *";
                if ([dictBoneMerrow valueForKey:@"date"])
                {
                    cell.txtField.text=[dictBoneMerrow valueForKey:@"date"];
                }
                else
                {
                    cell.txtField.text=@"";
                }

            }
            else if (indexPath.row==1)
            {
                cell.lblTitle.text=@"Bone Marrow Blasts % *";
                if ([dictBoneMerrow valueForKey:@"boneblast"])
                {
                    cell.txtField.text=[dictBoneMerrow valueForKey:@"boneblast"];
                }
                else
                {
                    cell.txtField.text=@"";
                }
            }
            else  if (indexPath.row==2)
            {
                cell.lblTitle.text=@"Cytogenetics Desc";
                if ([dictBoneMerrow valueForKey:@"description"])
                {
                    cell.txtField.text=[dictBoneMerrow valueForKey:@"description"];
                }
                else
                {
                    cell.txtField.text=@"";
                }
                
                cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    else if (indexPath.section==1)
    {
        static NSString *MyIdentifier = @"AddFileNImagesCell";
        
        AddFileNImagesCell *cell = (AddFileNImagesCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            NSArray *arrNib=[[NSBundle mainBundle]loadNibNamed:@"AddFileNImagesCell" owner:self options:nil];
            cell=[arrNib objectAtIndex:0];
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
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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


-(void)doneWithNumberPad
{
    [tvTemp resignFirstResponder];
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
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if ([dictBoneMerrow valueForKey:@"date"] && [dictBoneMerrow valueForKey:@"boneblast"])
    {
        
        int rowId = -1;
        [dictBoneMerrow setValue:@"" forKey:@"boneimages"];
        
        if (![dictBoneMerrow valueForKey:@"notes"])
        {
            [dictBoneMerrow setValue:@"" forKey:@"notes"];
        }
        
        if (![dictBoneMerrow valueForKey:@"description"])
        {
            [dictBoneMerrow setValue:@"" forKey:@"description"];
        }
        
        if (self.editFlag==0)
        {
           rowId = [App_Delegate.dbObj insertBoneMarrowResult:dictBoneMerrow];
            [dictBoneMerrow setValue:[NSString stringWithFormat:@"%d",rowId] forKey:@"rowid"];
        }
        else
        {
            rowId = [[dictBoneMerrow valueForKey:@"rowid"] intValue];
            [App_Delegate.dbObj updateBoneMarrowResult:dictBoneMerrow];
        }
        if (rowId != -1)
        {
            NSString *strValue=@"";
            for (int i=0; i<arrFullSizeImage.count; i++)
            {
                NSString *strLocalImage=[NSString stringWithFormat:@"%d_bonemarrowResult_%d.png",rowId,i];
                
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
            
            [dictBoneMerrow setValue:strValue forKey:@"boneimages"];
            [App_Delegate.dbObj updateBoneMarrowResult:dictBoneMerrow];
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


-(void)clickOnValuePicker:(NSInteger)rowTag withSection:(NSInteger)sectionTag
{
    
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }

    objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
    objPicker.valueDelegate=self;
    objPicker.rowId=rowTag;
    objPicker.sectionId=sectionTag;
    objPicker.EntryTag=5;
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
    IsActionSheetVisible=NO;
    if (section==0)
    {
        if (row==1)
        {
            [dictBoneMerrow setValue: [NSString stringWithFormat:@"%@",strValue] forKey:@"boneblast"];
        }
    }
    [tblView reloadData];
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
    [dateformater setDateFormat:@"MMM dd, YYYY"];
    [dictBoneMerrow setValue:[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]] forKey:@"date"];
    [tblView reloadData];
}

-(void)didCancelPicker
{
    IsActionSheetVisible=NO;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SomeEdit = 1;
    
    if (textField.superview.tag==0)
    {
        if (textField.tag==1)
        {
            if (IsActionSheetVisible==NO)
            {
                IsActionSheetVisible=YES;
                [self clickOnValuePicker:textField.tag withSection:textField.superview.tag];
            }
            
            return NO;
        }
        else if (textField.tag==0)
        {
            if (IsActionSheetVisible==NO)
            {
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
    if (textField.tag==500 )
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.superview.tag==0)
    {
        if (textField.tag==2)
        {
            [dictBoneMerrow setValue:textField.text forKey:@"description"];
        }
    }
   
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==500 || IsUp)
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
    SomeEdit = 1;
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
    [dictBoneMerrow setValue:textView.text forKey:@"notes"];
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

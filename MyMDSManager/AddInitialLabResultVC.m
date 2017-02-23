//
//  AddInitialLabResultVC.m
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "AddInitialLabResultVC.h"
#import "ProfileContentDisplayCell.h"
#import "AddNotesCell.h"
#import "AddFileNImagesCell.h"

#define CustomDiagnosisTableTag 501

@interface AddInitialLabResultVC ()

@end

#define AlertConfirmTag  112

@implementation AddInitialLabResultVC

@synthesize editFlag,objLabResult;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!objLabResult)
    {
        objLabResult=[[LabResultObject alloc]initDefaults];
    }
    
    if (self.editFlag==0)
    {
        lblPageTitle.text=@"ADD LAB RESULT";
    }
    else
    {
        if (objLabResult.strLabImages.length>0)
        {
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
            arrImageName=[[objLabResult.strLabImages componentsSeparatedByString:@","] mutableCopy];
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
                
                if (imglab)
                {
                     [arrFullSizeImage addObject:imglab];
                }
                
               
                
            }
        }
        lblPageTitle.text=@"UPDATE LAB RESULT";
    }
    
    //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    txtNewDiagnosis.inputAccessoryView = numberToolbar;
    [self createAddNewDiagnosisTest];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == CustomDiagnosisTableTag)
    {
        return 1;
    }
    return 2;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (tableView.tag == CustomDiagnosisTableTag)
    {
        return arrCustomDiagnosis.count;
    }
    if (section==0)
    {
        return 5;
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
    if (tableView.tag == CustomDiagnosisTableTag)
    {
        return 44;
    }
    if (indexPath.section==0)
    {
        if (indexPath.row==4)
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
    if (tableView.tag == CustomDiagnosisTableTag)
    {
        return 30;
    }
    if (section==0)
    {
        return 0;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == CustomDiagnosisTableTag)
    {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 30)];
        headerView.backgroundColor=[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0];
        UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, tblView.frame.size.width-20, 21)];
        lblTitle.textColor=[UIColor whiteColor];
        [lblTitle setText:@"User's Custom Diagnostic List"];
        [headerView addSubview:lblTitle];
        return headerView;
    }
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
    if (tableView.tag==CustomDiagnosisTableTag)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier] ;
        }
        if (arrCustomDiagnosis.count>0)
        {
            cell.textLabel.text = [arrCustomDiagnosis objectAtIndex:indexPath.row];
        }
        
        return cell;
    }
    else
    {
        if (indexPath.section==0)
        {
            if (indexPath.row==4)
            {
                static NSString *CellIdentifier = @"AddNotesCell";
                
                AddNotesCell *cell = (AddNotesCell *) [tableView
                                                       dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddNotesCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.tvNotes.delegate=self;
                cell.tvNotes.text=objLabResult.strNotes;
                cell.tvNotes.inputAccessoryView = numberToolbar;
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
                
                cell.txtField.delegate=self;
                cell.txtField.hidden=NO;
                cell.txtField.userInteractionEnabled=YES;
                cell.txtField.tag=indexPath.row;
                cell.txtField.superview.tag=indexPath.section;
                
                if (indexPath.row==0)
                {
                    cell.lblTitle.text=@"Diagnostic Test *";
                    cell.lblValue.text=objLabResult.strDiagnosisTest;
                    cell.txtField.text=objLabResult.strDiagnosisTest;
                }
                else if (indexPath.row==1)
                {
                    cell.lblTitle.text=@"Date *";
                    cell.lblValue.text=objLabResult.strDate;
                    cell.txtField.text=objLabResult.strDate;
                }
                else if (indexPath.row==2)
                {
                    cell.lblTitle.text=@"Results Value";
                    cell.lblValue.text=objLabResult.strResult;
                    cell.txtField.text=objLabResult.strResult;
                    cell.txtField.inputAccessoryView = numberToolbar;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                else  if (indexPath.row==3)
                {
                    cell.lblTitle.text=@"Results Units";
                    cell.lblValue.text=objLabResult.strUnits;
                    cell.txtField.text=objLabResult.strUnits;
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
    }
   
   return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (tableView.tag == CustomDiagnosisTableTag)
    {
        return  YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==CustomDiagnosisTableTag)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            NSString *strTest = [arrCustomDiagnosis objectAtIndex:indexPath.row];
            
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:strTest];
            [arrCustomDiagnosis removeObject:strTest];
            
            NSMutableArray *arrUnits = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisUnits"] mutableCopy];
            [arrUnits removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults]setObject:arrCustomDiagnosis forKey:@"DiagnosisTest"];
            [[NSUserDefaults standardUserDefaults]setObject:arrUnits forKey:@"DiagnosisUnits"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (arrCustomDiagnosis.count>0)
            {
                tblCustomDiagnosisList.hidden=NO;
                [tblCustomDiagnosisList reloadData];
            }
            else
            {
                tblCustomDiagnosisList.hidden=YES;
            }
        }
    }
}


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

#pragma mark General Funtions

-(UIView *)creteScrollView:(int)index
{
    NSLog(@"Inde No %d",index);
    UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//    subView.backgroundColor=[UIColor blueColor];
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
    showImageView.tag=btnSender.tag;
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
    
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
        });
    }
    
    
    if (!arrFiles)
    {
        arrFiles=[[NSMutableArray alloc]init];
        arrFullSizeImage=[[NSMutableArray alloc]init];
        arrImageName=[[NSMutableArray alloc]init];
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

-(void)createAddNewDiagnosisTest
{
    if (!viewNewDiagnosis)
    {
        viewNewDiagnosis=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [viewNewDiagnosis setBackgroundColor:[UIColor lightTextColor]];
    }
    UIView *viewBack = [[UIView alloc] init];
    viewBack.frame = viewNewDiagnosis.frame;
    [viewBack setBackgroundColor:[UIColor darkTextColor]];
    viewBack.alpha = 0.8;
    [viewNewDiagnosis addSubview:viewBack];
    [viewNewDiagnosis sendSubviewToBack:viewBack];
    
    UIView *subResultView=[[UIView alloc]initWithFrame:CGRectMake(5, 0, 310, self.view.frame.size.height-70)];
    subResultView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [subResultView setBackgroundColor:[UIColor whiteColor]];
    subResultView.layer.cornerRadius=5.0;
    subResultView.layer.masksToBounds=YES;
    [viewNewDiagnosis addSubview:subResultView];
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, 280, 29)];
    [lblTitle setText:@"Diagnostic"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor redColor]];
    [lblTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0]];
    
    [subResultView addSubview:lblTitle];
    
    txtNewDiagnosis=[[UITextField alloc]initWithFrame:CGRectMake(15, 65, 280, 35)];
    [txtNewDiagnosis setBorderStyle:UITextBorderStyleLine];
    txtNewDiagnosis.delegate=self;
    txtNewDiagnosis.tag=500;
    txtNewDiagnosis.placeholder=@"Enter Diagnostic Test *";
    txtNewDiagnosis.inputAccessoryView = numberToolbar;
    [subResultView addSubview:txtNewDiagnosis];
    
    txtNewUnit=[[UITextField alloc]initWithFrame:CGRectMake(15, 110, 280, 35)];
    [txtNewUnit setBorderStyle:UITextBorderStyleLine];
    txtNewUnit.delegate=self;
    txtNewUnit.tag=500;
    txtNewUnit.placeholder=@"Enter Test Unit";
    txtNewUnit.inputAccessoryView = numberToolbar;
    [subResultView addSubview:txtNewUnit];
    
    txtNormalValueMale=[[UITextField alloc]initWithFrame:CGRectMake(15, 155, 280, 35)];
    [txtNormalValueMale setBorderStyle:UITextBorderStyleLine];
    txtNormalValueMale.delegate=self;
    txtNormalValueMale.tag=101;
    txtNormalValueMale.placeholder=@"Enter Normal Value(Male)";
    txtNormalValueMale.inputAccessoryView = numberToolbar;
    [subResultView addSubview:txtNormalValueMale];
    
    txtNormalValueFemale=[[UITextField alloc]initWithFrame:CGRectMake(15, 200, 280, 35)];
    [txtNormalValueFemale setBorderStyle:UITextBorderStyleLine];
    txtNormalValueFemale.delegate=self;
    txtNormalValueFemale.tag=101;
    txtNormalValueFemale.placeholder=@"Enter Normal Value(Female)";
    txtNormalValueFemale.inputAccessoryView = numberToolbar;
    [subResultView addSubview:txtNormalValueFemale];
    
    UIButton *btnAddDiagnosis=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddDiagnosis setFrame:CGRectMake(15, 245, 280, 35)];
    [btnAddDiagnosis setTitle:@"Add Diagnostic" forState:UIControlStateNormal];
    [btnAddDiagnosis setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAddDiagnosis setBackgroundImage:[UIImage imageNamed:@"btn_add_diagnosis.png"] forState:UIControlStateNormal];
    [btnAddDiagnosis addTarget:self action:@selector(addDiagnosis) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnAddDiagnosis];
    
    tblCustomDiagnosisList = [[UITableView alloc] initWithFrame:CGRectMake(0,290, 310, subResultView.frame.size.height-290) style:UITableViewStylePlain];
    tblCustomDiagnosisList.delegate=self;
    tblCustomDiagnosisList.dataSource=self;
    tblCustomDiagnosisList.tag=CustomDiagnosisTableTag;
    tblCustomDiagnosisList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [subResultView addSubview:tblCustomDiagnosisList];
    
    
    UIButton *btnclose=[[UIButton alloc]initWithFrame:CGRectMake(275,0, 35, 35)];
    [btnclose setTitle:@"X" forState:UIControlStateNormal];
    [btnclose.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [btnclose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclose setBackgroundColor:[UIColor redColor]];
    [btnclose addTarget:self action:@selector(clickOnRemoveNewDiagnosisView) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnclose];
    
}

-(void)addDiagnosis
{
    if (txtNewDiagnosis.text.length>0)
    {
        NSMutableArray *arrDiagnosis;
        
        NSMutableArray *arrUnits;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisTest"])
        {
            arrDiagnosis = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisTest"] mutableCopy];
            arrUnits = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisUnits"] mutableCopy];

            if (![[NSUserDefaults standardUserDefaults]objectForKey:txtNewDiagnosis.text])
            {
                [arrDiagnosis addObject:txtNewDiagnosis.text];
                [arrUnits addObject:txtNewUnit.text];
            }
        }
        else
        {
            arrDiagnosis = [[NSMutableArray alloc] init];
            [arrDiagnosis addObject:txtNewDiagnosis.text];
            
            arrUnits = [[NSMutableArray alloc] init];
            [arrUnits addObject:txtNewUnit.text];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:arrDiagnosis forKey:@"DiagnosisTest"];
        [[NSUserDefaults standardUserDefaults]setObject:arrUnits forKey:@"DiagnosisUnits"];
        
        NSMutableDictionary *dicTest = [[NSMutableDictionary alloc]init];
        [dicTest setValue:txtNewDiagnosis.text forKey:@"diagnosis_test"];
        [dicTest setValue:txtNewUnit.text forKey:@"unit"];
        [dicTest setValue:txtNormalValueMale.text forKey:@"normal_value_male"];
        [dicTest setValue:txtNormalValueFemale.text forKey:@"normal_value_female"];
        
        [[NSUserDefaults standardUserDefaults]setObject:dicTest forKey:txtNewDiagnosis.text];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self clickOnRemoveNewDiagnosisView];
        
        App_Delegate.isNewAddedInList =YES;
        
        [self clickOnValuePicker:0 withSection:0];
    }
    else
    {
      UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter Diagnostic Test before submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
    }
}

-(void)clickOnNewDiagnosisView:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisTest"])
    {
        arrCustomDiagnosis = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DiagnosisTest"] mutableCopy];
    }
    else
    {
        arrCustomDiagnosis = [[NSMutableArray alloc] init];
    }
    
    if (arrCustomDiagnosis.count>0)
    {
        tblCustomDiagnosisList.hidden = NO;
        [tblCustomDiagnosisList reloadData];
    }
    else
    {
        tblCustomDiagnosisList.hidden = YES;
        
    }
    txtNewDiagnosis.text = @"";
    txtNewUnit.text = @"";
    txtNormalValueFemale.text = @"";
    txtNormalValueMale.text = @"";
    
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.view addSubview:viewNewDiagnosis];
                    } completion:NULL];
    
}

-(void)clickOnRemoveNewDiagnosisView
{
    txtNewDiagnosis.text=@"";
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [viewNewDiagnosis removeFromSuperview];
                    } completion:NULL];
    
    
}

-(IBAction)clickOnSave:(id)sender
{
    UIButton *btnSender=(UIButton *)sender;
    [tvTemp resignFirstResponder];
    [txtTemp resignFirstResponder];
    if (self.entryTag==0)
    {
        if (objLabResult.strDate.length>0 && objLabResult.strDiagnosisTest.length > 0)
        {
            int rowId = -1;
            objLabResult.strLabImages=@"";
            
            if (self.editFlag==0)
            {
               rowId = [App_Delegate.dbObj insertBloodCellInitialLabResult:objLabResult];
            }
            else
            {
                rowId =[objLabResult.strId intValue];
                [App_Delegate.dbObj updateInitialLabReuslts:objLabResult];
            }
            if (rowId != -1)
            {
                NSString *strValue=@"";
                for (int i=0; i<arrFullSizeImage.count; i++)
                {
                    NSString *strLocalImage=[NSString stringWithFormat:@"%d_labresultinfo_%d.png",rowId,i];
                    
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
                objLabResult.strLabImages=strValue;
                objLabResult.strId = [NSString stringWithFormat:@"%d",rowId];
               [App_Delegate.dbObj updateInitialLabReuslts:objLabResult];
               [self deleteAllImageFromLocal];
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
        if (objLabResult.strDate.length>0 && objLabResult.strDiagnosisTest.length > 0)
        {
            int rowId = -1;
            objLabResult.strLabImages=@"";
            if (self.editFlag==0)
            {
               rowId = [App_Delegate.dbObj insertBloodCellOnGoingLabResult:objLabResult];
            }
            else
            {
                rowId =[objLabResult.strId intValue];
                [App_Delegate.dbObj updateInitialLabReuslts:objLabResult];
            }
            if (rowId != -1)
            {
                NSString *strValue=@"";
                for (int i=0; i<arrFullSizeImage.count; i++)
                {
                    NSString *strLocalImage=[NSString stringWithFormat:@"%d_labresultinfo_%d.png",rowId,i];
                    
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
                objLabResult.strLabImages=strValue;
                objLabResult.strId = [NSString stringWithFormat:@"%d",rowId];
                [App_Delegate.dbObj updateInitialLabReuslts:objLabResult];
                [self deleteAllImageFromLocal];
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
    objPicker.EntryTag=1;
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
        if (row==0)
        {
            if ([strValue isEqualToString:@"Other"])
            {
                [self clickOnNewDiagnosisView:nil];
            }
            else
            {
                objLabResult.strDiagnosisTest=strValue;
                if ([App_Delegate.dictTest valueForKey:strValue])
                {
                    objLabResult.strUnits=[App_Delegate.dictTest valueForKey:strValue];
                }
                else
                {
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:strValue])
                    {
                        NSMutableDictionary *dictNormal = [[NSUserDefaults standardUserDefaults] objectForKey:strValue];
                        objLabResult.strUnits = [dictNormal valueForKey:@"unit"];
                    }
                }
                


                
            }
                
        }
        else if (row==3)
        {
            objLabResult.strUnits=[NSString stringWithFormat:@"%@",strValue];
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
    // objDate.view.frame=self.view.frame;
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
    [dateformater setDateStyle:NSDateFormatterMediumStyle];
    objLabResult.strDate=[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]];
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
        if (textField.tag==0 || textField.tag==3)
        {
            if (IsActionSheetVisible==NO)
            {
                IsActionSheetVisible=YES;
                [self clickOnValuePicker:textField.tag withSection:textField.superview.tag];
            }
           
            return NO;
        }
        else if (textField.tag==1)
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.superview.tag==0)
    {
        if (textField.tag==2)
        {
            objLabResult.strResult=textField.text;
        }
    }
    else if (textField.superview.tag==1)
    {
        
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtTemp=textField;
    if (textField.tag ==101)
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
    if (IsUp)
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
    objLabResult.strNotes=textView.text;
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

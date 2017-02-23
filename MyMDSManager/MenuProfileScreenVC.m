//
//  MenuProfileScreenVC.m
//  MyMDSManager
//
//  Created by CEPL on 03/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "MenuProfileScreenVC.h"
#import "ProfileContentDisplayCell.h"
#import "ProfileHeaderCell.h"
#import "MedicalHistoryScreenVC.h"
#import "InicialLabResultVC.h"
#import "TwoFieldValueEntryCell.h"
#import "ButtonCell.h"
#import "MFSideMenu.h"
#import "AddAllergyInputCell.h"
#import "CaregiverContentCell.h"
#import "GenderSelectionCell.h"
#import "CustomIOSAlertView.h"
#import "PhoneNoCell.h"
#import "TakePicCell.h"
#import "RMPhoneFormat.h"

#define CaregiverOrAlerggySaveChangesAlertTag           234


@interface MenuProfileScreenVC ()

@end

#define OtherListTableTag 501

#define IImage           0
#define IOption          1
#define IName            2
#define IPhoneNumber     3
#define IEmployer        4
#define IGroup           5
#define IPrescription    6
#define IAddress         7
#define ICity            8
#define IState           9
#define IZipcode         10



#define txtCaregiverOrAlergyNameTag     2002
#define txtRelationTag                  2003
#define txtContactNoTag                 2004
#define txtEmailTag                     2005

@implementation MenuProfileScreenVC

RMPhoneFormat *_phoneFormat;
NSMutableCharacterSet *_phoneChars;
UITextField *_textField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dictEditAction=[[NSMutableDictionary alloc]init];
    
    dictColleps=[[NSMutableDictionary alloc]init];
    dictEditAction=[[NSMutableDictionary alloc]init];
    
    arrInsurance=[App_Delegate.dbObj getInsuranceDetail];
    
    IsActionSheetVisible=NO;
    txtName.userInteractionEnabled=NO;
    btnTakeUserPic.userInteractionEnabled=NO;
    [btnEditUserName setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    arrSections=[[NSArray alloc]initWithObjects:@"About",@"Contact",@"Caregivers",@"Allergie",@"Medical History",@"Primary Insurance Company",@"Secondary Insurance Company", nil];
    imgUser.layer.cornerRadius=imgUser.frame.size.width/2;
    imgUser.layer.masksToBounds=YES;
    imgUser.clipsToBounds=YES;
    imgUser.layer.borderWidth=1;
    imgUser.layer.borderColor=[UIColor whiteColor].CGColor;
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"userImage"])
    {
        NSString *strUserImage=[[NSUserDefaults standardUserDefaults]valueForKey:@"userImage"];
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"/MyImages/",strUserImage]];
        [imgUser setImage:[UIImage imageWithContentsOfFile:filePath]];
    }
    
    //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    txtTemp.delegate=self;
    txtName.inputAccessoryView = numberToolbar;
    
    [App_Delegate.dbObjUserInfo getUserInfo];

    arrCareGivers=[App_Delegate.dbObjUserInfo getAllCaregiver];
    arrAlergies=[App_Delegate.dbObjUserInfo getAllAlergy];
    txtName.text=App_Delegate.objAppPerson.strName;
    lblPageTitle.text=App_Delegate.objAppPerson.strName;

    txtCaregiverOrAlergyName.superview.tag=2;
    txtCaregiverOrAlergyName.inputAccessoryView=numberToolbar;
    txtContactNo.superview.tag=2;
    txtContactNo.inputAccessoryView=numberToolbar;
    txtRelation.superview.tag=2;
    txtRelation.inputAccessoryView=numberToolbar;
    txtEmail.superview.tag=2;
    txtEmail.inputAccessoryView=numberToolbar;
    tvAlergyNotes.superview.tag=2;
    tvAlergyNotes.inputAccessoryView=numberToolbar;
    
    
    
    txtCaregiverOrAlergyName.tag = txtCaregiverOrAlergyNameTag;
    txtRelation.tag              = txtRelationTag;
    txtContactNo.tag             = txtContactNoTag;
    txtEmail.tag                 = txtEmailTag;
    
    [self createViewOtherFromList];
    
    txtCaregiverOrAlergyName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [tblView reloadData];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setupFormatter];
   // _phoneFormat = [[RMPhoneFormat alloc] initWithDefaultCountry:@"uk"];

    
    _phoneChars = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    [_phoneChars addCharactersInString:@"+*#,"];
    
    // Listen for changes locale (if the user changes the Region Format settings)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeChanged) name:NSCurrentLocaleDidChangeNotification object:nil];
    
    dicUserInfo=[[NSMutableDictionary alloc]init];
    
    SomeEdit=0;
    SomeEditCaregiverOrAlergy = 0;
    
}

- (void)setupFormatter
{
    _phoneFormat = [[RMPhoneFormat alloc] init];
}
- (void)localeChanged
{
    [self setupFormatter];
    
    // Reformat the current phone number
    if (_textField)
    {
        NSString *text = _textField.text;
        NSString *phone = [_phoneFormat format:text];
        _textField.text = phone;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode=MFSideMenuPanModeSideMenu;
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //count of section
    if (tableView.tag == OtherListTableTag)
    {
        return 1;
    }
    return arrSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (tableView.tag == OtherListTableTag)
    {
        return arrOtherList.count;
    }
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",section];
    if (section==About)
    {
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        return 6;
    }
    else if (section==ContactInfo)
    {
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        return 10;
    }
    else if (section==Caregiver)
    {
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        return arrCareGivers.count;
    }
    else if (section==Alergies)
    {
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        return arrAlergies.count;
    }
    else if(section == PInsurance)
    {
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        return 11;
    }
    else if (section == SInsurance)
    {
        if ([dictColleps valueForKey:strSection])
        {
            return 0;
        }
        return 11;
    }

    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //Height of Row in Tableview
    if (tableView.tag == OtherListTableTag)
    {
        return 44;
    }
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",indexPath.section];
    if ([dictColleps valueForKey:strSection])
    {
        return 0;
    }
    if (indexPath.section==Caregiver)
    {
        return 44;
    }
    if (indexPath.section==Alergies)
    {
        return 44;
    }
    if (indexPath.section == PInsurance || indexPath.section == SInsurance)
    {
        if (indexPath.row==IImage)
        {
            return 100;
        }
    }

    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    if (tableView.tag == OtherListTableTag)
    {
        return 30;
    }
    if (section==MedicalHistory )
    {
        return 0;
    }
    return 44;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //View for Section Header of TableView
    if (tableView.tag == OtherListTableTag)
    {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 30)];
        headerView.backgroundColor=[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0];
        UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, tblView.frame.size.width-20, 21)];
        lblTitle.textColor=[UIColor whiteColor];
        [lblTitle setText:@"User's Custom List"];
        [headerView addSubview:lblTitle];
        return headerView;

    }
    if (section==MedicalHistory )
    {
        return nil;
    }
    else
    {
        NSString *CellIdentifier = @"ProfileHeaderCell";
        
        ProfileHeaderCell *cell = (ProfileHeaderCell *) [tableView
                                                         dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileHeaderCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        //to remove edition for sections
        //cell.btnActions.hidden=NO;
        //cell.btnActions.userInteractionEnabled=YES;
        cell.btnActions.hidden=YES;
        cell.btnActions.userInteractionEnabled=NO;
        
        
        cell.btnColleps.hidden=NO;
        cell.btnColleps.userInteractionEnabled=YES;
      
        NSString *strSection=[NSString stringWithFormat:@"Section%ld",section];
        if (section==About)
        {
            cell.lblHeaderTitle.text=@"About";
            if ([dictEditAction valueForKey:strSection])
            {
                [cell.btnActions setImage:[UIImage imageNamed:@"icn_save.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnActions setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
            }
        }
        else if (section==ContactInfo)
        {
            cell.lblHeaderTitle.text=@"Contact Info";
            if ([dictEditAction valueForKey:strSection])
            {
                [cell.btnActions setImage:[UIImage imageNamed:@"icn_save.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnActions setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
            }
        }
        else if (section==Caregiver)
        {
            cell.btnActions.hidden=NO;
            cell.btnActions.userInteractionEnabled=YES;
            
            cell.lblHeaderTitle.text=@"Caregivers";
            [cell.btnActions setImage:[UIImage imageNamed:@"icn_add.png"] forState:UIControlStateNormal];
        }
        else if (section==Alergies)
        {
            cell.btnActions.hidden=NO;
            cell.btnActions.userInteractionEnabled=YES;
            
            cell.lblHeaderTitle.text=@"Allergies";
            [cell.btnActions setImage:[UIImage imageNamed:@"icn_add.png"] forState:UIControlStateNormal];
        }
        else if (section==PInsurance)
        {
            cell.lblHeaderTitle.text=@"Primary Insurance Company";
            if ([dictEditAction valueForKey:strSection])
            {
                [cell.btnActions setImage:[UIImage imageNamed:@"icn_save.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnActions setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
            }
        }
        else if (section==SInsurance)
        {
            cell.lblHeaderTitle.text=@"Secondary Insurance Company";
            if ([dictEditAction valueForKey:strSection])
            {
                [cell.btnActions setImage:[UIImage imageNamed:@"icn_save.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnActions setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
            }
        }
        
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
        
        cell.btnActions.tag=section;
        [cell.btnActions addTarget:self action:@selector(clickOnHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor=[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0];
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==OtherListTableTag)
    {
        NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier] ;
        }
        if (arrOtherList.count>0)
        {
            NSMutableDictionary *dict = [arrOtherList objectAtIndex:indexPath.row];
            cell.textLabel.text = [arrOtherList objectAtIndex:indexPath.row];
        }
        
        return cell;
    }
    else
    {
        NSString *strSection=[NSString stringWithFormat:@"Section%ld",indexPath.section];
        if (indexPath.section==About)
        {
            if (indexPath.row==1)
            {
                if ([dictEditAction valueForKey:strSection])
                {
                    NSString *CellIdentifier = @"GenderSelectionCell";
                    
                    GenderSelectionCell *cell = (GenderSelectionCell *) [tableView
                                                                         dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"GenderSelectionCell" owner:self options:nil];
                        cell=[nib objectAtIndex:0];
                    }
                    if ([App_Delegate.objAppPerson.strGender isEqualToString:@"Male"])
                    {
                        [cell.btnMale setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
                        [cell.btnFemale setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                        [cell.btnDontDisClose setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                    }
                    else if ([App_Delegate.objAppPerson.strGender isEqualToString:@"Female"])
                    {
                        [cell.btnMale setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                        [cell.btnFemale setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
                        [cell.btnDontDisClose setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                    }
                    else if ([App_Delegate.objAppPerson.strGender isEqualToString:@"Don't Disclose"])
                    {
                        [cell.btnMale setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                        [cell.btnFemale setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                        [cell.btnDontDisClose setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [cell.btnMale setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                        [cell.btnFemale setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                        [cell.btnDontDisClose setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
                    }
                    [cell.btnMale addTarget:self action:@selector(updateUserGender:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btnFemale addTarget:self action:@selector(updateUserGender:) forControlEvents:UIControlEventTouchUpInside];
                     [cell.btnDontDisClose addTarget:self action:@selector(updateUserGender:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else
                {
                    NSString *CellIdentifier = @"ProfileContentDisplayCell";
                    
                    ProfileContentDisplayCell *cell = (ProfileContentDisplayCell *) [tableView
                                                                                     dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil)
                    {
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileContentDisplayCell" owner:self options:nil];
                        cell=[nib objectAtIndex:0];
                    }
                    
                    cell.txtField.hidden=YES;
                    cell.txtField.userInteractionEnabled=NO;
                    
                    cell.lblTitle.text=@"Gender";
                    cell.lblValue.text=App_Delegate.objAppPerson.strGender;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            else
            {
                NSString *CellIdentifier = @"ProfileContentDisplayCell";
                
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
                }
                else
                {
                    cell.txtField.hidden=YES;
                    cell.txtField.userInteractionEnabled=NO;
                }
                if (indexPath.row==0)
                {
                    cell.lblTitle.text=@"Date Of Birth";
                    cell.lblValue.text=App_Delegate.objAppPerson.strDOB;
                    cell.txtField.text=App_Delegate.objAppPerson.strDOB;
                }
                else if (indexPath.row==2)
                {
                    cell.lblTitle.text=@"Height";
                    NSArray *arr=[App_Delegate.objAppPerson.strHeight componentsSeparatedByString:@","];
                    NSString *str=@"";
                    if (arr.count>1)
                    {
                        str=[NSString stringWithFormat:@"%@' %@\"",[arr objectAtIndex:0],[arr objectAtIndex:1]];
                    }
                    else
                    {
                        str=App_Delegate.objAppPerson.strHeight;
                    }
                    cell.lblValue.text=str;
                    cell.txtField.text=str;
                }
                else if (indexPath.row==3)
                {
                    cell.lblTitle.text=@"Weight";
                    cell.lblValue.text=App_Delegate.objAppPerson.strWeight;
                    cell.txtField.text=App_Delegate.objAppPerson.strWeight;
                }
                else  if (indexPath.row==4)
                {
                    cell.lblTitle.text=@"Marital Status";
                    cell.lblValue.text=App_Delegate.objAppPerson.strMaritalStatus;
                    cell.txtField.text=App_Delegate.objAppPerson.strMaritalStatus;
                }
                
                else if (indexPath.row==5)
                {
                    cell.lblTitle.text=@"Living Status";
                    cell.lblValue.text=App_Delegate.objAppPerson.strLivingWith;
                    cell.txtField.text=App_Delegate.objAppPerson.strLivingWith;
                }
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
        else if (indexPath.section==ContactInfo)
        {
            if(indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9)
            {
                NSString *CellIdentifier = @"PhoneNoCell";
                
                PhoneNoCell *cell = (PhoneNoCell *) [tableView
                                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PhoneNoCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
              
                cell.txtField.inputAccessoryView = numberToolbar;
                
                if ([dictEditAction valueForKey:strSection])
                {
                    cell.txtField.delegate=self;
                    cell.txtField.hidden=NO;
                    cell.txtField.userInteractionEnabled=YES;
                    cell.txtField.tag=indexPath.row;
                    cell.txtField.superview.tag=indexPath.section;

                    cell.btnCountryCode.userInteractionEnabled = YES;
                    cell.btnCountryCode.tag = indexPath.row;
                    cell.btnCountryCode.superview.tag = indexPath.section;
                    [cell.btnCountryCode addTarget:self action:@selector(clickOnSelectCountryCode:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.txtField.hidden=YES;
                    cell.txtField.userInteractionEnabled=NO;
                    cell.btnCountryCode.userInteractionEnabled = NO;
                }
                
                if (indexPath.row==7)
                {
                    cell.lblTitle.text=@"Home Phone";
                    cell.lblValue.text=App_Delegate.objAppPerson.strContactNoHome;
                    cell.txtField.text=App_Delegate.objAppPerson.strContactNoHome;
                    [cell.btnCountryCode setTitle:[NSString stringWithFormat:@"+%@",App_Delegate.objAppPerson.strCountryCodeHome] forState:UIControlStateNormal];
                    cell.txtField.inputAccessoryView = numberToolbar;
                    
                    //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                    
                    
                    [cell.txtField addTarget:self action:@selector(autoFormatTextField:) forControlEvents:UIControlEventEditingChanged];
                    
                }
                else  if (indexPath.row==8)
                {
                    cell.lblTitle.text=@"Work Phone";
                    cell.lblValue.text=App_Delegate.objAppPerson.strContactNoWork;
                    cell.txtField.text=App_Delegate.objAppPerson.strContactNoWork;
                    [cell.btnCountryCode setTitle:[NSString stringWithFormat:@"+%@",App_Delegate.objAppPerson.strCountryCodeWork] forState:UIControlStateNormal];
                    cell.txtField.inputAccessoryView = numberToolbar;
                    
                    //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                }
                else if (indexPath.row==9)
                {
                    cell.lblTitle.text=@"Mobile";
                    cell.lblValue.text=App_Delegate.objAppPerson.strContactNoCell;
                    cell.txtField.text=App_Delegate.objAppPerson.strContactNoCell;
                    [cell.btnCountryCode setTitle:[NSString stringWithFormat:@"+%@",App_Delegate.objAppPerson.strCountryCodeCell] forState:UIControlStateNormal];
                    cell.txtField.inputAccessoryView = numberToolbar;
                   
                    //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                }
              
              
                
                return cell;
                
            }
            else
            {
                NSString *CellIdentifier = @"ProfileContentDisplayCell";
                
                ProfileContentDisplayCell *cell = (ProfileContentDisplayCell *) [tableView
                                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileContentDisplayCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                cell.txtField.inputAccessoryView = numberToolbar;
                 cell.txtField.delegate=self;
                if ([dictEditAction valueForKey:strSection])
                {
                   
                    cell.txtField.hidden=NO;
                    cell.txtField.userInteractionEnabled=YES;
                    cell.txtField.tag=indexPath.row;
                    cell.txtField.superview.tag=indexPath.section;
                }
                else
                {
                    cell.txtField.hidden=YES;
                    cell.txtField.userInteractionEnabled=NO;
                }
                
                if (indexPath.row==0)
                {
                    cell.lblTitle.text=@"Address Line 1";
                    cell.lblValue.text=App_Delegate.objAppPerson.strAddress1;
                    cell.txtField.text=App_Delegate.objAppPerson.strAddress1;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                else if (indexPath.row==1)
                {
                    cell.lblTitle.text=@"Address Line 2";
                    cell.lblValue.text=App_Delegate.objAppPerson.strAddress2;
                    cell.txtField.text=App_Delegate.objAppPerson.strAddress2;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                }
                else if (indexPath.row==2)
                {
                    cell.lblTitle.text=@"Address Line 3";
                    cell.lblValue.text=App_Delegate.objAppPerson.strAddress3;
                    cell.txtField.text=App_Delegate.objAppPerson.strAddress3;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                }
                else  if (indexPath.row==3)
                {
                    cell.lblTitle.text=@"City";
                    cell.lblValue.text=App_Delegate.objAppPerson.strCity;
                    cell.txtField.text=App_Delegate.objAppPerson.strCity;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                }
                else  if (indexPath.row==4)
                {
                    cell.lblTitle.text=@"State";
                    cell.lblValue.text=App_Delegate.objAppPerson.strState;
                    cell.txtField.text=App_Delegate.objAppPerson.strState;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                    
                }
                else  if (indexPath.row==5)
                {
                    cell.lblTitle.text=@"Zipcode";
                    cell.lblValue.text=App_Delegate.objAppPerson.strZipcode;
                    cell.txtField.text=App_Delegate.objAppPerson.strZipcode;
                    cell.txtField.inputAccessoryView = numberToolbar;
                    
                    //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                }
                else if (indexPath.row==6)
                {
                    cell.lblTitle.text=@"Email";
                    cell.lblValue.text=App_Delegate.objAppPerson.strEmailId;
                    cell.txtField.text=App_Delegate.objAppPerson.strEmailId;
                    //cell.txtField.keyboardType=UIKeyboardTypeEmailAddress;
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else if (indexPath.section==Caregiver)
        {
            if (arrCareGivers.count>0)
            {
                NSString *CellIdentifier = @"CaregiverContentCell";
                
                CaregiverContentCell *cell = (CaregiverContentCell *) [tableView
                                                                       dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CaregiverContentCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                
                NSMutableDictionary *dict=[arrCareGivers objectAtIndex:indexPath.row];
                NSString *strCaregiver=@"";
                if ([dict objectForKey:@"caregivername"])
                {
                    strCaregiver=[dict objectForKey:@"caregivername"];
                }
                if (![[dict objectForKey:@"caregiverreletion"] isEqualToString:@""])
                {
                    strCaregiver = [NSString stringWithFormat:@"%@ (%@)",strCaregiver,[dict objectForKey:@"caregiverreletion"]];
                }
                cell.lblTitle.text=strCaregiver;
                if ([dict objectForKey:@"caregivercontact"])
                {
                    cell.lblValue.text=[dict objectForKey:@"caregivercontact"];
                }
                else
                {
                    cell.lblValue.text= @"";
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else if (indexPath.section==Alergies)
        {
            NSString *CellIdentifier = @"AddAllergyInputCell";
            
            AddAllergyInputCell *cell = (AddAllergyInputCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddAllergyInputCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            if (arrAlergies.count>0)
            {
                NSMutableDictionary *dict=[arrAlergies objectAtIndex:indexPath.row];
                if ([dict objectForKey:@"alergiename"])
                {
                    cell.lblAlergy.text=[dict objectForKey:@"alergiename"];
                }
                cell.btnNotes.superview.tag=indexPath.section;
                
                [cell.btnNotes addTarget:self action:@selector(clickOnShowNotes:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else if (indexPath.section==MedicalHistory)
        {
            NSString *CellIdentifier = @"ProfileHeaderCell";
            
            ProfileHeaderCell *cell = (ProfileHeaderCell *) [tableView
                                                             dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileHeaderCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            
            cell.btnActions.hidden=YES;
            cell.btnActions.userInteractionEnabled=NO;
            //cell.btnColleps.hidden=YES;
            cell.btnColleps.userInteractionEnabled=NO;
            [cell.btnColleps setImage:[UIImage imageNamed:@"icn_forward.png"] forState:UIControlStateNormal];
            cell.backgroundColor=[UIColor colorWithRed:134.0/255.0 green:53.0/255.0 blue:32.0/255.0 alpha:1.0];
            
            cell.lblHeaderTitle.text = @"Medical History";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.section == PInsurance )
        {
            InsuranceCompanyObject *objInsurance;
            if (arrInsurance.count >0)
            {
                 objInsurance=[arrInsurance objectAtIndex:0];
            }
            else
            {
                objInsurance= [[InsuranceCompanyObject alloc] initDefaults];
            }
           
            
            
            if (indexPath.row==IImage)
            {
                NSString *CellIdentifier = @"TakePicCell";
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
                 NSString *CellIdentifier = @"ProfileContentDisplayCell";
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
                    cell.lblTitle.text=@"Notes";
                    cell.lblValue.text=objInsurance.strOptions;
                    cell.txtField.text=objInsurance.strOptions;
                    
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                else if (indexPath.row==IName)
                {
                    cell.lblTitle.text=@"Company Name";
                    cell.lblValue.text=objInsurance.strCopanyName;
                    cell.txtField.text=objInsurance.strCopanyName;
                    
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                else if (indexPath.row==IPhoneNumber)
                {
                    cell.lblTitle.text=@"Phone Number";
                    cell.lblValue.text=objInsurance.strPhoneNumber;
                    cell.txtField.text=objInsurance.strPhoneNumber;
                    
                    cell.txtField.inputAccessoryView = numberToolbar;
                    
                    //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                }
                else  if (indexPath.row==IEmployer)
                {
                    cell.lblTitle.text=@"Employer";
                    cell.lblValue.text=objInsurance.strEmployer;
                    cell.txtField.text=objInsurance.strEmployer;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                
                else  if (indexPath.row==IGroup)
                {
                    cell.lblTitle.text=@"Group #";
                    cell.lblValue.text=objInsurance.strGroup;
                    cell.txtField.text=objInsurance.strGroup;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                
                else if (indexPath.row==IPrescription)
                {
                    cell.lblTitle.text=@"Prescription #";
                    cell.lblValue.text=objInsurance.strPrescription;
                    cell.txtField.text=objInsurance.strPrescription;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                
                else if (indexPath.row==IAddress)
                {
                    cell.lblTitle.text=@"Address";
                    cell.lblValue.text=objInsurance.strAddress;
                    cell.txtField.text=objInsurance.strAddress;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                else if (indexPath.row==ICity)
                {
                    cell.lblTitle.text=@"City";
                    cell.lblValue.text=objInsurance.strCity;
                    cell.txtField.text=objInsurance.strCity;
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                else if (indexPath.row==IState)
                {
                    cell.lblTitle.text=@"State";
                    cell.lblValue.text=objInsurance.strState;
                    cell.txtField.text=objInsurance.strState;
                    
                    
                    cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                }
                
                else if (indexPath.row==IZipcode)
                {
                    cell.lblTitle.text=@"Zip Code";
                    cell.lblValue.text=objInsurance.strZipCode;
                    cell.txtField.text=objInsurance.strZipCode;
                    
                    cell.txtField.inputAccessoryView = numberToolbar;
                    
                    //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            

        }
        else if (indexPath.section == SInsurance)
        {
            InsuranceCompanyObject *objInsurance;

             
             if (arrInsurance.count >1)
             {
                 objInsurance=[arrInsurance objectAtIndex:1];
             }
            else
            {
                objInsurance= [[InsuranceCompanyObject alloc] initDefaults];
            }
             
            
             if (indexPath.row==IImage)
             {
                 NSString *CellIdentifier = @"TakePicCell";
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
                 NSString *CellIdentifier = @"ProfileContentDisplayCell";
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
                     cell.lblTitle.text=@"Notes";
                     cell.lblValue.text=objInsurance.strOptions;
                     cell.txtField.text=objInsurance.strOptions;
                     
                     cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                 }
                 else if (indexPath.row==IName)
                 {
                     cell.lblTitle.text=@"Company Name";
                     cell.lblValue.text=objInsurance.strCopanyName;
                     cell.txtField.text=objInsurance.strCopanyName;
                     
                     cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                 }
                 else if (indexPath.row==IPhoneNumber)
                 {
                     cell.lblTitle.text=@"Phone Number";
                     cell.lblValue.text=objInsurance.strPhoneNumber;
                     cell.txtField.text=objInsurance.strPhoneNumber;
                     
                     cell.txtField.inputAccessoryView = numberToolbar;
                     
                     //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                 }
                 else  if (indexPath.row==IEmployer)
                 {
                     cell.lblTitle.text=@"Employer";
                     cell.lblValue.text=objInsurance.strEmployer;
                     cell.txtField.text=objInsurance.strEmployer;
                     
                     cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                 }
                 
                 else  if (indexPath.row==IGroup)
                 {
                     cell.lblTitle.text=@"Group #";
                     cell.lblValue.text=objInsurance.strGroup;
                     cell.txtField.text=objInsurance.strGroup;
                     
                     cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                 }
                 
                 else if (indexPath.row==IPrescription)
                 {
                     cell.lblTitle.text=@"Prescription #";
                     cell.lblValue.text=objInsurance.strPrescription;
                     cell.txtField.text=objInsurance.strPrescription;
                     
                     cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                 }
                 
                 else if (indexPath.row==IAddress)
                 {
                     cell.lblTitle.text=@"Address";
                     cell.lblValue.text=objInsurance.strAddress;
                     cell.txtField.text=objInsurance.strAddress;
                     
                     cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                 }
                 else if (indexPath.row==ICity)
                 {
                     cell.lblTitle.text=@"City";
                     cell.lblValue.text=objInsurance.strCity;
                     cell.txtField.text=objInsurance.strCity;
                     
                     cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                 }
                 else if (indexPath.row==IState)
                 {
                     cell.lblTitle.text=@"State";
                     cell.lblValue.text=objInsurance.strState;
                     cell.txtField.text=objInsurance.strState;
                     
                     cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

                 }
                 
                 else if (indexPath.row==IZipcode)
                 {
                     cell.lblTitle.text=@"Zip Code";
                     cell.lblValue.text=objInsurance.strZipCode;
                     cell.txtField.text=objInsurance.strZipCode;
                     
                     cell.txtField.inputAccessoryView = numberToolbar;
                     
                     //cell.txtField.keyboardType=UIKeyboardTypeNumberPad;
                 }
                 cell.selectionStyle=UITableViewCellSelectionStyleNone;
                 return cell;
             }

         }
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section== MedicalHistory)
    {
        UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MedicalHistoryScreenVC *objview=[objStoryboard instantiateViewControllerWithIdentifier:@"MedicalHistoryScreenVC"];
        [self.navigationController pushViewController:objview animated:YES];
    }
    else if (indexPath.section==Caregiver)
    {
        
        [self resetCaregiverNAlergyView:0];
        NSMutableDictionary *dictValue=[arrCareGivers objectAtIndex:indexPath.row];
        if ([dictValue objectForKey:@"caregivername"])
        {
            txtCaregiverOrAlergyName.text=[dictValue objectForKey:@"caregivername"];
        }
        if ([dictValue objectForKey:@"caregiverreletion"])
        {
            txtRelation.text =[dictValue objectForKey:@"caregiverreletion"];
        }
        if ([dictValue objectForKey:@"caregivercontact"])
        {
            txtContactNo.text=[dictValue objectForKey:@"caregivercontact"];
        }
        if ([dictValue objectForKey:@"caregiveremail"])
        {
            txtEmail.text=[dictValue objectForKey:@"caregiveremail"];
        }
        isEditingStateForCaregiverNAlergy=YES;
        edtingIndexForCaregiverNAlergy=[dictValue valueForKey:@"rowid"];
        lblCaregiverNAlergyTitle.text=@"Update Caregiver";
        [btnSave setTitle:@"Update" forState:UIControlStateNormal];
        btnDelete.hidden=NO;
        btnDelete.userInteractionEnabled=YES;
        [self clickOnAddCaregivers:nil];
    }
    else if (indexPath.section==Alergies)
    {
        [self resetCaregiverNAlergyView:1];
        NSMutableDictionary *dictValue=[arrAlergies objectAtIndex:indexPath.row];
        if ([dictValue objectForKey:@"alergiename"])
        {
            txtCaregiverOrAlergyName.text=[dictValue objectForKey:@"alergiename"];
        }
        if ([dictValue objectForKey:@"alergiesubtance"])
        {
            tvAlergyNotes.text=[dictValue objectForKey:@"alergiesubtance"];
            tvAlergyNotes.textColor = [UIColor blackColor];
        }
        isEditingStateForCaregiverNAlergy=YES;
        lblCaregiverNAlergyTitle.text=@"Update Allergies";
        
        edtingIndexForCaregiverNAlergy=[dictValue valueForKey:@"rowid"];
        [btnSave setTitle:@"Update" forState:UIControlStateNormal];
        btnDelete.hidden=NO;
        btnDelete.userInteractionEnabled=YES;

        [self clickOnAddAlergies:nil];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (tableView.tag == OtherListTableTag)
    {
        return  YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==OtherListTableTag)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            if (viewOtherValue.tag == 5)
            {
                [arrOtherList removeObjectAtIndex:indexPath.row];
                [[NSUserDefaults standardUserDefaults]setObject:arrOtherList forKey:@"MaritalState"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (arrOtherList.count>0)
                {
                    tblOtherList.hidden=NO;
                   

                    [tblOtherList reloadData];
                }
                else
                {
                    tblOtherList.hidden=YES;
                }
            }
            else
            {
                [arrOtherList removeObjectAtIndex:indexPath.row];
                [[NSUserDefaults standardUserDefaults]setObject:arrOtherList forKey:@"MaritalState"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                if (arrOtherList.count>0)
                {
                    tblOtherList.hidden=NO;
                    [tblOtherList reloadData];
                }
                else
                {
                    tblOtherList.hidden=YES;
                }
            }
        }
    }
}

#pragma mark - Function Methods


- (IBAction)updateUserGender:(UIButton*)sender
{
    
    SomeEdit=1;
    
    if (sender.tag==111)
    {
        App_Delegate.objAppPerson.strGender=@"Male";
    }
    else if (sender.tag==222)
    {
        App_Delegate.objAppPerson.strGender=@"Female";
    }
    else if (sender.tag==333)
    {
        App_Delegate.objAppPerson.strGender=@"Don't Disclose";
    }
    [tblView reloadData];
}

- (IBAction)btnEditUserName:(id)sender
{
    if ([dictEditAction valueForKey:@"userEdit"])
    {
        App_Delegate.objAppPerson.strName=txtName.text;
        lblPageTitle.text=App_Delegate.objAppPerson.strName;
        [App_Delegate.dbObjUserInfo updateUserName];
        txtName.userInteractionEnabled=NO;
        [dictEditAction setValue:nil forKey:@"userEdit"];
        [btnEditUserName setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
        
        
        [App_Delegate CheckBeforeUploadUserDB];
        
        SomeEdit++;
    }
    else
    {
        txtName.userInteractionEnabled=YES;
        [txtName becomeFirstResponder];
        [dictEditAction setValue:@"YES" forKey:@"userEdit"];
        [btnEditUserName setImage:[UIImage imageNamed:@"icn_save.png"] forState:UIControlStateNormal];
        
        SomeEdit--;
    }
}

-(IBAction)clickOnBack:(id)sender
{
    if (SomeEdit==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *ai=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Do you want to go back without saving your changes?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [ai show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CaregiverOrAlerggySaveChangesAlertTag)
    {
        if (buttonIndex==1)
        {
            [self closeAddEditCaregiverOrAllergy];
        }
    }
    else
    {
        if (buttonIndex==1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)clickOnCollepsAction:(id)sender
{
    [txtTemp resignFirstResponder];
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
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
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
    UIButton *btnSender=(UIButton *)sender;
    NSString *strSection=[NSString stringWithFormat:@"Section%ld",btnSender.tag];
    
    if ([dictEditAction valueForKey:strSection])
    {
        if (btnSender.tag==Caregiver)
        {
            [self resetCaregiverNAlergyView:0];
            [self clickOnAddCaregivers:nil];
        }
        else if (btnSender.tag==Alergies)
        {
            [self resetCaregiverNAlergyView:1];
            [self clickOnAddAlergies:nil];
        }
    }
    else
    {
        if (btnSender.tag==ContactInfo)
        {
            NSLog(@"%@",dicUserInfo);
        }
        
        if (!(btnSender.tag== Caregiver || btnSender.tag == Alergies))
        {
            SomeEdit++;
        }
        
        [dictEditAction setValue:@"YES" forKey:strSection];
    }
    
    [UIView transitionWithView:tblView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [tblView reloadData];
                    } completion:NULL];
}

-(void)clickOnAddCaregivers:(id)sender
{
    
    [self.view bringSubviewToFront:viewForCaregiverNAlergy];
    [UIView transitionWithView:viewForCaregiverNAlergy
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        
                        viewForCaregiverNAlergy.hidden=NO;
                       
                        
                    } completion:NULL];
    
}

-(void)clickOnAddAlergies:(id)sender
{
   
    [self.view bringSubviewToFront:viewForCaregiverNAlergy];
    [UIView transitionWithView:viewForCaregiverNAlergy
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                    
                        viewForCaregiverNAlergy.hidden=NO;
                        
                    } completion:NULL];
    
}

-(void)resetCaregiverNAlergyView:(int)tag
{
    [txtTemp resignFirstResponder];
    txtCaregiverOrAlergyName.text=@"";
    txtRelation.text=@"";
    txtContactNo.text=@"";
    txtRelation.text=@"";
    txtEmail.text = @"";
    tvAlergyNotes.text=@"Add Reaction";
    tvAlergyNotes.textColor = [UIColor lightGrayColor];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    btnDelete.hidden=YES;
    btnDelete.userInteractionEnabled=NO;

    if (tag==0)
    {
        lblCaregiverNAlergyTitle.text=@"Add Caregiver";
        
        txtCaregiverOrAlergyName.placeholder=@"Enter Caregiver's Name *";
        txtRelation.placeholder=@"Enter Relation";
        txtContactNo.placeholder=@"Contact Phone Number";
        
        //txtContactNo.keyboardType = UIKeyboardTypeNumberPad;
        
        txtEmail.placeholder = @"Email Address";
        
        viewTagForAlergyNCaregiver=0;
        tvAlergyNotes.hidden=YES;
        imgNotestBack.hidden=YES;
        
        txtContactNo.hidden=NO;
        txtRelation.hidden=NO;
        txtEmail.hidden = NO;
    }
    else
    {
        lblCaregiverNAlergyTitle.text=@"Add Allergy";
        txtCaregiverOrAlergyName.placeholder=@"Enter Allergy Name";
        viewTagForAlergyNCaregiver=1;
        txtContactNo.hidden=YES;
        txtRelation.hidden=YES;
        txtEmail.hidden = YES;
        
        tvAlergyNotes.hidden=NO;
        imgNotestBack.hidden=NO;
    }
}


-(void)savePInsurance
{

     //SomeEdit --;
        
    InsuranceCompanyObject *objInsurance=[arrInsurance objectAtIndex:0];
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
    
    [App_Delegate.dbObj updateInsuranceDetail:objInsurance];
        
        
        //[App_Delegate startUploadUserInfoData];

        
    
}
-(void)saveSInsurance
{
//    NSString *strSection=[NSString stringWithFormat:@"Section%d",SInsurance];
//    if ([dictEditAction valueForKey:strSection])
//    {   SomeEdit --;
    
        InsuranceCompanyObject *objInsurance=[arrInsurance objectAtIndex:1];
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
            
            //[dictEditAction setValue:nil forKey:strSection];
            [App_Delegate.dbObj updateInsuranceDetail:objInsurance];
        
            //[App_Delegate startUploadUserInfoData];

      
   // }

}



-(IBAction)clickOnSaveCaregiversAlergy:(id)sender
{
    [self doneWithNumberPad];
   // SomeEdit--;
    if (viewTagForAlergyNCaregiver==0)
    {
        [txtTemp resignFirstResponder];
        if (txtCaregiverOrAlergyName.text.length>0)
        {
            
            SomeEditCaregiverOrAlergy = 0;
            
            NSMutableDictionary *dictCare=[[NSMutableDictionary alloc]init];
            [dictCare setValue:txtCaregiverOrAlergyName.text forKey:@"caregivername"];
            [dictCare setValue:txtRelation.text forKey:@"caregiverreletion"];
            [dictCare setValue:txtContactNo.text forKey:@"caregivercontact"];
            [dictCare setValue:txtEmail.text forKey:@"caregiveremail"];
            
            if (isEditingStateForCaregiverNAlergy==YES)
            {
                [dictCare setValue:edtingIndexForCaregiverNAlergy forKey:@"rowid"];
                [App_Delegate.dbObjUserInfo updateCaregivers:dictCare];
            }
            else
            {
               [App_Delegate.dbObjUserInfo insertCaregivers:dictCare];
            }
            
            
            arrCareGivers=[App_Delegate.dbObjUserInfo getAllCaregiver];
            [self clickOnCancelCaregiverOrAlergyName:nil];
            [tblView reloadData];
            
            
            [App_Delegate CheckBeforeUploadUserDB];

            
        }
        else
        {
            UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please fill the require(*) information before click on save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [alt show];
            
        }
    }
    else
    {
        [tvAlergyNotes resignFirstResponder];
        if (txtCaregiverOrAlergyName.text.length>0 && tvAlergyNotes.text.length>0)
        {
            SomeEditCaregiverOrAlergy = 0;
            
            NSMutableDictionary *dictCare=[[NSMutableDictionary alloc]init];
            [dictCare setValue:txtCaregiverOrAlergyName.text forKey:@"alergiename"];
            [dictCare setValue:tvAlergyNotes.text forKey:@"alergiesubtance"];
            if (isEditingStateForCaregiverNAlergy==YES)
            {
                [dictCare setValue:edtingIndexForCaregiverNAlergy forKey:@"rowid"];
                [App_Delegate.dbObjUserInfo updateAlergies:dictCare];
            }
            else
            {
                [App_Delegate.dbObjUserInfo insertAlergies:dictCare];
            }
            arrAlergies=[App_Delegate.dbObjUserInfo getAllAlergy];
            [self clickOnCancelCaregiverOrAlergyName:nil];
            [tblView reloadData];
            
            [App_Delegate CheckBeforeUploadUserDB];

        }
        else
        {
            UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the information before click on save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [alt show];
            
        }
    }
    
    [self.view endEditing:YES];
}

-(IBAction)clickOnCancelCaregiverOrAlergyName:(id)sender
{
     [self doneWithNumberPad];
    
    if (SomeEditCaregiverOrAlergy)
    {
        UIAlertView *ai=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Do you want to go back without saving your changes?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        ai.tag = CaregiverOrAlerggySaveChangesAlertTag;
        [ai show];
    }
    else
    {
        [self closeAddEditCaregiverOrAllergy];
    }
    
}

-(void)closeAddEditCaregiverOrAllergy
{
    
    SomeEditCaregiverOrAlergy = 0;
    
    isEditingStateForCaregiverNAlergy=NO;
    
    [UIView transitionWithView:viewForCaregiverNAlergy
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        
                        viewForCaregiverNAlergy.hidden=YES;
                        
                        
                    } completion:NULL];
    [self.view sendSubviewToBack:viewForCaregiverNAlergy];
}

-(IBAction)clickOnDeleteCaregiverNAlergy:(id)sender
{
    if (viewTagForAlergyNCaregiver==0)
    {
        [App_Delegate.dbObjUserInfo deleteCaregiverForId:[edtingIndexForCaregiverNAlergy intValue]];
        arrCareGivers=[App_Delegate.dbObjUserInfo getAllCaregiver];
        [tblView reloadData];
    }
    else
    {
        [App_Delegate.dbObjUserInfo deleteAlergyForRowid:[edtingIndexForCaregiverNAlergy intValue]];
        arrAlergies=[App_Delegate.dbObjUserInfo getAllAlergy];
        [tblView reloadData];
    }
    
    [App_Delegate CheckBeforeUploadUserDB];

    [self clickOnCancelCaregiverOrAlergyName:nil];
}


-(void)doneWithNumberPad
{
    [self.view endEditing:YES];
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    [self.view endEditing:YES];
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

//Code to create View of add Other list Items
-(void)createViewOtherFromList
{
    if (!viewOtherValue)
    {
        viewOtherValue=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [viewOtherValue setBackgroundColor:[UIColor lightTextColor]];
    }
    UIView *viewBack = [[UIView alloc] init];
    viewBack.frame = viewOtherValue.frame;
    [viewBack setBackgroundColor:[UIColor darkTextColor]];
    viewBack.alpha = 0.8;
    [viewOtherValue addSubview:viewBack];
    [viewOtherValue sendSubviewToBack:viewBack];
    
    UIView *subResultView=[[UIView alloc]initWithFrame:CGRectMake(5, 0, 310, self.view.frame.size.height-100)];
    subResultView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [subResultView setBackgroundColor:[UIColor whiteColor]];
    subResultView.layer.cornerRadius=5.0;
    subResultView.layer.masksToBounds=YES;
    [viewOtherValue addSubview:subResultView];
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 50, 280, 29)];
    [lblTitle setText:@"Add"];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor redColor]];
    [lblTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0]];
    
    [subResultView addSubview:lblTitle];
        
    txtOtherValue=[[UITextField alloc]initWithFrame:CGRectMake(15, 105, 280, 35)];
    [txtOtherValue setBorderStyle:UITextBorderStyleLine];
    txtOtherValue.delegate=self;
    txtOtherValue.tag=105;
    txtOtherValue.placeholder=@"Enter Value";
    
    //already commented before phase 2
  // txtOtherValue.keyboardType = UIKeyboardTypeNumberPad;
    txtOtherValue.inputAccessoryView = numberToolbar;
    
    [subResultView addSubview:txtOtherValue];
    
    UIButton *btnOtherValue=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnOtherValue setFrame:CGRectMake(15, 215, 280, 35)];
    [btnOtherValue setTitle:@"Save" forState:UIControlStateNormal];
    [btnOtherValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOtherValue setBackgroundImage:[UIImage imageNamed:@"btn_add_diagnosis.png"] forState:UIControlStateNormal];
    [btnOtherValue addTarget:self action:@selector(clickOnDoneForOtherFromList:) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnOtherValue];
    
    UIButton *btnclose=[[UIButton alloc]initWithFrame:CGRectMake(275,0, 35, 35)];
    [btnclose setTitle:@"X" forState:UIControlStateNormal];
    [btnclose.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [btnclose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnclose setBackgroundColor:[UIColor redColor]];
    [btnclose addTarget:self action:@selector(clickOnRemoveView) forControlEvents:UIControlEventTouchUpInside];
    [subResultView addSubview:btnclose];
    
    tblOtherList = [[UITableView alloc] initWithFrame:CGRectMake(0,265, 310, subResultView.frame.size.height-275) style:UITableViewStylePlain];
    tblOtherList.delegate=self;
    tblOtherList.dataSource=self;
    tblOtherList.tag=OtherListTableTag;
    tblOtherList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [subResultView addSubview:tblOtherList];

    
    [self.view addSubview:viewOtherValue];
    viewOtherValue.hidden=YES;
    
}

//Code To Open Add Other List View
-(IBAction)clickOnOtherFromList:(int)valueIndex
{
    txtOtherValue.text=@"";
    
    if (valueIndex == 3)
    {
        //txtOtherValue.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (valueIndex==4)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MaritalState"])
        {
            arrOtherList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaritalState"] mutableCopy];
        }
        else
        {
            arrOtherList = [[NSMutableArray alloc] init];
        }
        //txtOtherValue.keyboardType = UIKeyboardTypeNamePhonePad;
        
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LivingState"])
        {
            arrOtherList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LivingState"] mutableCopy];
        }
        else
        {
            arrOtherList = [[NSMutableArray alloc] init];
        }

       // txtOtherValue.keyboardType = UIKeyboardTypeNamePhonePad;
        
    }
    if (arrOtherList.count>0)
    {
        tblOtherList.hidden = NO;
        [tblOtherList reloadData];
    }
    else
    {
        tblOtherList.hidden = YES;
        
    }
        
    viewOtherValue.tag = valueIndex;
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                         viewOtherValue.hidden = NO;
                    } completion:NULL];
   
    
}

//Code To Close Add Other List View

-(void)clickOnRemoveView
{
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        viewOtherValue.hidden=YES;
                    } completion:NULL];
    
    
}

//Handle Done Action of Other List View
-(IBAction)clickOnDoneForOtherFromList:(id)sender
{
    if (txtOtherValue.text.length>0)
    {
        if (viewOtherValue.tag==3)
        {
            App_Delegate.objAppPerson.strWeight=[NSString stringWithFormat:@"%@ lbs",txtOtherValue.text];
            [tblView reloadData];
            [self clickOnRemoveView];
        }
        else if (viewOtherValue.tag==4)
        {
            NSMutableArray *arrMaritalState;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MaritalState"])
            {
                arrMaritalState = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaritalState"] mutableCopy];
                [arrMaritalState addObject:txtOtherValue.text];
            }
            else
            {
                arrMaritalState = [[NSMutableArray alloc] init];
                [arrMaritalState addObject:txtOtherValue.text];
            }
            [[NSUserDefaults standardUserDefaults]setObject:arrMaritalState forKey:@"MaritalState"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //[self clickOnRemoveView];
            txtOtherValue.text=@"";
            viewOtherValue.hidden=YES;
            App_Delegate.isNewAddedInList =YES;
            [self clickOnValuePicker:viewOtherValue.tag withSection:About];

        }
        else if (viewOtherValue.tag==5)
        {
            NSMutableArray *arrLivingState;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LivingState"])
            {
                arrLivingState = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LivingState"] mutableCopy];
                [arrLivingState addObject:txtOtherValue.text];
            }
            else
            {
                arrLivingState = [[NSMutableArray alloc] init];
                [arrLivingState addObject:txtOtherValue.text];
            }
            [[NSUserDefaults standardUserDefaults]setObject:arrLivingState forKey:@"LivingState"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            //[self clickOnRemoveView];
            txtOtherValue.text=@"";
            viewOtherValue.hidden=YES;
            App_Delegate.isNewAddedInList =YES;
            [self clickOnValuePicker:viewOtherValue.tag withSection:About];
            
        }
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter value before submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alt show];
    }
    
}

#pragma mark Action Sheet Methods

-(IBAction)clickOnSelectCountryCode:(UIButton *)sender
{
    [txtTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
    if (!IsActionSheetVisible)
    {
        IsActionSheetVisible=YES;
        
        [txtTemp resignFirstResponder];
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
        objPicker.rowId = sender.tag;
        objPicker.sectionId = sender.superview.tag;
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


-(void)clickOnValuePicker:(NSInteger)rowTag withSection:(NSInteger)sectionTag
{
    
    SomeEdit = 1;
    
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
    objPicker.EntryTag=0;
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
    if (section==About)
    {
        if (row==2)
        {
            App_Delegate.objAppPerson.strHeight=strValue;
        }
        else if (row==3)
        {
            if ([strValue isEqualToString:@"+"])
            {
                [self clickOnOtherFromList:row];
            }
            else
            {
                App_Delegate.objAppPerson.strWeight=[NSString stringWithFormat:@"%@ lbs",strValue];
            }
            
        }
        else if (row==4)
        {
            if ([strValue isEqualToString:@"Other"])
            {
                [self clickOnOtherFromList:row];
            }
            else
            {
                App_Delegate.objAppPerson.strMaritalStatus=strValue;
            }
        }
        else if (row==5)
        {
            if ([strValue isEqualToString:@"Other"])
            {
                [self clickOnOtherFromList:row];
            }
            else
            {
                App_Delegate.objAppPerson.strLivingWith=strValue;
            }
            
        }
    }
    else if (section==ContactInfo)
    {
        NSMutableDictionary *dictValue = [App_Delegate.arrCountryPhoneCode objectAtIndex:intIndex];
        NSString *strCode = [NSString stringWithFormat:@"%@",[dictValue valueForKey:@"CountryCode"]];
        if (row == 7)
        {
            App_Delegate.objAppPerson.strCountryCodeHome = strCode;
        }
        else if (row == 8)
        {
            App_Delegate.objAppPerson.strCountryCodeWork = strCode;
        }
        else if (row == 9)
        {
            App_Delegate.objAppPerson.strCountryCodeCell = strCode;
        }
    }
    [tblView reloadData];
}


-(void)clickOnOpenDatePicker
{
    SomeEdit = 1;
    
    [txtTemp resignFirstResponder];
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
    App_Delegate.objAppPerson.strDOB=[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]];
    [tblView reloadData];
}

-(void)didCancelPicker
{
   
    IsActionSheetVisible=NO;
}
-(void)clickOnShowNotes:(UIButton *)sender
{
    NSMutableDictionary *dicValue=[arrAlergies objectAtIndex:sender.tag];
    NSString *strNotes=[dicValue valueForKey:@"alergiesubtance"];
    
    
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    
    if (!tvShowNotes)
    {
        tvShowNotes=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300,250)];
        //  tvShowNotes.center=alertView.center;
        tvShowNotes.inputAccessoryView=nil;
        tvShowNotes.backgroundColor=[UIColor clearColor];
        [tvShowNotes setFont:[UIFont fontWithName:@"Helvetica Neue" size:18.0f]];
    }
    tvShowNotes.text=strNotes;
    [alertView setContainerView:tvShowNotes];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", nil]];
    [alertView setDelegate:nil];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
    
}

-(IBAction)addPhoto:(UIButton *)sender
{
       btnImageTag=sender;
    
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
    
    SomeEdit =1;

    
    UIImage *selectedImage= info[UIImagePickerControllerEditedImage];
    
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
        });
    }
    
    
    if (btnImageTag.tag == PInsurance)
    {
        InsuranceCompanyObject *object=[arrInsurance objectAtIndex:0];
        
        UIImage *selectedImage= info[UIImagePickerControllerEditedImage];
        object.imgCompany=selectedImage;
        [arrInsurance replaceObjectAtIndex:0 withObject:object];
        [picker dismissViewControllerAnimated:NO completion:NULL];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [tblView reloadData];
    }
    else if (btnImageTag.tag == SInsurance)
    {
        InsuranceCompanyObject *object=[arrInsurance objectAtIndex:1];
        
        UIImage *selectedImage= info[UIImagePickerControllerEditedImage];
        object.imgCompany=selectedImage;
        [arrInsurance replaceObjectAtIndex:1 withObject:object];
        [picker dismissViewControllerAnimated:NO completion:NULL];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [tblView reloadData];
    }
    else
    {
        [imgUser setImage:selectedImage];
        [self saveImage:@"UserImage.png"];
        [[NSUserDefaults standardUserDefaults] setValue:@"UserImage.png" forKey:@"userImage" ];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [picker dismissViewControllerAnimated:NO completion:NULL];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

-(NSString *)saveImage:(NSString *)strFileName
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    }

    
    filePath = [filePath stringByAppendingPathComponent:strFileName];
    NSData *imageData = UIImagePNGRepresentation(imgUser.image);
    [imageData writeToFile:filePath atomically:YES];
    return filePath;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.superview.tag==About)
    {
        if ( textField.tag==2 || textField.tag==3 || textField.tag==4 || textField.tag==5)
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
    if (textField == txtCaregiverOrAlergyName || textField == txtRelation || textField == txtContactNo || textField == txtName || textField == txtEmail)
    {
        return YES;
    }

    if (textField.tag != 101 && textField.tag !=105)
    {
        [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:textField.superview.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    
     return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == txtName)
    {
        SomeEdit =1;
    }
    
    if (textField == txtCaregiverOrAlergyName || textField == txtRelation || textField == txtContactNo )
    {
        SomeEditCaregiverOrAlergy = 1;
    }
    
    if (textField.superview.tag==ContactInfo || textField == txtContactNo)
    {
        if (textField.tag == 7 || textField.tag == 8 || textField.tag == 9 || textField == txtContactNo)
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
            } else
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
           // RMPhoneFormat *fmt = [[RMPhoneFormat alloc] initWithDefaultCountry:@"uk"];
            
        }
        
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == tvAlergyNotes)
    {
        SomeEditCaregiverOrAlergy = 1;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    if (textField.superview.tag==ContactInfo)
    {
        SomeEdit = 1;

        if (textField.tag==0)
        {
            App_Delegate.objAppPerson.strAddress1=textField.text;
        }
        else if (textField.tag==1)
        {
            App_Delegate.objAppPerson.strAddress2=textField.text;
        }
        else if (textField.tag==2)
        {
            App_Delegate.objAppPerson.strAddress3=textField.text;
        }
        else if (textField.tag==3)
        {
            App_Delegate.objAppPerson.strCity=textField.text;
        }
        else if (textField.tag==4)
        {
            App_Delegate.objAppPerson.strState=textField.text;
        }
        else if (textField.tag==5)
        {
            App_Delegate.objAppPerson.strZipcode=textField.text;
        }
        else if (textField.tag==6)
        {
            App_Delegate.objAppPerson.strEmailId=textField.text;
        }
        else if (textField.tag==7)
        {
            App_Delegate.objAppPerson.strContactNoHome=textField.text;
        }
        else if (textField.tag==8)
        {
            App_Delegate.objAppPerson.strContactNoWork=textField.text;
        }
        else if (textField.tag==9)
        {
            App_Delegate.objAppPerson.strContactNoCell=textField.text;
        }
    }
    else if (textField.superview.tag==Caregiver)
    {
        
    
    }
    else if (textField.superview.tag==Alergies)
    {
        
    }
    else if (textField.superview.tag == PInsurance || textField.superview.tag == SInsurance)
    {
        SomeEdit = 1;

        InsuranceCompanyObject *object;
        
        if (textField.superview.tag == PInsurance)
        {
            object  =[arrInsurance objectAtIndex:0];
        }
        else
        {
             object  =[arrInsurance objectAtIndex:1];
        }
        
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
        
        if (textField.superview.tag == PInsurance)
        {
             [arrInsurance replaceObjectAtIndex:0 withObject:object];
        }
        else
        {
           [arrInsurance replaceObjectAtIndex:1 withObject:object];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtTemp=textField;
    
    if (textField.tag == txtCaregiverOrAlergyNameTag || textField.tag == txtRelationTag  )
    {
        IsUp=YES;
        [UIView animateWithDuration:0.40f animations:
         ^{
              [self.view setFrame:CGRectMake(self.view.frame.origin.x,-150,self.view.frame.size.width,self.view.frame.size.height)];         }
                         completion:^(BOOL finished)
         {}];
    }
    else if ( textField.tag == txtEmailTag || textField.tag == txtContactNoTag )
    {
        IsUp=YES;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self.view setFrame:CGRectMake(self.view.frame.origin.x,-180,self.view.frame.size.width,self.view.frame.size.height)];
         }
                         completion:^(BOOL finished)
         {}];
    }
    else if (textField.tag==5 ||textField.tag==6 || textField.tag==7  || textField.tag == 101 || textField.tag==1 ||textField.tag==2||textField.tag==3 ||textField.tag==4 ||textField.tag==0 )
    {
        IsUp=YES;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewUp];
          }
                         completion:^(BOOL finished)
         {}];

    }
    else if (textField.tag == 10 || textField.tag==8 || textField.tag==9)
    {
        
        
        IsUp=YES;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewUp];
         }
                         completion:^(BOOL finished)
         {}];
        
        /*
        IsUp=YES;
        
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self.view setFrame:CGRectMake(self.view.frame.origin.x,-265,self.view.frame.size.width,self.view.frame.size.height)];
         }
                         completion:^(BOOL finished)
         {}];
         */
    }
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.tag==5 || textField.tag==6 || textField.tag==7 || textField.tag==8 || textField.tag==9 || IsUp)
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
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,-216,self.view.frame.size.width,self.view.frame.size.height)];
}
-(void)MoveViewDown
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}

#pragma mark UITextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([tvAlergyNotes.text isEqualToString:@"Add Reaction"])
    {
        tvAlergyNotes.text = @"";
        tvAlergyNotes.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    tvTemp=textView;
    IsUp=YES;
    
   
    [UIView animateWithDuration:0.40f animations:
     ^{
          [self.view setFrame:CGRectMake(self.view.frame.origin.x,-150,self.view.frame.size.width,self.view.frame.size.height)];
     }
                     completion:^(BOOL finished)
     {}];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if(tvAlergyNotes.text.length == 0)
    {
        tvAlergyNotes.textColor = [UIColor lightGrayColor];
        tvAlergyNotes.text = @"Add Reaction";
        [tvAlergyNotes resignFirstResponder];
    }
}
-(void)textViewDidChangeSelection:(UITextView *)textView
{
    /*YOUR CODE HERE*/
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (tvAlergyNotes.text.length == 0)
    {
        tvAlergyNotes.text = @"Add Reaction";
        tvAlergyNotes.textColor = [UIColor grayColor];
    }
    
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

- (void) dealloc
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)autoFormatTextField:(id)sender
{
    
    //myTextFieldSemaphore = 1;
    UITextField *tf=sender;
    
   //tf.text = [myPhoneNumberFormatter format:tf.text withLocale:myLocale];
    
   // myTextFieldSemaphore = 0;
    
}



-(IBAction)BtnEditOrSaveAll:(UIButton *)sender
{
    UIButton *btn = (UIButton *) sender ;
    if (btn.tag==0)
    {
        [dictEditAction setValue:@"YES" forKey:[NSString stringWithFormat:@"Section%d",About]];
        [dictEditAction setValue:@"YES" forKey:[NSString stringWithFormat:@"Section%d",ContactInfo]];
        [dictEditAction setValue:@"YES" forKey:[NSString stringWithFormat:@"Section%d",PInsurance]];
        [dictEditAction setValue:@"YES" forKey:[NSString stringWithFormat:@"Section%d",SInsurance]];
        [dictEditAction setValue:@"YES" forKey:@"userEdit"];
        
        [btn setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"icn_save.png"] forState:UIControlStateNormal];
        
        txtName.userInteractionEnabled=YES;
        btnTakeUserPic.userInteractionEnabled=YES;

        btn.tag=1;
 
    }
    else if (btn.tag==1)
    {
        
        [dictEditAction setValue:nil forKey:[NSString stringWithFormat:@"Section%d",About]];
        [dictEditAction setValue:nil forKey:[NSString stringWithFormat:@"Section%d",ContactInfo]];
        [dictEditAction setValue:nil forKey:[NSString stringWithFormat:@"Section%d",PInsurance]];
        [dictEditAction setValue:nil forKey:[NSString stringWithFormat:@"Section%d",SInsurance]];
        
        [dictEditAction setValue:nil forKey:@"userEdit"];
        
        [btn setImage:[UIImage imageNamed:@"icn_edit_aboutlabel.png"] forState:UIControlStateNormal];
        
        
        btn.tag=0;
        
        if (SomeEdit!=0)
        {
            [self SaveInfo];
        }
        else
        {
            App_Delegate.objAppPerson.strName=txtName.text;
            lblPageTitle.text=App_Delegate.objAppPerson.strName;
            txtName.userInteractionEnabled=NO;
            
            btnTakeUserPic.userInteractionEnabled=NO;
        }

    }
    
    [UIView transitionWithView:tblView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [tblView reloadData];
                    } completion:NULL];
    

}


-(void)SaveInfo
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
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
   
    NSLog(@"%@",App_Delegate.dbObjUserInfo);
    NSLog(@"%@",App_Delegate.dbObj);

    App_Delegate.objAppPerson.strName=txtName.text;
    lblPageTitle.text=App_Delegate.objAppPerson.strName;
    txtName.userInteractionEnabled=NO;
    
    btnTakeUserPic.userInteractionEnabled=NO;
    
    [App_Delegate.dbObjUserInfo updateUserName];
    [App_Delegate.dbObjUserInfo updateUserAboutInfo];
    [App_Delegate.dbObj InsertuserInfo:dicUserInfo];
    [App_Delegate.dbObjUserInfo updateUserContactInfo];


    if(App_Delegate.objAppPerson.strDOB)
    {
        [dicUserInfo setObject:App_Delegate.objAppPerson.strDOB forKey:@"dob"];
    }
    else
    {
        [dicUserInfo setObject:@"" forKey:@"dob"];
    }
    
    if(App_Delegate.objAppPerson.strGender)
    {
        [dicUserInfo setObject:App_Delegate.objAppPerson.strGender forKey:@"gender"];
    }
    else
    {
        [dicUserInfo setObject:@"" forKey:@"gender"];
    }
    
    if(App_Delegate.objAppPerson.strZipcode)
    {
        [dicUserInfo setObject:App_Delegate.objAppPerson.strZipcode forKey:@"zipcode"];
    }
    else
    {
        [dicUserInfo setObject:@"" forKey:@"zipcode"];
    }
    
    [App_Delegate.dbObj InsertuserInfo:dicUserInfo];
            
    //[App_Delegate startUploadUserInfoData];
            
    
    
    if (App_Delegate.objAppPerson.strDOB)
    {
        [dicUserInfo setObject:App_Delegate.objAppPerson.strDOB forKey:@"dob"];
    }
    else
    {
        [dicUserInfo setObject:@"" forKey:@"dob"];
    }
            
    if (App_Delegate.objAppPerson.strGender)
    {
        [dicUserInfo setObject:App_Delegate.objAppPerson.strGender forKey:@"gender"];
    }
    else
    {
        [dicUserInfo setObject:@"" forKey:@"gender"];
    }
    
    
    if (App_Delegate.objAppPerson.strZipcode)
    {
        [dicUserInfo setObject:App_Delegate.objAppPerson.strZipcode forKey:@"zipcode"];
    }
    else
    {
        [dicUserInfo setObject:@"" forKey:@"zipcode"];
    }
    
    [self savePInsurance];
    [self saveSInsurance];
    
    SomeEdit = 0 ;
    
    [App_Delegate CheckBeforeUploadUserDB];

}

@end

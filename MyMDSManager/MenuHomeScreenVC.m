

//  MenuHomeScreenVC.m
//  MyMDSManager

//  Created by CEPL on 03/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "MenuHomeScreenVC.h"
#import "MenuHomeCell.h"
#import "SymptomTrackerVC.h"
#import "MedicalScreenVC.h"
#import "MFSideMenu.h"
#import "InsuranceDetailVC.h"
#import "TransfusionsVC.h"
#import "ClinicalTrialsVC.h"
#import "MediaProfessionalListVC.h"
#import "AppointmentListVC.h"
#import "NotesListVC.h"
#import "MDSTreatmentListVC.h"
#import "InicialLabResultVC.h"
#import "BoneMarroResultVC.h"
#import "BloodCountNTransfusionVC.h"
#import "MenuProfileScreenVC.h"
#import "BloodCountNTransfusionVC.h"
#import "Cell1.h"
#import "Cell2.h"
#import "SearchResultVC.h"
#import "UnirestAsyncApi.h"
#import "AdditionalResourcesVC.h"
#import "IPSSScoreListVC.h"
#import "ZipArchive.h"

#import "SettingsScreenVC.h"
#import "MenuScreen.h"

#import <GoogleSignIn/GoogleSignIn.h>



#define googleClientId @"803116412282-hah5o9em1lsnrjrprn6cjqj4hpglu4ho.apps.googleusercontent.com"
#define googleClientSecret @""

#define googleLoginAlert 663

@interface MenuHomeScreenVC () <GIDSignInDelegate, GIDSignInUIDelegate>

@end

@implementation MenuHomeScreenVC

-(void)viewDidLoad
{
    [super viewDidLoad]; 

    self.navigationController.navigationBarHidden=YES;
    arrContent=[[NSMutableArray alloc]initWithObjects:@"MDS Profile",@"Medical Professionals",@"Clinical Trials",@"Additional Resources", nil];
    arrImages=[[NSMutableArray alloc]initWithObjects:@"icn_treatment.png",@"icn_medi.png",@"icn_trials.png",@"icn_resources.png", nil ];
    
    arrSubMenu=[[NSArray alloc]initWithObjects:@"Initial Lab Results",@"Bone Marrow Results",@"Blood Counts",@"Treatments",@"Transfusions",@"IPSS-R Score", nil ];
    
    [self loadTestUnitsNNormals];
    [self updateDeviceToken];
    [self createViewFirstTimeGoogle];
    
    if (App_Delegate.showFirstTimeInfo == NO)
    {
       App_Delegate.showFirstTimeInfo = YES;
        if (![[NSUserDefaults standardUserDefaults]valueForKey:@"Never"])
        {
            if (![[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
            {
                [self clickOnFirstTimeGoogle];
            }
        }
    }
    NumOfDownloadNeeded = @"" ;

    lblTitle.text=@"MDS Manager\u2122";
    
}

-(void)firstTimeGoogleAccount
{
    UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"MDS Manager\u2122" message:@"Use your Google account to keep your data safe.  This will allow you to track additional information on more than one device and\or change to a new device in the future." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Login",@"Remind Me Later",@"Never Show This Again", nil];
    altView.tag = googleLoginAlert;
    [altView show];
    
}

-(void)createViewFirstTimeGoogle
{
    if (!viewFirstTimeGoogle)
    {
        viewFirstTimeGoogle=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [viewFirstTimeGoogle setBackgroundColor:[UIColor lightTextColor]];
    }
    UIView *viewBack = [[UIView alloc] init];
    viewBack.frame = viewFirstTimeGoogle.frame;
    [viewBack setBackgroundColor:[UIColor darkTextColor]];
    viewBack.alpha = 0.8;
    [viewFirstTimeGoogle addSubview:viewBack];
    [viewFirstTimeGoogle sendSubviewToBack:viewBack];
    
    UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    subView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [subView setBackgroundColor:[UIColor whiteColor]];
    subView.layer.cornerRadius=5.0;
    subView.layer.masksToBounds=YES;
    [viewFirstTimeGoogle addSubview:subView];
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 280, 100)];
    [lblTitle setText:@"Use your Google account to keep your data safe. This will allow you to track additional information on more than one device and/or change to a new device in the future."];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setNumberOfLines:5];
    [lblTitle setFont:[UIFont fontWithName:@"NexaRegular" size:14.0]];
    
    [subView addSubview:lblTitle];

    
    UIButton *btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setFrame:CGRectMake(0, 300-107, 300, 35)];
    [btnLogin setTitle:@"Sign In Or Sign Up" forState:UIControlStateNormal];
    [btnLogin.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btnLogin.tag = 0;
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0]];
    [btnLogin addTarget:self action:@selector(clickOnFirstTimeGoogleOptions:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:btnLogin];
    

    
    UIButton *bntRemindMeLater=[UIButton buttonWithType:UIButtonTypeCustom];
    [bntRemindMeLater setFrame:CGRectMake(0, 300-71, 300, 35)];
    [bntRemindMeLater setTitle:@"Remind Me Later" forState:UIControlStateNormal];
    [bntRemindMeLater.titleLabel setFont:[UIFont systemFontOfSize:14]];
    bntRemindMeLater.tag = 1;
    [bntRemindMeLater setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bntRemindMeLater setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0]];
    [bntRemindMeLater addTarget:self action:@selector(clickOnFirstTimeGoogleOptions:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:bntRemindMeLater];

  
    UIButton *btnNeverAsk=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnNeverAsk setFrame:CGRectMake(0, 300-35, 300, 35)];
    [btnNeverAsk setTitle:@"Never Show This Again (Not Recommended)" forState:UIControlStateNormal];
    [btnNeverAsk.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btnNeverAsk.tag = 2;
    [btnNeverAsk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNeverAsk setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0]];
    [btnNeverAsk addTarget:self action:@selector(clickOnFirstTimeGoogleOptions:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:btnNeverAsk];
    
    UIButton *btnclose=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnclose setFrame:CGRectMake((subView.frame.size.width+subView.frame.origin.x)-25,subView.frame.origin.y, 25, 25)];
    [btnclose setImage:[UIImage imageNamed:@"pop_close.png"] forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(clickOnRemoveViewFirstTimeGoogle) forControlEvents:UIControlEventTouchUpInside];
    [viewFirstTimeGoogle addSubview:btnclose];
    
    [self.view addSubview:viewFirstTimeGoogle];
    
    UITapGestureRecognizer *objTapGesutr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnRemoveViewFirstTimeGoogle)];
    [viewFirstTimeGoogle addGestureRecognizer:objTapGesutr];
    viewFirstTimeGoogle.hidden=YES;
    
}

//Code To Open Add Other List View
-(void)clickOnFirstTimeGoogle
{
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        viewFirstTimeGoogle.hidden = NO;
                    } completion:NULL];
    
    
}

//Code To Close Add Other List View

-(void)clickOnRemoveViewFirstTimeGoogle
{
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        viewFirstTimeGoogle.hidden=YES;
                    } completion:NULL];
    
    
}
-(void)freeGoogleAccountProcess
{
    [self clickOnRemoveViewFirstTimeGoogle];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://accounts.google.com/SignUp"]];
}
-(IBAction)clickOnFirstTimeGoogleOptions:(UIButton *)sender
{
    if(sender.tag==0)
    {
        [self signInToGoogle];
    }
    else if (sender.tag==1)
    {
        
    }
    else if (sender.tag==2)
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"Never"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [self clickOnRemoveViewFirstTimeGoogle];
}



-(void)loadTestUnitsNNormals
{
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    [UnirestAsyncApi callPostAsyncAPI:@"diagnosis_test.php" withParameter:Dic selector:@selector(callBackForAdminData:) toTarget:self showHUD:NO];
}

-(void)callBackForAdminData:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        App_Delegate.unitLoaded = YES;
        if ([DictR valueForKey:@"data"])
        {
            NSMutableArray *arrTests=[DictR valueForKey:@"data"];
            
            [[NSUserDefaults standardUserDefaults]setObject:arrTests forKey:@"DiagnosisData"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            for (int i = 0; i<arrTests.count; i++)
            {
                NSMutableDictionary *objDict=[arrTests objectAtIndex:i];
                if (!App_Delegate.dictTest)
                {
                    App_Delegate.dictTest=[[NSMutableDictionary alloc] init];
                }
                if (!App_Delegate.dictNormal)
                {
                    App_Delegate.dictNormal=[[NSMutableDictionary alloc] init];
                }
                [App_Delegate.dictTest setObject:[objDict valueForKey:@"unit"] forKey:[objDict valueForKey:@"diagnosis_test"]];
                [App_Delegate.dictNormal setObject:objDict forKey:[objDict valueForKey:@"diagnosis_test"]];
            }
        }
        
        if ([DictR valueForKey:@"symptom"])
        {
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"symptom"] forKey:@"symptom"] ;
            [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"symptom"] forKey:@"symptom"];
        }
        if ([DictR valueForKey:@"practical_problems"])
        {
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"practical_problems"] forKey:@"practical_problems"] ;
            [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"practical_problems"] forKey:@"practical_problems"];
        }
        
        if ([DictR valueForKey:@"frequency"])
        {
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"frequency"] forKey:@"frequency"] ;
            [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"frequency"] forKey:@"frequency"];
        }
        if ([DictR valueForKey:@"refill_frequency"])
        {
            
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"refill_frequency"] forKey:@"refill_frequency"] ;
             [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"refill_frequency"] forKey:@"refill_frequency"];
        }
        if ([DictR valueForKey:@"marital_status"])
        {
            
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"marital_status"] forKey:@"marital_status"] ;
             [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"marital_status"] forKey:@"marital_status"];
        }
        if ([DictR valueForKey:@"living_status"])
        {
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"living_status"] forKey:@"living_status"] ;
             [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"living_status"] forKey:@"living_status"];
        }
        if ([DictR valueForKey:@"units"])
        {
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"units"] forKey:@"units"] ;
            [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"units"] forKey:@"units"];
        }
        if ([DictR valueForKey:@"diagnosis"])
        {
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"diagnosis"] forKey:@"medical_diagnosis"] ;
            [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"diagnosis"] forKey:@"medical_diagnosis"];
        }
        
        if ([DictR valueForKey:@"mds_treatment_medine"])
        {
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"mds_treatment_medine"] forKey:@"mds_treatment_medine"] ;
            [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"mds_treatment_medine"] forKey:@"mds_treatment_medine"];
        }
        
        if ([DictR valueForKey:@"mds_treatment_medine"])
        {
            [App_Delegate.dictPrePopulated setObject:[DictR valueForKey:@"surgery"] forKey:@"medical_surgery"] ;
            [[NSUserDefaults standardUserDefaults]setObject:[DictR valueForKey:@"surgery"] forKey:@"medical_surgery"];
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
        
}

-(void)viewDidAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode=MFSideMenuPanModeSideMenu;
}

#pragma mark UItableView Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrContent.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen)
    {
        if (self.selectIndex.section == section)
        {
            if (section==0)
            {
                return arrSubMenu.count+1;
            }
            return 1;
        }
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0)
        {
            return 55;
        }
        return 70;
    }
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0)
    {
        static NSString *CellIdentifier = @"Cell2";
        Cell2 *cell = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text=NSLocalizedString([arrSubMenu objectAtIndex:indexPath.row-1],nil);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        static NSString *CellIdentifier = @"Cell1";
        Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        cell.imgIcon.image=[UIImage imageNamed:[arrImages objectAtIndex:indexPath.section]];
        
        if(indexPath.section==0)
        {
            [cell.arrowImageView setHidden:NO];
            [cell.imgArrow setHidden:YES];
        }
        else
        {
            
            [cell.imgArrow setHidden:NO];
            [cell.arrowImageView setHidden:YES];
        }
        
        cell.titleLabel.text=NSLocalizedString([arrContent objectAtIndex:indexPath.section],nil);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.section);
    UIStoryboard *objStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 0)
    {
        if ([indexPath isEqual:self.selectIndex])
        {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
         
        }
        else
        {
            if (!self.selectIndex)
            {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
            }
            else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
     
            }
        }
    }
    else
    {
        NSLog(@"Push view Here");
    }
    
    if (indexPath.section==1)
    {
        MediaProfessionalListVC *object=[objStory instantiateViewControllerWithIdentifier:@"MediaProfessionalListVC"];
        [self.navigationController pushViewController:object animated:YES];
    }
    else if (indexPath.section==0)
    {
        if (indexPath.row!=0)
        {
            if (indexPath.row==1)
            {
                [self clickOnInitailLabResult];
            }
            else if (indexPath.row==2)
            {
                [self clickOnBoneMarrowResult];
            }
            else if (indexPath.row==3)
            {
                [self clickOnBloodCounts];
            }
            else if (indexPath.row==4)
            {
                [self clickOnTreatments];
            }
            else  if (indexPath.row==5)
            {
                [self clickOnTransfusion];
            }
            else
            {
                [self clickOnIPSSRScore];
            }
        }
    }

    else if (indexPath.section==2)
    {
        ClinicalTrialsVC *object=[objStory instantiateViewControllerWithIdentifier:@"ClinicalTrialsVC"];
        [self.navigationController pushViewController:object animated:YES];
    }
    if(indexPath.section==3)
    {
        AdditionalResourcesVC *object=[objStory instantiateViewControllerWithIdentifier:@"AdditionalResourcesVC"];
        [self.navigationController pushViewController:object animated:YES];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    Cell1 *cell = (Cell1 *)[tblView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [tblView beginUpdates];
    
    NSInteger section = self.selectIndex.section;
    
    NSUInteger contentCount = 0;
    
    if (section==0)
    {
        contentCount=arrSubMenu.count;
    }
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 1; i < contentCount + 1; i++)
    {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {   [tblView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [tblView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    [tblView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [tblView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [tblView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

 
#pragma mark  Function Methods

- (IBAction)BtnMenu:(UIButton*)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

-(IBAction)clickOnSymptomTracker:(id)sender
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SymptomTrackerVC *objSymptom=[objStoryboard instantiateViewControllerWithIdentifier:@"SymptomTrackerVC"];
    [self.navigationController pushViewController:objSymptom animated:YES];
}

-(IBAction)clickOnMedicine:(id)sender
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MedicalScreenVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"MedicalScreenVC"];
    [self.navigationController pushViewController:objMedicalScreen animated:YES];
}

-(IBAction)clickOnCalender:(id)sender
{
    AppointmentListVC *objMedicalScreen=[[AppointmentListVC alloc]initWithNibName:@"AppointmentListVC" bundle:nil];
    [self.navigationController pushViewController:objMedicalScreen animated:YES];
}

-(IBAction)clickOnNotes:(id)sender
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NotesListVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"NotesListVC"];
    [self.navigationController pushViewController:objMedicalScreen animated:YES];
}
-(IBAction)clickOnProfile:(id)sender
{
    
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuProfileScreenVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"MenuProfileScreenVC"];
    [self.navigationController pushViewController:objMedicalScreen animated:YES];
}

-(void)clickOnInitailLabResult
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InicialLabResultVC *objview=[objStoryboard instantiateViewControllerWithIdentifier:@"InicialLabResultVC"];
    objview.strEntryFlag = @"I";
    [self.navigationController pushViewController:objview animated:YES];

}

-(void)clickOnBoneMarrowResult
{
    
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BoneMarroResultVC *object=[objStoryboard instantiateViewControllerWithIdentifier:@"BoneMarroResultVC"];
    [self.navigationController pushViewController:object animated:YES];
}


-(void)clickOnBloodCounts
{
    
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BloodCountNTransfusionVC *object=[objStoryboard instantiateViewControllerWithIdentifier:@"BloodCountNTransfusionVC"];
    [self.navigationController pushViewController:object animated:YES];
}


-(void)clickOnTreatments
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MDSTreatmentListVC *object=[objStoryboard instantiateViewControllerWithIdentifier:@"MDSTreatmentListVC"];
    [self.navigationController pushViewController:object animated:YES];
}

-(void)clickOnTransfusion
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TransfusionsVC *objview=[objStoryboard instantiateViewControllerWithIdentifier:@"TransfusionsVC"];
    [self.navigationController pushViewController:objview animated:YES];
}

-(void)clickOnIPSSRScore
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IPSSScoreListVC *objview=[objStoryboard instantiateViewControllerWithIdentifier:@"IPSSScoreList"];
    [self.navigationController pushViewController:objview animated:YES];
}


-(IBAction)clickOnSearch:(id)sender
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchResultVC *object=[objStoryboard instantiateViewControllerWithIdentifier:@"SearchResult"];

    [self.navigationController pushViewController:object animated:YES];
}
- (void) dealloc
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(IBAction)updateDeviceToken
{
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
    {
        
        [Dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] forKey:@"device_token"];
        
        [Dic setObject:@"I" forKey:@"device_type"];
        
        UIDevice *device = [UIDevice currentDevice];
        
        NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
        
        [Dic setObject:currentDeviceId forKey:@"device_id"];
        
        [UnirestAsyncApi callPostAsyncAPI:@"register_device.php" withParameter:Dic selector:@selector(callBackForUpdateDeviceToken:) toTarget:self showHUD:NO];
    }
}

-(void)callBackForUpdateDeviceToken:(NSMutableDictionary*)DictR
{
    NSString *strStatus=[DictR valueForKey:@"status"];
    NSLog(@"Status Device Register: %@",strStatus);
}
#pragma mark- SignIn with Google+

- (void)signInToGoogle
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        
        UIAlertController *alertSignOut = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure want to Logout?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                             {
                                 [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"UserGoogleInfo"];
                                 [[NSUserDefaults standardUserDefaults]synchronize];

                                 
                                 [[GIDSignIn sharedInstance] signOut];
                             }
                             ];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                 {
                                     
                                 }
                                 ];
        
        [alertSignOut addAction:ok];
        [alertSignOut addAction:Cancel];
        
        [self presentViewController:alertSignOut animated:YES completion:nil];
        
        
    }
    else
    {
        GIDSignIn *signIn = [GIDSignIn sharedInstance];
        signIn.shouldFetchBasicProfile = YES;
        signIn.delegate = self;
        signIn.uiDelegate = self;
        
        [GIDSignIn sharedInstance].clientID = googleClientId;
        
        [[GIDSignIn sharedInstance] signIn];
    }
    
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if (error)
    {
        UIAlertView *aV = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Failed to Sign In" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aV show];
        NSLog(@"Status: Authentication error: %@", error);
        return;
    }
    
    
    NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc]init];
    
    if (user.profile.email)
    {
        [dictUserInfo setValue:user.profile.email forKey:@"email"];
    }
    
    NSLog(@"User Dict: %@",user);
    
    [[NSUserDefaults standardUserDefaults]setObject:dictUserInfo forKey:@"UserGoogleInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        [self testBeforeDownload];
    }
    
    
    NSLog(@"Succedded didSignInForUser \n %@",user);
    
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if (error)
    {
        NSLog(@"Status: Failed to disconnect: %@", error);
    }
    else
    {
        NSLog(@"Status: Disconnected");
    }
    
    NSLog(@"Succedded didDisconnectWithUser");
    
}


- (void)presentSignInViewController:(UIViewController *)viewController
{
    [[self navigationController] pushViewController:viewController animated:YES];
}





-(void)testBeforeDownload
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        strEmail = [App_Delegate MD5String:strEmail];
        
        [dic setObject:strEmail forKey:@"user_id"];
        
        [UnirestAsyncApi callPostAsyncAPI:@"backup_updatedon.php" withParameter:dic selector:@selector(callBackStatusMainDB:) toTarget:self showHUD:YES];
        
    }
}


-(void) callBackStatusMainDB : (NSMutableDictionary *)DictRes
{
    if (DictRes)
    {
        int status=[[DictRes valueForKey:@"status"] intValue];
        if (status==1)
        {
            NSString *strResData = [DictRes objectForKey:@"data"];
            if (strResData.length>1)
            {
                NumOfDownloadNeeded= [NumOfDownloadNeeded stringByAppendingString:@"1"];
                
                NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
                NSString *strEmail = [dictValue valueForKey:@"email"];
                NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
                
                strEmail = [App_Delegate MD5String:strEmail];
                
                [dic1 setObject:strEmail forKey:@"email"];
                
                
                [UnirestAsyncApi callPostAsyncAPI:@"user_info_sqlite_updatedon.php" withParameter:dic1 selector:@selector(callBackStatusUserDB:) toTarget:self showHUD:YES];
            }
        }
        else if( status == 0)
        {
            NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
            NSString *strEmail = [dictValue valueForKey:@"email"];
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
            
            strEmail = [App_Delegate MD5String:strEmail];
            
            [dic1 setObject:strEmail forKey:@"email"];
            [UnirestAsyncApi callPostAsyncAPI:@"user_info_sqlite_updatedon.php" withParameter:dic1 selector:@selector(callBackStatusUserDB:) toTarget:self showHUD:YES];
        }
    }
}

-(void) callBackStatusUserDB : (NSMutableDictionary *)DictRes
{
    if (DictRes)
    {
        int status=[[DictRes valueForKey:@"status"] intValue];
        if (status==1)
        {
            NSString *strResData = [DictRes objectForKey:@"data"];
            if (strResData.length>1)
            {
                NumOfDownloadNeeded=[NumOfDownloadNeeded stringByAppendingString:@"2"];
                
                [self DownloadOrUploadData];
            }
        }
        else if (status == 0)
        {
            [self DownloadOrUploadData];
        }
    }
}

-(void)DownloadOrUploadData
{
    if ([NumOfDownloadNeeded isEqualToString:@""])
    {
        App_Delegate.UploadBoth=true;
        [App_Delegate startUploadData];
    }
    else
    {
        UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"We have detected conflicting data on the server from another device. Would you like to download the latest data from the server? Or use the data from this device and overwrite what is on the server?" delegate:self cancelButtonTitle:@"Download Latest From Server" otherButtonTitles:@"Use Local Data and Overwrite Server", nil];
        AV.tag=1000;
        [AV show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000)
    {
        if (buttonIndex ==0)
        {
            MenuScreen *vc = [[MenuScreen alloc] init];
            [vc DownloadMainDB ];
        }
        else if (buttonIndex ==1)
        {
            App_Delegate.UploadBoth=true;
            [App_Delegate startUploadData];
        }
        
    }
}



-(IBAction)clickOnDownloadData:(id)sender
{
    NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
    NSString *strEmail = [dictValue valueForKey:@"email"];
    
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    
    strEmail = [App_Delegate MD5String:strEmail];
    
    [Dic setValue:strEmail forKey:@"user_id"];
    [UnirestAsyncApi callPostAsyncAPI:@"get_db_backup.php" withParameter:Dic selector:@selector(callBackForDownloadSqlite:) toTarget:self showHUD:YES];
    
}

-(void)callBackForDownloadSqlite:(NSMutableDictionary*)DictR
{
    [[NSUserDefaults standardUserDefaults]setValue:@"YES"forKey:@"isFirstTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    int status=[[DictR valueForKey:@"status"] intValue];
    
    if (status==1)
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        
        NSString *strUrl =[DictR valueForKey:@"data"];
        
        NSURL  *url = [NSURL URLWithString:strUrl];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"MDSManagerDB.sqlite"];
            [urlData writeToFile:filePath atomically:YES];
            
            App_Delegate.dBPath=filePath;
            NSLog(@"DBPath:%@",App_Delegate.dBPath);
            App_Delegate.dbObj=[[DBFile alloc] initWith];
            
        }
        
        NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
        
        strEmail = [App_Delegate MD5String:strEmail];
        
        [Dic setValue:strEmail forKey:@"user_id"];
        [UnirestAsyncApi callPostAsyncAPI:@"get_images_zip.php" withParameter:Dic selector:@selector(callBackForDownloadImageFolder:) toTarget:self showHUD:YES];
    }
    else
    {
        UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"MDS Manager\u2122" message:[DictR valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altView show];
    }
}




-(void)callBackForDownloadImageFolder:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        
        NSString *strUrl =[DictR valueForKey:@"data"];
        
        NSURL  *url = [NSURL URLWithString:strUrl];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"MyImages.zip"];
            [urlData writeToFile:filePath atomically:YES];
            
            ZipArchive *za = [[ZipArchive alloc] init];
            NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
            
            if ([za UnzipOpenFile: filePath])
            {
                
                BOOL ret = [za UnzipFileTo:folderPath overWrite: YES];
                if (ret == YES)
                {
                    [za UnzipCloseFile];
                }
                
            }
        }
    }
    else
    {
        UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"MDS Manager\u2122" message:@"There is problem! Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altView show];
    }
}


@end

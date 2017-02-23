
//  SettingsScreenVC.m
//  MyMDSManager

//  Created by CEPL on 01/08/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "SettingsScreenVC.h"
#import "MFSideMenu.h"
#import "UnirestAsyncApi.h"
#import "ZipArchive.h"

#import <GoogleSignIn/GoogleSignIn.h>

#import "AESCrypt.h"

#import "MenuScreen.h"


#define googleClientId @"803116412282-hah5o9em1lsnrjrprn6cjqj4hpglu4ho.apps.googleusercontent.com"
#define googleClientSecret @""
#define UploadConfirmAlertTag 601


@interface SettingsScreenVC () <GIDSignInDelegate, GIDSignInUIDelegate>

@end

@implementation SettingsScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        [btnGoogleLogin setTitle:@"Logout" forState:UIControlStateNormal];
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        if ([dictValue valueForKey:@"email"])
        {
           [lblLoginState setText:[NSString stringWithFormat:@"Login With %@",[dictValue valueForKey:@"email"]]];
        }
    }
    else
    {
        [btnGoogleLogin setTitle:@"Login" forState:UIControlStateNormal];
        [lblLoginState setText:@""];
    }
    
    NumOfDownloadNeeded=@"";

}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateFirstTimeScreen];
}


-(void)updateFirstTimeScreen
{
    NSString *strPushNotification = [[NSUserDefaults standardUserDefaults] valueForKey:@"PushNotification"];
    if ([strPushNotification isEqualToString:@"YES"])
    {
        App_Delegate.isPushNotificationOn = YES;
        switchPushNotification.on = YES;
    }
    else
    {
        App_Delegate.isPushNotificationOn = NO;
        switchPushNotification.on = NO;
    }
   
    NSString *strCalNotification = [[NSUserDefaults standardUserDefaults] valueForKey:@"CalendarNotifcation"];
    if ([strCalNotification isEqualToString:@"YES"])
    {
        App_Delegate.isCalenderNotificationOn = YES;
        switchCalendarNotification.on = YES;
    }
    else
    {
        App_Delegate.isCalenderNotificationOn = NO;
        switchCalendarNotification.on = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
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

#pragma mark - IBAction method
- (IBAction)didSelectHome:(UIButton *)sender
{
     [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)changePushNotificationState:(UISwitch *)sender
{
    if (sender.on)
    {
        App_Delegate.isPushNotificationOn = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"PushNotification"];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        }
        else
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
        }
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        App_Delegate.isPushNotificationOn = NO;
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"PushNotification"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeCalendarNotification:(UISwitch *)sender
{
    if (sender.on)
    {
        App_Delegate.isCalenderNotificationOn = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CalendarNotifcation"];
    }
    else
    {
        App_Delegate.isCalenderNotificationOn = NO;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"CalendarNotifcation"];

    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(IBAction)clickOnUploadData:(id)sender
{
    NSString *str;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdate"]==nil)
    {
        str=[NSString stringWithFormat:@"This will replace your data on our server . Your server data will now match what is on your local device."];
        UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"WARNING" message:str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue – Overwrite", nil];
        altView.tag=UploadConfirmAlertTag;
        [altView show];
        
    }
    else
    {
        str=[NSString stringWithFormat:@"This will replace your data on our server which was last synced on %@. Your server data will now match what is on your local device. ",[[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdate"]];
        UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"WARNING" message:str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue – Overwrite", nil];
        altView.tag=UploadConfirmAlertTag;
        [altView show];
    }
}

-(void)startUploadData
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectoryPath = [paths objectAtIndex:0];
        
        NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"MDSManagerDB.sqlite"];
        
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
        
        strEmail = [App_Delegate MD5String:strEmail];
        
        [Dic setValue:strEmail forKey:@"user_id"];
        [Dic setValue:fileURL forKey:@"file"];
        
        [UnirestAsyncApi callPostAsyncAPI:@"upload_backup.php" withParameter:Dic selector:@selector(callBackForUploadSqlite:) toTarget:self showHUD:YES];
    }
    else
    {
        [self signInToGoogle:nil];
    }
}


-(void)startUploadUserInfoData
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectoryPath = [paths objectAtIndex:0];
        
        NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"MDSManager_UserInfo_DB.sqlite"];
        
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
        
        strEmail = [App_Delegate MD5String:strEmail];
        
        [Dic setValue:strEmail forKey:@"email"];
        [Dic setValue:fileURL forKey:@"file"];
        
        [UnirestAsyncApi callPostAsyncAPI:@"upload_user_info_sqlite.php" withParameter:Dic selector:@selector(callBackForUserInfoUploadSqlite:) toTarget:self showHUD:YES];
    }

}

-(void)callBackForUploadSqlite:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectoryPath = [paths objectAtIndex:0];
        
        NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"/MyImages"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
        
        NSString *zipFile = [documentDirectoryPath stringByAppendingPathComponent:@"Images.Zip"];
        
        ZipArchive *za = [[ZipArchive alloc] init];
        [za CreateZipFile2:zipFile];
        
        NSArray *arrContent = [self listFileAtPath:filePath];

        for (int i =0; i<arrContent.count; i++)
        {
            if (![[arrContent objectAtIndex:i] isEqualToString:@"Images.Zip"])
            {
                [za addFileToZip:[filePath stringByAppendingPathComponent:[arrContent objectAtIndex:i]] newname:[arrContent objectAtIndex:i]];
            }
            
        }
        
        BOOL success = [za CloseZipFile2];
        
        //NSLog(@"sqliteFile %@",sqliteFile);
        NSLog(@"Zipped file with result %d",success);
        
        
        NSURL *fileURL = [NSURL fileURLWithPath:zipFile];
        NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
        
        strEmail = [App_Delegate MD5String:strEmail];
        
        [Dic setValue:strEmail forKey:@"user_id"];
        [Dic setValue:fileURL forKey:@"file"];
        [UnirestAsyncApi callPostAsyncAPI:@"upload_images_zip.php" withParameter:Dic selector:@selector(callBackForUploadImageFolder:) toTarget:self showHUD:YES];
    }
    
    
}

-(void)callBackForUserInfoUploadSqlite:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectoryPath = [paths objectAtIndex:0];
        
        NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"/MyImages"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
        
        NSString *zipFile = [documentDirectoryPath stringByAppendingPathComponent:@"Images.Zip"];
        
        ZipArchive *za = [[ZipArchive alloc] init];
        [za CreateZipFile2:zipFile];
        
        NSArray *arrContent = [self listFileAtPath:filePath];
        
        for (int i =0; i<arrContent.count; i++)
        {
            if (![[arrContent objectAtIndex:i] isEqualToString:@"Images.Zip"])
            {
                [za addFileToZip:[filePath stringByAppendingPathComponent:[arrContent objectAtIndex:i]] newname:[arrContent objectAtIndex:i]];
            }
        }
        
        BOOL success = [za CloseZipFile2];
        
        //NSLog(@"sqliteFile %@",sqliteFile);
        NSLog(@"Zipped file with result %d",success);
        
        
        NSURL *fileURL = [NSURL fileURLWithPath:zipFile];
        NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
        
        strEmail = [App_Delegate MD5String:strEmail];
        
        [Dic setValue:strEmail forKey:@"user_id"];
        [Dic setValue:fileURL forKey:@"file"];
        [UnirestAsyncApi callPostAsyncAPI:@"upload_images_zip.php" withParameter:Dic selector:@selector(callBackForUploadImageFolderUserInfo:) toTarget:self showHUD:YES];
    }
    
}

-(void)callBackForUploadImageFolderUserInfo:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        NSString *strTimeinterval = [dateFormatter stringFromDate:[NSDate date]];
        
        [[NSUserDefaults standardUserDefaults]setObject:strTimeinterval forKey:@"LastUpdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"MDS Manager\u2122" message:@"Data uploaded successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altView show];
    }
    
}


-(void)callBackForUploadImageFolder:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        NSString *strTimeinterval = [dateFormatter stringFromDate:[NSDate date]];
        
        [[NSUserDefaults standardUserDefaults]setObject:strTimeinterval forKey:@"LastUpdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
   
}

-(NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

#pragma mark- SignIn with Google+

- (IBAction)signInToGoogle:(UIButton *)sender
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        
        UIAlertController *alertSignOut = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure want to Logout?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                {
                    [btnGoogleLogin setTitle:@"Login" forState:UIControlStateNormal];
                    [lblLoginState setText:@""];
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
        [btnGoogleLogin setTitle:@"Logout" forState:UIControlStateNormal];
        
        [self testBeforeDownload];
        
        if ([dictUserInfo valueForKey:@"email"])
        {
            [lblLoginState setText:[NSString stringWithFormat:@"Login With %@",[dictUserInfo valueForKey:@"email"]]];
        }
    }
    else
    {
        [btnGoogleLogin setTitle:@"Login" forState:UIControlStateNormal];
        [lblLoginState setText:@""];
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
        // MenuScreen *vc = [[MenuScreen alloc] init];
        //[vc DownloadMainDB ];
         App_Delegate.UploadBoth=true;
        [App_Delegate startUploadData];
    }
    else
    {
        UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"We have detected conflicting data on the server from another device. Would you like to download the latest data from the server? Or use the data from this device and overwrite what is on the server?" delegate:self cancelButtonTitle:@"Download Latest From Server" otherButtonTitles:@"Use Local Data and Overwrite Server", nil];
        AV.tag=100;
        [AV show];

    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultSent:
        {
            NSLog(@"You sent the email.");
            UIAlertView *ai=[[UIAlertView alloc ]initWithTitle:@"Message" message:@"Exported Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ai show];
            break;
        }
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
        {
            NSLog(@"You cancelled sending this email.");
            /*UIAlertView *ai=[[UIAlertView alloc ]initWithTitle:@"Message" message:@"C" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ai show];*/
            break;
        }
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end

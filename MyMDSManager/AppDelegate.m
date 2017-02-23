
//  AppDelegate.m
//  MyMDSManager

//  Created by CEPL on 03/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "AppDelegate.h"
#import "MenuScreen.h"
#import "MFSideMenuContainerViewController.h"
#import "MenuHomeScreenVC.h"
#import "DBFile.h"
#import "DisclaimerVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UnirestAsyncApi.h"
#import "UnirestAsyncApi.h"
#import "SettingsScreenVC.h"
#import "ZipArchive.h"

#import <AudioToolbox/AudioToolbox.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "MBProgressHUD.h"

#import "MessagesVC.h"

#import <GoogleSignIn/GoogleSignIn.h>


#define systemSoundID    1315

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize nvgController,window,objAppPerson,dbObj,dictReminder,reminderSwitch,strReminderString,dictTest,dictNormal,arrTreatementMedicine,arrMDSTreatement,unitLoaded,deviceTokenValue,isPushNotificationOn,isCalenderNotificationOn,isNewAddedInList,strSymptomCat,strProviderForDiagnosis,arrCountryPhoneCode;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.showFirstTimeInfo = NO;
    
    [Fabric with:@[[Crashlytics class]]];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //Variable Initailization
    self.strProviderForDiagnosis = @"0";
    self.unitLoaded=NO;
    self.weightLimit = 301;
    self.objAppPerson=[[PersonObject alloc]initDefaults];
    self.reminderSwitch=NO;
    self.strReminderString=@"";
    self.dictPrePopulated = [[NSMutableDictionary alloc] init];
    
    dBName=@"MDSManagerDB.sqlite";
    self.dBPath=[self getDBPath: dBName];
    NSLog(@"DBPath:%@",self.dBPath);
    [self copyDatabaseFromApplicationBundelIfNeeded];
    self.dbObj=[[DBFile alloc] initWith];
    
    dBNameUseInfo=@"MDSManager_UserInfo_DB.sqlite";
    self.dBPath_userInfo=[self getDBPath: dBNameUseInfo];
    NSLog(@"DBPath:%@",self.dBPath_userInfo);
    [self copyDatabaseFromApplicationBundelIfNeededUserInfo];
    self.dbObjUserInfo=[[DBUserInfoFile alloc] initWith];

    arrCountryPhoneCode = [self.dbObjUserInfo getCountryPhoneCode];
    
    self.arrSoundFiles = [[NSArray alloc]initWithObjects:@"attention",@"frenzy",@"gentlealarm",@"jingle_bell",@"msg_posted",@"soft_alert_play_once", nil];
    
    [self setUpDafaultsLists];
    
    
    if(![[NSUserDefaults standardUserDefaults]valueForKey:@"CalendarNotifcation"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CalendarNotifcation"];
    }
    if(![[NSUserDefaults standardUserDefaults]valueForKey:@"PushNotification"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"PushNotification"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
    self.isPushNotificationOn = [[[NSUserDefaults standardUserDefaults]valueForKey:@"PushNotification"]boolValue];
    
    
    if (self.isPushNotificationOn)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [application registerForRemoteNotifications];
            
        }
        else
        {
            [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
        }
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    
    if (launchOptions)
    {
        // to handle push notifications
        [self loadMessages];
    }
    else if (![[NSUserDefaults standardUserDefaults]valueForKey:@"Accepted"] || [[[NSUserDefaults standardUserDefaults] valueForKey:@"IsUpdated"] isEqualToString:@"Yes"])
    {
        UIStoryboard *objStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        objDis = [objStory instantiateViewControllerWithIdentifier:@"DisclaimerVC"];
        self.window.rootViewController = objDis;
        [self.window addSubview:objDis.view];
    }
    else
    {
        MenuScreen *leftMenuViewController = [[MenuScreen alloc] init];
        
        container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:[self navigationController]
                                                        leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
        
        container.menuWidth=202;
        self.window.rootViewController = container;
    }
    
    [self.window makeKeyAndVisible];

    [self checkForVersion];
    
    return YES;
}


-(void)checkForVersion
{
    [UnirestAsyncApi callPostAsyncAPI:@"app_version.php" withParameter:nil selector:@selector(CallBackVersionCheck:) toTarget:self showHUD:NO];
}

-(void)CallBackVersionCheck : (NSMutableDictionary *)DictRes
{
    if(DictRes)
    {
        NSMutableDictionary *dicData=[DictRes objectForKey:@"data"];
        if ([dicData objectForKey:@"ios_version"])
        {
            NSString *strCurrentVersion= [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
            
            NSLog(@"%@",[dicData objectForKey:@"ios_version"]);
            
            float currentVersion=[strCurrentVersion floatValue];
            float serverVersion=[[dicData objectForKey:@"ios_version"]floatValue];
            
            if (currentVersion<serverVersion)
            {
                if ([[dicData objectForKey:@"ios_force_download"] isEqualToString:@"0"])
                {
                    UIAlertView *AlertForUpdate = [[UIAlertView alloc]initWithTitle:@"Message" message:[dicData objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Update Now", nil];
                    AlertForUpdate.tag=11111;
                    [AlertForUpdate show];
                }
                else if([[dicData objectForKey:@"ios_force_download"] isEqualToString:@"1"])
                {
                    UIAlertView *AlertForUpdate = [[UIAlertView alloc]initWithTitle:@"Message" message:[dicData objectForKey:@"message"] delegate:self cancelButtonTitle:@"Update Now" otherButtonTitles:nil, nil];
                    AlertForUpdate.tag=22222;
                    [AlertForUpdate show];
                }
            }
        }
    }
}




-(void)loadDisclaimer
{
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    NSString *strLastUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdated"];
    if (strLastUpdated)
    {
        [Dic setObject:strLastUpdated forKey:@"lastUpdatedOn"];
    }
    
    [UnirestAsyncApi callPostAsyncAPI:@"disclaimer.php" withParameter:Dic selector:@selector(callBackForAdminData:) toTarget:self showHUD:NO];
}
-(void)callBackForAdminData:(NSMutableDictionary*)DictR
{
    NSString *disclamer=[DictR valueForKey:@"detail"];
    if (disclamer.length>0)
    {
        NSString *SavedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"DisclaimerVersion"];
        NSString *CurrentVersion    = [DictR objectForKey:@"version"];
        
        if ([SavedVersion isEqualToString:CurrentVersion])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"IsUpdated"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:[DictR objectForKey:@"version"] forKey:@"DisclaimerVersion"];
            [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"IsUpdated"];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:disclamer forKey:@"PrivacyPolicyText"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(void)setUpDafaultsLists
{
    //Pre Populated List of Symptom if list not come form server side
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"symptom"])
    {
        NSMutableArray *symtomList = [[NSMutableArray alloc]initWithObjects:@"Low Platelet count (THROMBOCYTOPENIA)",@"Low Red Cell count (ANEMIA)",@"Low White Cell count (NEUTROPENIA)", nil ];
        [[NSUserDefaults standardUserDefaults]setObject:symtomList forKey:@"symptom"];
    }
   
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"practical_problems"])
    {
        NSMutableArray *symtomList = [[NSMutableArray alloc]initWithObjects:@"Child Care",@"Finances",@"Housing", nil ];
        [[NSUserDefaults standardUserDefaults]setObject:symtomList forKey:@"practical_problems"];
    }
    
    
    //Pre Populated List of Marital Status if list not come form server side
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"marital_status"])
    {
        NSMutableArray *marital_Status = [[NSMutableArray alloc]initWithObjects:@"Single",@"Married",@"Separated",@"Divorced",@"Widowed", nil ];
        [[NSUserDefaults standardUserDefaults]setObject:marital_Status forKey:@"marital_status"];
        
    }
    //Pre Populated List of Living Status if list not come form server side
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"living_status"])
    {
        NSMutableArray *living_Status = [[NSMutableArray alloc]initWithObjects:@"Alone",@"With Family",@"Hostal", nil ];
        [[NSUserDefaults standardUserDefaults]setObject:living_Status forKey:@"living_status"];
        
    }
    //Pre Populated List of frequency if list not come form server side
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"frequency"])
    {
        NSMutableArray *frequency =[[NSMutableArray alloc]initWithObjects:@"3 Times per day",@"1 Time per week",@"Every 3 hours",@"Every 2 days", nil ];
        [[NSUserDefaults standardUserDefaults]setObject:frequency forKey:@"frequency"];
    }
    //Pre Populated List of refill frequency if list not come form server side
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"refill_frequency"])
    {
        
        NSMutableArray *refillFrequency =[[NSMutableArray alloc]initWithObjects:@"Every Day",@"Weekly",@"Monthly",@"N/A", nil ];
        [[NSUserDefaults standardUserDefaults]setObject:refillFrequency forKey:@"refill_frequency"];
    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"units"])
    {
        
        NSMutableArray *units =[[NSMutableArray alloc] initWithObjects:@"mm3",@"gm/dL",@"lu/ml",@"mcg/ml",@"ng/ml",@"pg/ml", nil];
        [[NSUserDefaults standardUserDefaults]setObject:units forKey:@"units"];
    }
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"medical_diagnosis"])
    {
        
        NSMutableArray *units =[[NSMutableArray alloc] initWithObjects:@"Serum Erythropoietin",@"White Blood Cell Count",@"Absolute Neutrophil Count", nil];
        [[NSUserDefaults standardUserDefaults]setObject:units forKey:@"medical_diagnosis"];
    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"mds_treatment_medine"])
    {
        
        NSMutableArray *units =[[NSMutableArray alloc] initWithObjects:@"Neupogen injection",@"Dacogen intravenous",@"Cytarabine injection", nil];
        [[NSUserDefaults standardUserDefaults]setObject:units forKey:@"mds_treatment_medine"];
    }

    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"living_status"] mutableCopy] forKey:@"living_status"] ;
    
    [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"marital_status"] mutableCopy] forKey:@"marital_status"] ;
    
    [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"refill_frequency"] mutableCopy] forKey:@"refill_frequency"] ;
    
    [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"frequency"] mutableCopy] forKey:@"frequency"] ;
    
    [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"symptom"] mutableCopy] forKey:@"symptom"] ;
    
    [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"practical_problems"] mutableCopy] forKey:@"practical_problems"] ;
    
    [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"units"] mutableCopy] forKey:@"units"] ;
    
    [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"medical_diagnosis"] mutableCopy] forKey:@"medical_diagnosis"] ;
    
     [self.dictPrePopulated setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"mds_treatment_medine"] mutableCopy] forKey:@"mds_treatment_medine"] ;    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"DiagnosisData"])
    {
        NSMutableArray *arrTests=[[[NSUserDefaults standardUserDefaults]objectForKey:@"DiagnosisData"]mutableCopy ];
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
    
}


#pragma mark -
#pragma mark - Side Menu Screen Methods

- (MenuHomeScreenVC *)demoController
{
    UIStoryboard *objStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [objStory instantiateViewControllerWithIdentifier:@"MenuHomeScreenVC"];
}

- (UINavigationController *)navigationController
{
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
    
}

#pragma mark -
#pragma mark - DB Method

- (NSString *)getDBPath :(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:filename];
}

-(void) copyDatabaseFromApplicationBundelIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    Boolean success = [fileManager fileExistsAtPath:self.dBPath];
    if(success)
        return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dBName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.dBPath error:nil];
}

-(void) copyDatabaseFromApplicationBundelIfNeededUserInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    Boolean success = [fileManager fileExistsAtPath:self.dBPath_userInfo];
    if(success)
        return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dBNameUseInfo];
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.dBPath_userInfo error:nil];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    if (deviceToken != nil)
    {
        deviceTokenValue = [[[[deviceToken description]
                              stringByReplacingOccurrencesOfString: @"<" withString: @""]
                             stringByReplacingOccurrencesOfString: @">" withString: @""]
                            stringByReplacingOccurrencesOfString: @" " withString: @""];
        
        [[NSUserDefaults standardUserDefaults]setObject:deviceTokenValue forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%@",deviceTokenValue);
        [self updateDeviceToken];
    }
    else
    {
        deviceTokenValue=@"";
    }
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (userInfo)
    {
        NSString *strMessage=[[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *altMessag=[[UIAlertView alloc] initWithTitle:@"Notification" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altMessag show];
        
        
        [self loadMessages];
        
        
    }
    NSLog(@"UserInfo:%@",userInfo);
    
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    UIApplicationState state = [app applicationState];
    if (state == UIApplicationStateActive)
    {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],notif.soundName]];
        NSError *error;
        self.AudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        if(self.AudioPlayer)
        {
            if (error)
            {
                NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
            }
            else
            {
                [self.AudioPlayer prepareToPlay];
                [self.AudioPlayer play];
            }
        }
        else
        {
             AudioServicesPlaySystemSound (systemSoundID);
        }
    }
    if (notif)
    {
        UIAlertView *altMessag=[[UIAlertView alloc] initWithTitle:@"Notification" message:notif.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altMessag show];
    }

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}


-(void)loadMessages
{
        App_Delegate.ScreenOpened=2;

        MenuScreen *leftMenuViewController = [[MenuScreen alloc] init];
        UIStoryboard *objStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessagesVC *messageObj=[objStory instantiateViewControllerWithIdentifier:@"MessagesVC"];
    
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:messageObj];
        nav.navigationBarHidden = true;
    
        container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:nav
                                                        leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
    
    
    
        container.menuWidth=202;
        self.window.rootViewController = container;
    
    
}

-(IBAction)updateDeviceToken
{
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
    {
        [Dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] forKey:@"device_token"];
    }
    else
    {
        [Dic setObject:@"" forKey:@"device_token"];
    }
    [Dic setObject:@"I" forKey:@"device_type"];
    
    UIDevice *device = [UIDevice currentDevice];
    
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    
    [Dic setObject:currentDeviceId forKey:@"device_id"];

    [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"register_device.php" withParameter:Dic selector:@selector(callBackForUpdateDeviceToken:) toTarget:self];
 
}

-(void)callBackForUpdateDeviceToken:(NSMutableDictionary*)DictR
{
    NSString *strStatus=[DictR valueForKey:@"status"];
    NSLog(@"Status Device Register: %@",strStatus);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"Accepted"] || [[[NSUserDefaults standardUserDefaults] valueForKey:@"IsUpdated"] isEqualToString:@"Yes"])
    {
        UIStoryboard *objStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        objDis = [objStory instantiateViewControllerWithIdentifier:@"DisclaimerVC"];
        self.window.rootViewController = objDis;
        [self.window addSubview:objDis.view];
        
    }

    [self.window makeKeyAndVisible];
    
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [self loadDisclaimer];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"IsLatestUpdate"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"IsLatestUpdate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [self TestBeforeDownload];
    
}

-(void)TestBeforeDownload
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
        
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        strEmail = [App_Delegate MD5String:strEmail];
        
        [dic setObject:strEmail forKey:@"user_id"];
        [dic1 setObject:strEmail forKey:@"email"];
        
        
        [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"backup_updatedon.php" withParameter:dic selector:@selector(callBackForTestUpdateOnMainDB:) toTarget:self];
        
        [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"user_info_sqlite_updatedon.php" withParameter:dic1 selector:@selector(callBackForTestUpdateOnUserDB:) toTarget:self];
    }

}

-(void)callBackForTestUpdateOnMainDB : (NSMutableDictionary *)DictRes
{
    if (DictRes)
    {
        int status=[[DictRes valueForKey:@"status"] intValue];
        if (status==1)
        {
            NSString *strResData = [DictRes objectForKey:@"data"];
            NSString *strLastUpdatedMainDB;
            NSString *strUpLoadedStatus;
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdatedMainData"])
            {
                strLastUpdatedMainDB = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdatedMainData"];
            }
            else
            {
                strLastUpdatedMainDB = @"";
            }
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"])
            {
                strUpLoadedStatus= [[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"];
                
            }
            if (![strResData isEqualToString:strLastUpdatedMainDB])
            {
                
                    
                UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"We have detected conflicting data on the server from another device. Would you like to download the latest data from the server? Or use the data from this device and overwrite what is on the server?" delegate:self cancelButtonTitle:@"Download Latest From Server" otherButtonTitles:@"Use Local Data and Overwrite Server", nil];
                AV.tag=161;
                [AV show];
                
            }
           
            else if ([strUpLoadedStatus isEqualToString:@"ChangesUnSavedMainDB"])
            {
                UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Do you want to save changes to server ?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
                AV.tag=171;
                [AV show];
            }
        }
    }
}

-(void)callBackForTestUpdateOnUserDB : (NSMutableDictionary *)DictRes
{
    if (DictRes)
    {
        int status=[[DictRes valueForKey:@"status"] intValue];
        if (status==1)
        {
            NSString *strResData = [DictRes objectForKey:@"data"];
            NSString *strLastUpdatedUserDB;
            NSString *strUpLoadedStatus;
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdatedUserData"])
            {
                strLastUpdatedUserDB = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdatedUserData"];
            }
            else
            {
                strLastUpdatedUserDB = @"";
            }
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"])
            {
                strUpLoadedStatus= [[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"];
            }
            
            if (![strResData isEqualToString:strLastUpdatedUserDB])
            {
                
                UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"We have detected conflicting data on the server from another device. Would you like to download the latest data from the server? Or use the data from this device and overwrite what is on the server?" delegate:self cancelButtonTitle:@"Download Latest From Server" otherButtonTitles:@"Use Local Data and Overwrite Server", nil];
                AV.tag=181;
                [AV show];
                
            }
            else if ([strUpLoadedStatus isEqualToString:@"ChangesUnSavedUserInfoDB"])
            {
                UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Do you want to save changes to server ?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
                AV.tag=191;
                [AV show];
            }
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag==141)
    {
        if (buttonIndex==1)
        {
            NSString *strStatus= [[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"];
            
            if ([strStatus isEqualToString:@"ChangesUnSavedMainDB"])
            {
                [self startUploadData];
            }
            else if ([strStatus isEqualToString:@"ChangesUnSavedUserInfoDB"])
            {
                [self startUploadUserInfoData];
            }
            else if ([strStatus isEqualToString:@"ChangesUnSavedImages"])
            {
                [self StartUploadImage];
            }
        }
    }
    else if ( alertView.tag==151)
    {
        if (buttonIndex==1)
        {
            MenuScreen *vc = [[MenuScreen alloc] init];
            [vc DownloadMainDB ];
        }
    }
    else if ( alertView.tag==161)
    {
        if (buttonIndex==0)
        {
            MenuScreen *vc = [[MenuScreen alloc] init];
            [vc DownloadMainDB ];
        }
        else if (buttonIndex == 1)
        {
            [self startUploadData];
        }
    }
    else  if(alertView .tag == 171)
    {
        if (buttonIndex == 1)
        {
            [self startUploadData];
        }
    }
    else if ( alertView.tag==181)
    {
        if (buttonIndex==0)
        {
            MenuScreen *vc = [[MenuScreen alloc] init];
            [vc DownloadMainDB];
        }
        else if (buttonIndex == 1)
        {
            [self startUploadUserInfoData];
        }
    }
    else  if(alertView .tag == 191)
    {
        if (buttonIndex == 1)
        {
            [self startUploadUserInfoData];
        }
    }
    else if(alertView.tag==11111)
    {
        if (buttonIndex==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1140404422"]];
        }
    }
    else if(alertView.tag==22222)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1140404422"]];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

-(void)CheckBeforeUploadMainDB
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        strEmail = [App_Delegate MD5String:strEmail];

        [dic setObject:strEmail forKey:@"user_id"];
        
        [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"backup_updatedon.php" withParameter:dic selector:@selector(callBackForTestUpLoadOnMainDB:) toTarget:self];
    }
}

-(void)CheckBeforeUploadUserDB
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        strEmail = [App_Delegate MD5String:strEmail];

        [dic setObject:strEmail forKey:@"email"];
        
        [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"user_info_sqlite_updatedon.php" withParameter:dic selector:@selector(callBackForTestUploadOnUserDB:) toTarget:self];
    }
}

-(void)callBackForTestUpLoadOnMainDB : (NSMutableDictionary *) DictRes
{
    if (DictRes)
    {
        int status=[[DictRes valueForKey:@"status"] intValue];
        if (status==1)
        {
            NSString *strResData = [DictRes objectForKey:@"data"];
            NSString *strLastUpdatedMainDB;
            NSString *strUpLoadedStatus;
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdatedMainData"])
            {
                strLastUpdatedMainDB = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdatedMainData"];
            }
            else
            {
                strLastUpdatedMainDB = @"";
            }
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"])
            {
                strUpLoadedStatus= [[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"];
                
            }
            if (![strResData isEqualToString:strLastUpdatedMainDB])
            {
                if (strLastUpdatedMainDB.length>0 && strResData.length == 0)
                {
                    [self startUploadData];
                }
                else if (strLastUpdatedMainDB.length>0 && strResData.length>0)
                {
                    UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"We have detected conflicting data on the server from another device. Would you like to download the latest data from the server? Or use the data from this device and overwrite what is on the server?" delegate:self cancelButtonTitle:@"Download Latest From Server" otherButtonTitles:@"Use Local Data and Overwrite Server", nil];
                    AV.tag=161;
                    [AV show];
                    
                }
                else if (strLastUpdatedMainDB.length == 0 &&  strResData.length>0)
                {
                    UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"We have detected conflicting data on the server from another device. Would you like to download the latest data from the server? Or use the data from this device and overwrite what is on the server?" delegate:self cancelButtonTitle:@"Download Latest From Server" otherButtonTitles:@"Use Local Data and Overwrite Server", nil];
                    AV.tag=161;
                    [AV show];
                }
            }
            else
            {
                [self startUploadData];
            }
        }
        else
        {
            [self startUploadData];
        }
    }

}
-(void)callBackForTestUploadOnUserDB : (NSMutableDictionary *) DictRes
{
    if (DictRes)
    {
        int status=[[DictRes valueForKey:@"status"] intValue];
        if (status==1)
        {
            NSString *strResData = [DictRes objectForKey:@"data"];
            NSString *strLastUpdatedUserDB;
            NSString *strUpLoadedStatus;
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdatedUserData"])
            {
                strLastUpdatedUserDB = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastUpdatedUserData"];
            }
            else
            {
                strLastUpdatedUserDB = @"";
            }
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"])
            {
                strUpLoadedStatus= [[NSUserDefaults standardUserDefaults]objectForKey:@"UploadingStatus"];
                
            }
            
            if (![strResData isEqualToString:strLastUpdatedUserDB])
            {
                if (strLastUpdatedUserDB.length>0 && strResData.length == 0)
                {
                    [self startUploadUserInfoData];
                }
                else if (strLastUpdatedUserDB.length>0 && strResData.length>0)
                {
                    UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"We have detected conflicting data on the server from another device. Would you like to download the latest data from the server? Or use the data from this device and overwrite what is on the server?" delegate:self cancelButtonTitle:@"Download Latest From Server" otherButtonTitles:@"Use Local Data and Overwrite Server", nil];
                    AV.tag=161;
                    [AV show];
                }
                else if (strLastUpdatedUserDB.length == 0 &&  strResData.length>0)
                {
                    UIAlertView *AV=[[UIAlertView alloc]initWithTitle:@"Message" message:@"We have detected conflicting data on the server from another device. Would you like to download the latest data from the server? Or use the data from this device and overwrite what is on the server?" delegate:self cancelButtonTitle:@"Download Latest From Server" otherButtonTitles:@"Use Local Data and Overwrite Server", nil];
                    AV.tag=161;
                    [AV show];
                }
            }
            else
            {
                [self startUploadUserInfoData];
            }
        }
        else
        {
            [self startUploadUserInfoData];
        }
    }
}


-(void)startUploadData
{
    NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
    
    if (dictValue)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"ChangesUnSavedMainDB" forKey:@"UploadingStatus"];
        
        NSString *strEmail = [dictValue valueForKey:@"email"];
        strEmail = [App_Delegate MD5String:strEmail];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectoryPath = [paths objectAtIndex:0];
        
        // to remove same zip
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePathZipToRemove = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",strEmail]];
        NSError *error;
        
        BOOL success = [fileManager removeItemAtPath:filePathZipToRemove error:&error];

        
        NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"MDSManagerDB.sqlite"];
        
        NSString* zipfile = [documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",strEmail]];
        ZipArchive* zip = [[ZipArchive alloc] init];
        BOOL ret = [zip CreateZipFile2:zipfile];
        ret = [zip addFileToZip:filePath newname:[NSString stringWithFormat:@"%@.sqlite",strEmail]];//zip
        if( ![zip CloseZipFile2] )
        {
            zipfile = @"";
        }
        NSLog(@"The file has been zipped");
        
        NSURL *fileURL = [NSURL fileURLWithPath:zipfile];
        
        NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
        
        [Dic setValue:strEmail forKey:@"user_id"];
        [Dic setValue:fileURL forKey:@"file"];
        
        NSLog(@"Uploading Main Data");
        
        [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"upload_backup_1.php" withParameter:Dic selector:@selector(callBackForUploadSqlite:) toTarget:self];
    }
}


-(void)startUploadUserInfoData
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"ChangesUnSavedUserInfoDB" forKey:@"UploadingStatus"];

        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        NSString *strEmail = [dictValue valueForKey:@"email"];
        strEmail = [App_Delegate MD5String:strEmail];

        // to remove same zip
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePathZipToRemove = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",strEmail]];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePathZipToRemove error:&error];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectoryPath = [paths objectAtIndex:0];
        
        NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"MDSManager_UserInfo_DB.sqlite"];
        
        NSString* zipfile = [documentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",strEmail]];
        ZipArchive* zip = [[ZipArchive alloc] init];
        BOOL ret = [zip CreateZipFile2:zipfile];
        ret = [zip addFileToZip:filePath newname:[NSString stringWithFormat:@"%@.sqlite",strEmail]];//zip
        if( ![zip CloseZipFile2] )
        {
            zipfile = @"";
        }
        
        NSLog(@"The file has been zipped");
        
        NSURL *fileURL = [NSURL fileURLWithPath:zipfile];
        
        NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];

        [Dic setValue:strEmail forKey:@"email"];
        [Dic setValue:fileURL forKey:@"file"];
        
        NSLog(@"Uploading User Data");

        [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"upload_user_info_sqlite_1.php" withParameter:Dic selector:@selector(callBackForUserInfoUpload:) toTarget:self];
    }
}

-(void)StartUploadImage
{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"ChangesUnSavedImages" forKey:@"UploadingStatus"];
    
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
    
    NSLog(@"Zipped file with result %d",success);
    
    NSURL *fileURL = [NSURL fileURLWithPath:zipFile];
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    
    strEmail = [App_Delegate MD5String:strEmail];

    [Dic setValue:strEmail forKey:@"user_id"];
    [Dic setValue:fileURL forKey:@"file"];
    
    
    [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"upload_images_zip.php" withParameter:Dic selector:@selector(callBackForUploadImageFolder:) toTarget:self];
}

-(void)callBackForUploadSqlite:(NSMutableDictionary*)DictR
{
    
    NSLog(@"Uploaded Main Data");
    
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[DictR objectForKey:@"data"] forKey:@"LastUpdatedMainData"];
        
        if (self.UploadBoth)
        {
            self.UploadBoth=false;
            [self startUploadUserInfoData];
        }
        else
        {
            [self StartUploadImage];
        }
    }
}

-(void)callBackForUserInfoUpload:(NSMutableDictionary*)DictR
{
    NSLog(@"Uploaded User Data");
    
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[DictR objectForKey:@"data"] forKey:@"LastUpdatedUserData"];
        [self StartUploadImage];
    }
}


-(void)callBackForUploadImageFolder:(NSMutableDictionary*)DictR
{
    NSLog(@"Uploaded Images");
    
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"UploadingStatus"];
        NSLog(@"SuccessFully Uploaded Images");
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

- (NSString *)MD5String : (NSString *)Str
{
    const char *cstr = [Str UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

- (NSInteger)validateString:(NSString *)string withPattern:(NSString *)pattern
{    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = NO;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;
    
    //return didValidate;
    
    if (didValidate)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

@end

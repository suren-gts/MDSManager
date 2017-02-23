//
//  MenuScreen.m
//  BabyNursingApp
//
//  Created by Madhusudan  on 24/06/15.
//  Copyright (c) 2015 Madhusudan. All rights reserved.
//

#import "MenuScreen.h"
#import "MenuscreenCell.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "MenuHomeScreenVC.h"
#import "MenuProfileScreenVC.h"
#import "SettingsScreenVC.h"
#import "HelpScreenVC.h"
#import "PrivacyPolicyVC.h"
#import "MessagesVC.h"


#import "UnirestAsyncApi.h"
#import "ZipArchive.h"

#import "MBProgressHUD.h"


#define googleClientId @"803116412282-hah5o9em1lsnrjrprn6cjqj4hpglu4ho.apps.googleusercontent.com"
#define googleClientSecret @""


#define downloadConfirmAlertTag 501

#define AlertConfirmLogin       601

@interface MenuScreen ()

@end

@implementation MenuScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!(App_Delegate.ScreenOpened == 2 ))
    {
        App_Delegate.ScreenOpened=1;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    self.view.frame=CGRectMake(0, 0, App_Delegate.window.frame.size.width, App_Delegate.window.frame.size.height);
    
    DLog(@"View frame: %@",NSStringFromCGRect(self.view.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
 
#pragma mark------
#pragma mark------table view DataSource and Delegate Method
#pragma mark------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuscreenCell *cellSocial = (MenuscreenCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuscreenCell"];
    cellSocial.backgroundColor=[UIColor clearColor];
    cellSocial.selectionStyle=UITableViewCellSelectionStyleNone;
    if(cellSocial == nil)
    {
        cellSocial = [[[NSBundle mainBundle]loadNibNamed:@"MenuscreenCell" owner:nil options:nil] objectAtIndex:0];
        cellSocial.selectionStyle = UITableViewCellSelectionStyleNone;
        cellSocial.lblTitle.text=@"";
        //Change FontFamily
        [cellSocial.lblTitle setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0f]];
    }
    
    switch (indexPath.row)
    {
        case MenuHomeScreen-1:
            cellSocial.lblTitle.text=@"Home";
            if (indexPath.row+1==App_Delegate.ScreenOpened)
            {
                cellSocial.lblTitle.textColor=[UIColor colorWithRed:210.0/255.0 green:229.0/255.0 blue:245.0/255.0 alpha:1.0];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_home_touch.png"]];
            }
            else
            {
                cellSocial.lblTitle.textColor=[UIColor darkGrayColor];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_home_normal.png"]];
            }
            break;
        case MenuMessageScreen-1:
            cellSocial.lblTitle.text=@"Messages";
            if (indexPath.row+1==App_Delegate.ScreenOpened)
            {
                cellSocial.lblTitle.textColor=[UIColor colorWithRed:210.0/255.0 green:229.0/255.0 blue:245.0/255.0 alpha:1.0];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_message_touch.png"]];
            }
            else
            {
                cellSocial.lblTitle.textColor=[UIColor darkGrayColor];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_message_normal.png"]];
            }
            
            break;

        case MenuSettingScreen-1:
            cellSocial.lblTitle.text=@"Settings";
            if (indexPath.row+1==App_Delegate.ScreenOpened)
            {
                cellSocial.lblTitle.textColor=[UIColor colorWithRed:210.0/255.0 green:229.0/255.0 blue:245.0/255.0 alpha:1.0];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_settings_touch.png"]];
            }
            else
            {
                cellSocial.lblTitle.textColor=[UIColor darkGrayColor];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_settings_normal.png"]];
            }
         
            break;
        
        case MenuHelpScreen-1:
            cellSocial.lblTitle.text=@"Contact Us";
            
            if (indexPath.row+1==App_Delegate.ScreenOpened)
            {
                cellSocial.lblTitle.textColor=[UIColor colorWithRed:210.0/255.0 green:229.0/255.0 blue:245.0/255.0 alpha:1.0];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_help_touch.png"]];
            }
            else
            {
                cellSocial.lblTitle.textColor=[UIColor darkGrayColor];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_help_normal.png"]];
            }

             break;

        case MenuPrivecyScreen-1:
            cellSocial.lblTitle.text=@"Privacy Policy";
            if (indexPath.row+1==App_Delegate.ScreenOpened)
            {
                cellSocial.lblTitle.textColor=[UIColor colorWithRed:210.0/255.0 green:229.0/255.0 blue:245.0/255.0 alpha:1.0];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_privacy_touch.png"]];
            }
            else
            {
                cellSocial.lblTitle.textColor=[UIColor darkGrayColor];
                [cellSocial.imgIconView setImage:[UIImage imageNamed:@"icn_privacy_normal.png"]];
            }
             break;
          
        default:
            break;
    }
    
    if (indexPath.row+1==App_Delegate.ScreenOpened)
    {
        [cellSocial.imgSide setHidden:NO];
    }
    else
    {
        [cellSocial.imgSide setHidden:YES];
        cellSocial.backgroundColor=[UIColor clearColor];
    }
    return cellSocial;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *objStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row+1 == MenuHomeScreen)
    {
        MenuHomeScreenVC *objHome =[objStory instantiateViewControllerWithIdentifier:@"MenuHomeScreenVC"];
        NSArray *controllers = [NSArray arrayWithObject:objHome];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if (indexPath.row+1 == MenuMessageScreen)
    {
        MessagesVC *objSettigns =[objStory instantiateViewControllerWithIdentifier:@"MessagesVC"];
        NSArray *controllers = [NSArray arrayWithObject:objSettigns];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if(indexPath.row+1 == MenuSettingScreen)
    {
        SettingsScreenVC *objSettigns =[objStory instantiateViewControllerWithIdentifier:@"SettingsScreenVC"];
        NSArray *controllers = [NSArray arrayWithObject:objSettigns];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if(indexPath.row+1 == MenuHelpScreen)
    {
        HelpScreenVC *objSettigns =[objStory instantiateViewControllerWithIdentifier:@"HelpScreenVC"];
        NSArray *controllers = [NSArray arrayWithObject:objSettigns];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if(indexPath.row+1 == MenuPrivecyScreen)
    {
        PrivacyPolicyVC *objSettigns =[objStory instantiateViewControllerWithIdentifier:@"PrivacyPolicyVC"];
        NSArray *controllers = [NSArray arrayWithObject:objSettigns];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    
    App_Delegate.ScreenOpened=(MenuCurrentScreen)indexPath.row+1;
    [tblMenu reloadData];
}

#pragma mark - 
#pragma mark - Alertview Delagate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == downloadConfirmAlertTag)
    {
        
        if (buttonIndex==1)
        {
            [self clickOnDownloadData:nil];
        }
    }
}


#pragma mark - 
#pragma mark - Download Methods

-(IBAction)clickOnDownloadData:(id)sender
{
    [self DownloadMainDB];
}

-(void)DownloadMainDB
{
    [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
    
    App_Delegate.DownloadingElement=@"MainDB";

    NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
    NSString *strEmail = [dictValue valueForKey:@"email"];
    
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    
    strEmail = [App_Delegate MD5String:strEmail];

    [Dic setValue:strEmail forKey:@"user_id"];
    
    
    [UnirestAsyncApi callPostAsyncAPI:@"get_db_backup.php" withParameter:Dic selector:@selector(callBackForDownloadSqlite:) toTarget:self showHUD:YES];
}

-(void)DownloadUserInfoDB
{
    App_Delegate.DownloadingElement=@"UserDB";

    NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
    NSString *strEmail = [dictValue valueForKey:@"email"];
    
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    
    strEmail = [App_Delegate MD5String:strEmail];

    [Dic setValue:strEmail forKey:@"email"];
   
    [UnirestAsyncApi callPostAsyncAPI:@"get_user_info_sqlite_1.php" withParameter:Dic selector:@selector(callBackForDownloadUserInfoSqlite:) toTarget:self showHUD:YES];
}

-(void)DownloadImages
{
    App_Delegate.DownloadingElement=@"ImageDownload";

    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    
    NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
    NSString *strEmail = [dictValue valueForKey:@"email"];
    
    strEmail = [App_Delegate MD5String:strEmail];

    
    [Dic setValue:strEmail forKey:@"user_id"];
    
    [UnirestAsyncApi callPostAsyncAPI:@"get_images_zip.php" withParameter:Dic selector:@selector(callBackForDownloadImageFolderUserInfo:) toTarget:self showHUD:YES];
}


-(void)callBackForDownloadSqlite:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        NSString *strEmail = [dictValue valueForKey:@"email"];
    
        NSString *strUrl =[DictR valueForKey:@"data"];
        
        dataUrl = [[NSMutableData alloc]init];
            
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else
    {
        [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"])
        {
            
            NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            
            NSString *strEmail = [dictValue valueForKey:@"email"];
            
            strEmail = [App_Delegate MD5String:strEmail];
            
            [dic setObject:strEmail forKey:@"email"];
            
            [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"user_info_sqlite_updatedon.php" withParameter:dic selector:@selector(callBackTestUploadOnUserDB:) toTarget:self];
        }
    }
}

-(void)callBackForDownloadUserInfoSqlite:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
        NSString *strEmail = [dictValue valueForKey:@"email"];
        
        NSString *strUrl =[DictR valueForKey:@"data"];
        
        dataUrl = [[NSMutableData alloc]init];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        [NSURLConnection connectionWithRequest:request delegate:self];
        
    }
    else
    {
        [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
    }
}


-(void)callBackForDownloadImageFolderUserInfo:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        NSString *strUrl =[DictR valueForKey:@"data"];
        
        dataUrl = [[NSMutableData alloc]init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else
    {
        [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([App_Delegate.DownloadingElement isEqualToString:@"MainDB"])
    {
        if ( dataUrl )
        {
            NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
            NSString *strEmail = [dictValue valueForKey:@"email"];
            strEmail = [App_Delegate MD5String:strEmail];

            
            // to remove same zip
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePathZipToRemove = [documentsPath stringByAppendingPathComponent:@"MDSManagerDB.sqlite"];
            NSError *error;
            BOOL success = [fileManager removeItemAtPath:filePathZipToRemove error:&error];
            

            NSLog(@"Main data DOwnloaded");
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"MDSManagerDB.zip"];
            NSString  *filePathSql = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"MDSManagerDBsqlite"];

            [dataUrl writeToFile:filePath atomically:YES];
            
            ZipArchive *za = [[ZipArchive alloc] init];
            
            if ([za UnzipOpenFile: filePath])
            {
                
                BOOL ret = [za UnzipFileTo:filePathSql overWrite: YES];
                if (ret == YES)
                {
                    [za UnzipCloseFile];
                    
                }
            }

            filePathSql = [filePathSql stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",strEmail]];
            
            [fileManager copyItemAtPath:filePathSql toPath:filePathZipToRemove error:&error];

            
            App_Delegate.dBPath=filePathZipToRemove;
            NSLog(@"DBPath:%@",App_Delegate.dBPath);
            App_Delegate.dbObj=[[DBFile alloc] initWith];
            
            [self updateLocalKey:@"Main"];
            
            [self DownloadUserInfoDB];
        }
    }
    else if([App_Delegate.DownloadingElement isEqualToString:@"UserDB"])
    {
        if ( dataUrl )
        {
            NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
            NSString *strEmail = [dictValue valueForKey:@"email"];
            
            strEmail = [App_Delegate MD5String:strEmail];

            NSLog(@"User data DOwnloaded");
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            
            // to remove same zip
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePathZipToRemove = [documentsPath stringByAppendingPathComponent:@"MDSManager_UserInfo_DB.sqlite"];
            NSError *error;
            BOOL success = [fileManager removeItemAtPath:filePathZipToRemove error:&error];
            
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"MDSManager_UserInfo_DB.zip"];
            NSString  *filePathSql = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"MDSManager_UserInfo_DBsqlite"];
            
            [dataUrl writeToFile:filePath atomically:YES];
            
            ZipArchive *za = [[ZipArchive alloc] init];
            
            if ([za UnzipOpenFile: filePath])
            {
                BOOL ret = [za UnzipFileTo:filePathSql overWrite: YES];
                if (ret == YES)
                {
                    [za UnzipCloseFile];
                    
                }
            }
            
             filePathSql = [filePathSql stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",strEmail]];
            [fileManager copyItemAtPath:filePathSql toPath:filePathZipToRemove error:&error];

            App_Delegate.dBPath_userInfo=filePathZipToRemove;
            NSLog(@"DBPath:%@",App_Delegate.dBPath_userInfo);
            App_Delegate.dbObjUserInfo=[[DBUserInfoFile alloc] initWith];
            
            
            [self updateLocalKey:@"User"];
            
            [self DownloadImages];
        }
    }
    else if ([App_Delegate.DownloadingElement isEqualToString:@"ImageDownload"])
    {
        if ( dataUrl )
        {
            NSLog(@"Images DOwnloaded");

            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"MyImages.zip"];
            [dataUrl writeToFile:filePath atomically:YES];
            
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
            
            folderPath = [folderPath stringByAppendingPathComponent:@"UserImage.png"];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath];
            
            if (fileExists)
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"UserImage.png" forKey:@"userImage" ];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
        }
        UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"MDS Manager\u2122" message:@"Data downloaded successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altView show];
        
        [MBProgressHUD hideAllHUDsForView:App_Delegate.window animated:YES];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        NSString *strTimeinterval = [dateFormatter stringFromDate:[NSDate date]];
        
        [[NSUserDefaults standardUserDefaults]setObject:strTimeinterval forKey:@"LastUpdateDownloaded"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataUrl appendData:data];
}

-(void)updateLocalKey : (NSString *)strDBType
{
    NSDictionary *dictValue =[[NSUserDefaults standardUserDefaults]objectForKey:@"UserGoogleInfo"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *strEmail = [dictValue valueForKey:@"email"];

    strEmail = [App_Delegate MD5String:strEmail];

    if ([strDBType isEqualToString:@"User"])
    {
        [dic setObject:strEmail forKey:@"email"];
        
        [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"user_info_sqlite_updatedon.php" withParameter:dic selector:@selector(callBackUpdateOnUserDB:) toTarget:self];
    }
    else if ([strDBType isEqualToString:@"Main"])
    {
        [dic setObject:strEmail forKey:@"user_id"];
        [UnirestAsyncApi callPostAsyncAPIForAppDelegate:@"backup_updatedon.php" withParameter:dic selector:@selector(callBackUpdatedOnMainDB:) toTarget:self];
    }
        
}


-(void)callBackUpdatedOnMainDB:(NSMutableDictionary*)DictR
{
    
    NSLog(@"Uploaded Main Data");
    
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[DictR objectForKey:@"data"] forKey:@"LastUpdatedMainData"];
    }
}

-(void)callBackUpdateOnUserDB:(NSMutableDictionary*)DictR
{
    NSLog(@"Uploaded User Data");
    
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[DictR objectForKey:@"data"] forKey:@"LastUpdatedUserData"];
    }
}

-(void)callBackTestUploadOnUserDB :(NSMutableDictionary*)DictRes
{
    if (DictRes)
    {
        int status=[[DictRes valueForKey:@"status"] intValue];
        if (status==1)
        {
            NSString *strResData = [DictRes objectForKey:@"data"];
            
            if (strResData.length>0)
            {
                [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
                [self DownloadUserInfoDB];
            }
        }
    }
}



- (void) dealloc
{
    tblMenu.delegate=nil;
    tblMenu.dataSource=nil;
}

@end

//
//  AppDelegate.h
//  MyMDSManager
//
//  Created by CEPL on 03/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonObject.h"
#import "DBFile.h"
#import "DBUserInfoFile.h"

#import "DisclaimerVC.h"

#import <AVFoundation/AVFoundation.h>

#import <CommonCrypto/CommonDigest.h>


#import "MenuScreen.h"
#import "MFSideMenuContainerViewController.h"

//#import <GooglePlus/GooglePlus.h>
typedef enum _MenuCurrentScreen
{
    MenuHomeScreen = 1,
    MenuMessageScreen = 2,
    MenuSettingScreen = 3,
    MenuHelpScreen = 4,
    MenuPrivecyScreen = 5,
    MenuDownloaddataScreen = 6,
} MenuCurrentScreen;


@interface AppDelegate : UIResponder <UIApplicationDelegate , UIAlertViewDelegate>
{
    NSString *dBName;
    NSString *dBNameUseInfo;
    
    DisclaimerVC *objDis;
    
    MFSideMenuContainerViewController *container;
}


@property(nonatomic,strong)  AVAudioPlayer *AudioPlayer;

@property BOOL isPushNotificationOn;
@property BOOL isCalenderNotificationOn;

@property (strong, nonatomic) NSString *deviceTokenValue;

@property (nonatomic,retain) NSString *strProviderForDiagnosis;

//***** sqlite...
@property (nonatomic, strong) DBFile * dbObj;
@property (nonatomic, retain) NSString *dBPath;
- (NSString *)getDBPath :(NSString *)filename;
-(void) copyDatabaseFromApplicationBundelIfNeeded;

//***** sqlite...
@property (nonatomic, strong) DBUserInfoFile * dbObjUserInfo;
@property (nonatomic, retain) NSString *dBPath_userInfo;
-(void) copyDatabaseFromApplicationBundelIfNeededUserInfo;


@property (strong,nonatomic) PersonObject *objAppPerson;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nvgController;
@property MenuCurrentScreen ScreenOpened;


@property BOOL reminderSwitch;
@property (nonatomic,retain) NSMutableDictionary *dictReminder;
@property (nonatomic,strong)NSString *strReminderString;

@property (nonatomic,retain) NSMutableDictionary *dictTest;
@property (nonatomic,retain) NSMutableDictionary *dictNormal;
@property (nonatomic,retain) NSMutableArray *arrTreatementMedicine;

@property (nonatomic,retain) NSMutableArray *arrMDSTreatement;

@property (nonatomic,strong)NSString *strSymptomCat;

@property (nonatomic,retain) NSMutableDictionary *dictPrePopulated;
@property (strong, nonatomic) NSArray *arrSoundFiles;

@property (nonatomic,retain) NSMutableArray *arrCountryPhoneCode;

@property BOOL isNewAddedInList;
@property BOOL showFirstTimeInfo;


-(void)startUploadData;
-(void)startUploadUserInfoData;

-(void)CheckBeforeUploadMainDB;
-(void)CheckBeforeUploadUserDB;

-(void)TestBeforeDownload;


@property BOOL unitLoaded;
@property int weightLimit;

- (NSString *)MD5String : (NSString *)Str;

- (NSInteger)validateString:(NSString *)string withPattern:(NSString *)pattern;


@property (nonatomic, strong) NSString * DownloadingElement;
@property  BOOL * UploadBoth;



@end






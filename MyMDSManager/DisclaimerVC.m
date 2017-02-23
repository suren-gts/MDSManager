
//  DisclaimerVC.m
//  MyMDSManager

//  Created by CEPL on 11/09/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "DisclaimerVC.h"
#import "MenuScreen.h"
#import "MFSideMenuContainerViewController.h"
#import "MenuHomeScreenVC.h"
#import "DBFile.h"
#import "UnirestAsyncApi.h"


@interface DisclaimerVC ()

@end

@implementation DisclaimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDisclaimer];
}

-(void)loadDisclaimer
{
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    NSString *strLastUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdated"];
    if (strLastUpdated)
    {
        [Dic setObject:strLastUpdated forKey:@"lastUpdatedOn"];
    }
    
    [UnirestAsyncApi callPostAsyncAPI:@"disclaimer.php" withParameter:Dic selector:@selector(callBackForAdminData:) toTarget:self showHUD:YES];
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

        [webView loadHTMLString:disclamer baseURL:nil];
    }
    else
    {
        disclamer = [[NSUserDefaults standardUserDefaults] objectForKey:@"PrivacyPolicyText"];
         [webView loadHTMLString:disclamer baseURL:nil];
    }
}

-(IBAction)clickOnAccept:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Accepted"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    MenuScreen *leftMenuViewController = [[MenuScreen alloc] init];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationController]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    
    
    container.menuWidth=190;
    App_Delegate.window.rootViewController = container;
}

-(IBAction)clickOnDecline:(id)sender
{
      [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"IsUpdated"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    exit(1);
}

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

-(void)loadWebView
{
    NSURL * resourcePathURL = [[NSBundle mainBundle] resourceURL];
    if(resourcePathURL)
    {
        NSURL * urlToLoad = [resourcePathURL URLByAppendingPathComponent: @"MDSPrivacyPolicy.html"];
        if(urlToLoad)
        {
            NSURLRequest * req = [NSURLRequest requestWithURL: urlToLoad];
            [webView loadRequest: req];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

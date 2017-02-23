//
//  PrivacyPolicyVC.m
//  MyMDSManager
//
//  Created by CEPL on 03/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "PrivacyPolicyVC.h"

@interface PrivacyPolicyVC ()

@end

@implementation PrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
    // Do any additional setup after loading the view.
}
- (IBAction)BtnMenu:(UIButton*)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
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
            
            NSString  *disclamer = [[NSUserDefaults standardUserDefaults] objectForKey:@"PrivacyPolicyText"];
             [webView loadHTMLString:disclamer baseURL:nil];
          //  [webView loadRequest: req];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

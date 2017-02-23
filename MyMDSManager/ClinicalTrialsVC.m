//
//  ClinicalTrialsVC.m
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "ClinicalTrialsVC.h"

@interface ClinicalTrialsVC ()

@end

@implementation ClinicalTrialsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self laodWebView];
    
}
#pragma mark - Function Methods

-(IBAction)clickOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)laodWebView
{
    activityIndicator.hidden=NO;
    [activityIndicator startAnimating];

    NSString *urlAddress = @"http://www.mds-foundation.org/mds_manager/api/clinical-trial-api/";
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
}

#pragma mark UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"There might be a problem in data loading, Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
    [alt show];
    
}

- (void) dealloc
{
    webView.delegate=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

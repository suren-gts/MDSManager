//
//  AdditionalResourcesVC.m
//  MyMDSManager
//
//  Created by CEPL on 01/09/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "AdditionalResourcesVC.h"
#import "UnirestAsyncApi.h"

@interface AdditionalResourcesVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;

@end

@implementation AdditionalResourcesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadResourcesData];
}

-(IBAction)clickOnBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadResourcesData
{
    activityIndicator.hidden=NO;
    [activityIndicator startAnimating];

    NSString *urlAddress = @"http://www.mds-foundation.org/patient-caregiver-resources-api/";
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

//
//  HelpScreenVC.m
//  MyMDSManager
//
//  Created by CEPL on 28/08/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "HelpScreenVC.h"
#import "UnirestAsyncApi.h"

@interface HelpScreenVC ()

@end

@implementation HelpScreenVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 425);
    
    [lblAddress setFont:[UIFont fontWithName:@"Oswald-Regular" size:18.0f]];
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"ContactInfo"];
  //  [self setContactInfo:dict];
    
    
    [self getContactDetail ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - Get Contact Detail


-(void)getContactDetail
{
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ContactInfo"])
    {
        [UnirestAsyncApi callPostAsyncAPI:@"contact_us.php" withParameter:dict selector:@selector(callBackContact:) toTarget:self showHUD:NO];
    }
    else
    {
        [UnirestAsyncApi callPostAsyncAPI:@"contact_us.php" withParameter:dict selector:@selector(callBackContact:) toTarget:self showHUD:YES];
    }
}

#pragma mark - 
#pragma mark - Call Back Method

-(void)callBackContact:(NSMutableDictionary *)dicRespo
{
    NSString *strStatus       = [dicRespo objectForKey:@"status"];
    if ([strStatus integerValue] ==1)
    {
        [self setContactInfo:dicRespo];
        [[NSUserDefaults standardUserDefaults] objectForKey:@"ContactInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"ContactInfo"];
        [self setContactInfo:dict];
    }
}

-(void)setContactInfo:(NSDictionary *)dicRespo
{
    NSString *strPhoneOutSide = [dicRespo objectForKey:@"phone_outside_us"];
    NSString *strPhoneUs      = [dicRespo objectForKey:@"phone_us"];
    NSString *strFax          = [dicRespo objectForKey:@"fax"];
    NSString *strEmail        = [dicRespo objectForKey:@"email"];
    NSString *strAddress      = [dicRespo objectForKey:@"address"];
    

    
    [btnFax setTitle:strFax forState:UIControlStateNormal];
    [btnEmail setTitle:strEmail forState:UIControlStateNormal];
    [btnPhoneInUS setTitle:strPhoneUs forState:UIControlStateNormal];
    [btnPhoneOutUS setTitle:strPhoneOutSide forState:UIControlStateNormal];
    [lblAddress setText:strAddress];
    
    NSString *str = [dicRespo objectForKey:@"detail"];
    
    [webContact loadHTMLString:str baseURL:nil];
    
}

#pragma mark -
#pragma mark - Webview Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType *)navigationType
{
    
    requestedPath=request;
    NSString *requestPath = [[request URL] absoluteString];
    NSLog(@"RequestPath: %@",requestPath);
    arrRequest =[requestPath componentsSeparatedByString:@"/"];
    
    if([requestPath containsString:@"about:blank"])
    {
        return YES;
    }
    
    NSString *str = arrRequest[2];
    
    if ([str containsString:@"@"])
    {
        [btnEmail setTitle:str forState:UIControlStateNormal];
        [self didSelectMail:btnEmail];
        
        return NO;
    }
    else  if ([[str lowercaseString] containsString:@"mds"])
    {
         [btnPhoneInUS setTitle:str forState:UIControlStateNormal];
        [self didSelectPhoneInUS:btnPhoneInUS];
        
        return NO;
    }
    else
    {
         [btnPhoneOutUS setTitle:str forState:UIControlStateNormal];
        [self didSelectPhoneOutUS:btnPhoneOutUS];
        
        return NO;

    }
    
    
   return YES;
}



#pragma mark -
#pragma mark - IBAction Method

- (IBAction)BtnMenu:(UIButton*)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)didSelectPhoneInUS:(UIButton *)sender
{
   NSString *strPhone = [NSString stringWithFormat:@"tel:%@",sender.titleLabel.text];
   NSString * str = [strPhone stringByReplacingOccurrencesOfString:@"MDS"
                                         withString:@"637"];
    //    1-800-MDS-0839
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)didSelectPhoneOutUS:(UIButton *)sender
{
     NSString *strPhone = [NSString stringWithFormat:@"tel:%@",sender.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
}

- (IBAction)didSelectMail:(UIButton *)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[sender.titleLabel.text]];
        [composeViewController setMessageBody:@" " isHTML:NO];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *altView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please configure mail before sending a mail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altView show];
        
    }
}

#pragma mark -
#pragma mark - Mailcomposer delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end


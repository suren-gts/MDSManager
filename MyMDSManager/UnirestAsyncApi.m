//
//  UnirestAsyncApi.m
//  Telito
//
//  Created by shashi on 26/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import "UnirestAsyncApi.h"
#import "UNIRest.h"
#import "MBProgressHUD.h"
#import  "JSON.h"


//http://tagsinfosoft.com/demo/mds_tracker/api/diagnosis_test.php
//#define mainUrl   @"http://tagsinfosoft.com/demo/mds_tracker/api/"
//#define mainUrl @"http://mds.devsiteurl.com/mds_tracker/api/"
#define mainUrl @"http://www.mds-foundation.org/mds_manager/api/"

@implementation UnirestAsyncApi

+(void)callPostAsyncAPI:(NSString *)strPageName withParameter:(NSMutableDictionary *)params selector:(SEL)selector toTarget:(UIViewController *)target showHUD:(BOOL)showHUD
{
    
    if (showHUD)
    {
        [MBProgressHUD showHUDAddedTo:target.view animated:YES];
    }
    
    [[UNIRest post:^(UNISimpleRequest* request)
    {
        [request setUrl:[NSString stringWithFormat:@"%@%@",mainUrl,strPageName]];
        [request setParameters:params];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error)
    {
        // This is the asyncronous callback block
        // UNIJsonNode* body = [response body];
        if (error)
        {
            NSLog(@"error Code:%@",error);
            
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                //Show alert here
                [altView show];
            });
            if (showHUD)
            {
                [MBProgressHUD hideAllHUDsForView:target.view animated:YES];
            }
         //   return ;
            
        }
        else
        {
            NSString * strResponse = [[NSString alloc] initWithData:[response rawBody] encoding:NSUTF8StringEncoding];
            //  dictResponse = [body JSONObject];
            NSLog(@"Response string%@",strResponse);
            NSMutableDictionary *dictResponse;
            
            if ([strResponse isEqualToString:@""])
            {
                dictResponse=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"3",@"status",@"Network Error",@"message",nil];
            }
            else
            {
                dictResponse= [strResponse JSONValue];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // update UI in main thread.
                if ([target respondsToSelector:selector])
                {
                    [target performSelectorOnMainThread:selector withObject:dictResponse waitUntilDone:NO];
                }
                if (showHUD)
                {
                    [MBProgressHUD hideAllHUDsForView:target.view animated:YES];
                }
            });
        }
       
    }];
}
+(void)callPostAsyncAPIForAppDelegate:(NSString *)strPageName withParameter:(NSMutableDictionary *)params selector:(SEL)selector toTarget:(AppDelegate *)target
{
    
    [[UNIRest post:^(UNISimpleRequest* request) {
        [request setUrl:[NSString stringWithFormat:@"%@%@",mainUrl,strPageName]];
        [request setParameters:params];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error)
     {
         // This is the asyncronous callback block
         // UNIJsonNode* body = [response body];
         if (error)
         {
             NSLog(@"error Code:%@",error);
             
             UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 //Show alert here
                 [altView show];
             });
            
             //   return ;
             
         }
         else
             
         {
             NSString * strResponse = [[NSString alloc] initWithData:[response rawBody] encoding:NSUTF8StringEncoding];
             //  dictResponse = [body JSONObject];
             NSLog(@"Response string%@",strResponse);
             NSMutableDictionary *dictResponse;
             
             if ([strResponse isEqualToString:@""])
             {
                 dictResponse=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"3",@"status",@"Network Error",@"message",nil];
             }
             else
             {
                 dictResponse= [strResponse JSONValue];
             }
             
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 // update UI in main thread.
                 if ([target respondsToSelector:selector])
                 {
                     [target performSelectorOnMainThread:selector withObject:dictResponse waitUntilDone:NO];
                 }
             });
         }
         
     }];
}



+(void)callPostAsyncAPI:(NSString *)strPageName withParameter:(NSMutableDictionary *)params selector:(SEL)selector toTarget:(UIViewController *)target showHUD:(BOOL)showHUD withLocalOfflineKey:(NSString *)strKey
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:strKey])
    {
        NSString *strSavedResponse = [[NSUserDefaults standardUserDefaults] objectForKey:strKey];
        NSMutableDictionary *dictResponse= [strSavedResponse JSONValue];
        if ([target respondsToSelector:selector])
        {
            [target performSelectorOnMainThread:selector withObject:dictResponse waitUntilDone:NO];
        }
    }
    else
    {
        if (showHUD)
        {
            [MBProgressHUD showHUDAddedTo:target.view animated:YES];
        }
    }
    [[UNIRest post:^(UNISimpleRequest* request)
    {
        [request setUrl:[NSString stringWithFormat:@"%@%@",mainUrl,strPageName]];
        [request setParameters:params];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        // This is the asyncronous callback block
        NSString * strResponse = [[NSString alloc] initWithData:[response rawBody] encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dictResponse= [strResponse JSONValue];
        if (dictResponse)
        {
            [[NSUserDefaults standardUserDefaults] setObject:strResponse forKey:strKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI in main thread.
            if ([target respondsToSelector:selector])
            {
                [target performSelectorOnMainThread:selector withObject:dictResponse waitUntilDone:NO];
            }
            if (showHUD)
            {
                [MBProgressHUD hideAllHUDsForView:target.view animated:YES];
            }
        });
    }];
    
}

@end

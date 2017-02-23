//
//  UnirestAsyncApi.h
//  Telito
//
//  Created by shashi on 26/11/14.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import"JSON.h"

@interface UnirestAsyncApi : NSObject


+(void)callPostAsyncAPI:(NSString *)strPageName withParameter:(NSDictionary *)params selector:(SEL)selector toTarget:(UIViewController *)target showHUD:(BOOL)showHUD;
+(void)callPostAsyncAPIForAppDelegate:(NSString *)strPageName withParameter:(NSMutableDictionary *)params selector:(SEL)selector toTarget:(AppDelegate *)target;
@end

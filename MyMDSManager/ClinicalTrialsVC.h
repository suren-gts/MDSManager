//
//  ClinicalTrialsVC.h
//  MyMDSManager
//
//  Created by CEPL on 16/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClinicalTrialsVC : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
@end

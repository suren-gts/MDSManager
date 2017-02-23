//
//  MenuScreen.h
//  BabyNursingApp
//
//  Created by Madhusudan  on 24/06/15.
//  Copyright (c) 2015 Madhusudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuScreen : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate>
{

    IBOutlet UITableView * tblMenu;
    UINavigationController *nav;
    
    
    NSMutableData *dataUrl;
    
}
-(void)DownloadMainDB;
-(void)DownloadUserInfoDB;

@end

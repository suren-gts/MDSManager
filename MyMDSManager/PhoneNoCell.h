//
//  PhoneNoCell.h
//  MyMDSManager
//
//  Created by CEPL on 28/12/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneNoCell : UITableViewCell
{
    
}
@property(nonatomic,retain) IBOutlet UILabel *lblTitle;
@property(nonatomic,retain) IBOutlet UIButton *btnCountryCode;
@property(nonatomic,retain) IBOutlet UILabel *lblValue;
@property(nonatomic,retain) IBOutlet UITextField *txtField;
@property(nonatomic,retain) IBOutlet UIImageView *imgSeperator;
@end

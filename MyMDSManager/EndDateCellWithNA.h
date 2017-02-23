//
//  EndDateCellWithNA.h
//  MyMDSManager
//
//  Created by CEPL on 27/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndDateCellWithNA : UITableViewCell

@property(nonatomic,retain) IBOutlet UILabel *lblTitle;
@property(nonatomic,retain) IBOutlet UILabel *lblValue;
@property(nonatomic,retain) IBOutlet UITextField *txtField;
@property(nonatomic,retain) IBOutlet UILabel *lblNA;
@property(nonatomic,retain) IBOutlet UIButton *btnNA;
@property(nonatomic,retain) IBOutlet UIImageView *imgSeperator;

@end

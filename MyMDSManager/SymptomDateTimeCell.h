//
//  SymptomDateTimeCell.h
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SymptomDateTimeCell : UITableViewCell

@property (nonatomic,retain)IBOutlet UITextField *txtDate;
@property (nonatomic,retain)IBOutlet UITextField *txtTime;
@property (nonatomic,retain)IBOutlet UIButton *btnDate;
@property (nonatomic,retain)IBOutlet UIButton *btnTime;
@end

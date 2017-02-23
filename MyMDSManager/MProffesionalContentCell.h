//
//  MProffesionalContentCell.h
//  MyMDSManager
//
//  Created by CEPL on 23/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MProffesionalContentCell : UITableViewCell

@property (nonatomic,retain)IBOutlet UILabel *lblName;
@property (nonatomic,retain)IBOutlet UILabel *lblSpeciality;
@property (nonatomic,retain)IBOutlet UILabel *lblPhone;

@property (nonatomic,retain)IBOutlet UIButton *btnCallMe;


@end

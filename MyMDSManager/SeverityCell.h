//
//  SeverityCell.h
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeverityCell : UITableViewCell

@property (nonatomic,retain)IBOutlet UISlider *sliderSeverity;
-(void)setupAppearance;
@end


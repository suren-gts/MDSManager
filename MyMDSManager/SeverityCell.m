//
//  SeverityCell.m
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "SeverityCell.h"

@implementation SeverityCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setupAppearance
{
    UIImage *minImage = [UIImage imageNamed:@"img_seekbar2.png"] ;//[[UIImage imageNamed:@"img_seekbar2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *maxImage = [UIImage imageNamed:@"img_seekbar1.png"];//[[UIImage imageNamed:@"img_seekbar1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *thumbImage = [UIImage imageNamed:@"icn_seekbar_symptom-tracker.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

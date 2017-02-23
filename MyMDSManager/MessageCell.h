//
//  MessageCell.h
//  MyMDSManager
//
//  Created by CEPL on 03/09/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic,retain)IBOutlet UILabel *lblMessage;
@property (nonatomic,retain)IBOutlet UILabel *lblDateTime;

@property (strong, nonatomic) IBOutlet UITextView *tvMessage;

@end

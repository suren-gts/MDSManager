//
//  AddNotesCell.h
//  MyMDSManager
//
//  Created by CEPL on 06/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNotesCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UITextView *tvNotes;
@property(nonatomic,retain) IBOutlet UIImageView *imgSeperator;

@end

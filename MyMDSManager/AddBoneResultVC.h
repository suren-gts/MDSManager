//
//  AddBoneResultVC.h
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerVC.h"
#import "ContentPickerVC.h"

@interface AddBoneResultVC : UIViewController<UITextFieldDelegate,ValuePickerDelegate,DatePikerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblPageTitle;
    
    UITextField *txtTemp;
    UITextView *tvTemp;
    ContentPickerVC *objPicker;
    DatePickerVC *objDatePicker;
    BOOL IsUp;
    
    BOOL IsActionSheetVisible;
    
    UIToolbar* numberToolbar;
    NSMutableArray *arrFiles;
    NSMutableArray *arrFullSizeImage;
    NSMutableArray *arrImageName;
    
    UIView *showImageView;
    UIImageView *imgShowMe;
    
    UIImagePickerController *imagePicker;
    
    NSInteger SomeEdit;
}

@property NSInteger entryTag;
@property (nonatomic,retain)NSMutableDictionary *dictBoneMerrow;
@property int editFlag;
@end

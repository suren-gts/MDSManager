//
//  DatePickerVC.m
//  MedicalApp
//
//  Created by CEPL on 06/05/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "DatePickerVC.h"

@interface DatePickerVC ()

@end

@implementation DatePickerVC

@synthesize datePickerDel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    if (self.entryTag==100)
    {
        [datePicker setDatePickerMode:UIDatePickerModeTime];
    }
    else if (self.entryTag==101)
    {
        [datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    else if (self.entryTag==102)
    {
        [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    else
    {
    [datePicker setDatePickerMode:UIDatePickerModeDate];    // Do any additional setup after loading the
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)performDone:(id)sender
{

    if(self.datePickerDel && [(id) self.datePickerDel respondsToSelector:@selector(didSelectDate:)])
    {
        NSDate *date=[datePicker date];
        [self.datePickerDel didSelectDate:date];
    }
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.view removeFromSuperview];
                     }];
}


- (IBAction)performCancel:(id)sender
{  
    if(self.datePickerDel && [(id) self.datePickerDel respondsToSelector:@selector(didCancelPicker)])
    {
        [self.datePickerDel didCancelPicker];
    }
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                            [self.view removeFromSuperview];
                     }];
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

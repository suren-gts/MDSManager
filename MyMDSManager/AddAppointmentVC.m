//
//  AddAppointmentVC.m
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import "AddAppointmentVC.h"
#import "AddNotesCell.h"
#import "ProfileContentDisplayCell.h"
#import "AppointmentButtonCell.h"
#import "PrescribedByCell.h"
#import "AddMediaProfessionalVC.h"

@interface AddAppointmentVC ()

@end

#define AlertConfirmTag 123

@implementation AddAppointmentVC
@synthesize objLocalAppointment,editFlag;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!objLocalAppointment)
    {
        objLocalAppointment=[[AppointementObject alloc]initDefaults];
    }
    //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [tblView reloadData];
}


#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Row in Tableview
    if (indexPath.row==3)
    {
        return 120;
    }
    else if (indexPath.row==2)
    {
        return 130;
    }
    else if (indexPath.row==1)
    {
        return 84;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        static NSString *CellIdentifier = @"AppointmentButtonCell";
        
        AppointmentButtonCell *cell = (AppointmentButtonCell *) [tableView
                                                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AppointmentButtonCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        if (self.editFlag==0)
        {
            [cell.btnAction1 setTitle:@"Save" forState:UIControlStateNormal];
        }
        else
        {
            [cell.btnAction1 setTitle:@"Update" forState:UIControlStateNormal];
        }
        
        [cell.btnAction2 setTitle:@"Export to Device Calendar" forState:UIControlStateNormal];
        
        [cell.btnAction1 addTarget:self action:@selector(clickOnSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnAction2 addTarget:self action:@selector(clickOnExport:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
        
    }
    else if (indexPath.row==2)
    {
        static NSString *CellIdentifier = @"AddNotesCell";
        
        AddNotesCell *cell = (AddNotesCell *) [tableView
                                                   dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddNotesCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.tvNotes.text=objLocalAppointment.strNotes;
        cell.tvNotes.delegate=self;
        cell.tvNotes.inputAccessoryView=numberToolbar;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row==1)
    {
        static NSString *CellIdentifier = @"PrescribedByCell";
        
        PrescribedByCell  *cell = (PrescribedByCell *) [tableView
                                                        dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PrescribedByCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        cell.lblValue.hidden=YES;
        cell.txtField.inputAccessoryView = numberToolbar;
        cell.txtField.delegate=self;
        cell.txtField.hidden=NO;
        cell.txtField.userInteractionEnabled=YES;
        cell.txtField.tag=indexPath.row;
        cell.txtField.superview.tag=indexPath.section;
        cell.btnAddProvider.hidden=NO;
        cell.btnAddProvider.userInteractionEnabled=YES;
        

        cell.lblTitle.text=@"Provider";
        cell.lblValue.text=objLocalAppointment.strProvider;
        cell.txtField.text=objLocalAppointment.strProvider;
        [cell.btnAddProvider addTarget:self action:@selector(clickOnAddContact:) forControlEvents:UIControlEventTouchUpInside];
        
       
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"ProfileContentDisplayCell";
        
        ProfileContentDisplayCell *cell = (ProfileContentDisplayCell *) [tableView
                                                             dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileContentDisplayCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.lblValue.hidden=YES;
        cell.txtField.delegate=self;
        cell.txtField.inputAccessoryView = numberToolbar;
        cell.txtField.tag=indexPath.row;
        
        cell.txtField.superview.tag=indexPath.section;
        cell.lblTitle.text=@"Date & Time *";
        cell.txtField.text=objLocalAppointment.strDateTime;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark Function Methos

-(void)clickOnAddContact:(id)sender
{
    UIStoryboard *objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMediaProfessionalVC *objMedicalScreen=[objStoryboard instantiateViewControllerWithIdentifier:@"AddMediaProfessionalVC"];
    [self.navigationController pushViewController:objMedicalScreen animated:YES];
    
}

-(void)doneWithNumberPad
{
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewDown];
         }
                         completion:^(BOOL finished)
         {}];
    }
}

-(void)clickOnOpenDatePicker:(id)sender
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewDown];
         }
                         completion:^(BOOL finished)
         {}];
    }

    objDatePicker=[[DatePickerVC alloc] initWithNibName:@"DatePickerVC" bundle:nil];
    objDatePicker.datePickerDel=self;
    
    objDatePicker.entryTag=102;
    
    objDatePicker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         objDatePicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         SomeEdit = 1;
                     }
                     completion:^(BOOL finished){
                     }];
    [self.view addSubview:objDatePicker.view];
    
    
}

-(void)didSelectDate:(NSDate *)selectedDate
{
    IsActionSheetVisible=NO;
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"MMM dd yyyy  hh:mm a"];
    objLocalAppointment.dateValue=selectedDate;
    objLocalAppointment.strDateTime=[dateformater stringFromDate:selectedDate];
    
    [tblView reloadData];
}

-(void)clickOnValuePicker:(NSInteger)rowTag withSection:(NSInteger)sectionTag
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
    
    
    if ([App_Delegate.dbObj GetAllMedicalProvidersName].count<=0)
    {
        IsActionSheetVisible=NO;
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Provider list not found! Please add provider." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        altView.tag=105;
        [altView show];
    }
    else
    {
        objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
        objPicker.valueDelegate=self;
        objPicker.rowId=rowTag;
        objPicker.sectionId=sectionTag;
        objPicker.EntryTag=6;
        objPicker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             objPicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                             
                             SomeEdit = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        [self.view addSubview:objPicker.view];
    }
    
    
}


-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger)section andForRow:(NSInteger)row
{
    SomeEdit = 1;
    IsActionSheetVisible=NO;
    
    objLocalAppointment.strProvider=strValue;
    
    [tblView reloadData];
}


-(void)didCancelPicker
{
    IsActionSheetVisible=NO;
}

#pragma mark - Function Methods

-(IBAction)clickOnBack:(id)sender
{
    if (SomeEdit ==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You haven’t saved data yet. Do you really want to cancel the process?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        altView.tag = AlertConfirmTag;
        [altView show];
    }
}

-(void)clickOnSaveButton:(id)sender
{
    [tvTemp resignFirstResponder];
    if (objLocalAppointment.strDateTime.length>0)
    {
       [self saveAppointment];
        if (self.editFlag!=0)
        {
            if (objLocalAppointment.strEventIdentifier.length>0)
            {
                [self MakeOrUpdateEvent];
            }
        }
        
        SomeEdit = 0;
       [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
    }
}


-(void)saveAppointment
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsLatestUpdate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    int rowId;
    if (self.editFlag==0)
    {
        rowId = [App_Delegate.dbObj insertAppointments:objLocalAppointment];
        objLocalAppointment.strId = [NSString stringWithFormat:@"%d",rowId];;
    }
    else
    {
        [App_Delegate.dbObj updateAppointments:objLocalAppointment];
        rowId = [objLocalAppointment.strId intValue];
        [self deleteReminder:rowId];
    }
    [self setReminderForAppointment:rowId];
}

- (IBAction)clickOnExport:(id)sender
{
    [tvTemp resignFirstResponder];

    //if (objLocalAppointment.strDateTime.length>0 && objLocalAppointment.strProvider.length>0)
    if (objLocalAppointment.strDateTime.length>0)
    {
        [self saveAppointment];
        [self MakeOrUpdateEvent];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
    }
    
}

-(void)MakeOrUpdateEvent
{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    
    
    if([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // iOS 6
        [store requestAccessToEntityType:EKEntityTypeEvent
                              completion:^(BOOL granted, NSError *error) {
                                  if (granted)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          if (self.editFlag != 0)
                                          {
                                              if (objLocalAppointment.strEventIdentifier.length>0)
                                              {
                                                  [self deleteEvent:store];
                                              }
                                              
                                          }
                                          
                                          [self createEvent:store];
                                      });
                                  }
                              }];
    }
    else
    {
        // iOS 5
        if (self.editFlag != 0)
        {
            if (objLocalAppointment.strEventIdentifier.length>0)
            {
                [self deleteEvent:store];
            }
        }
        [self createEvent:store];
    }

}

- (void)createEvent:(EKEventStore *)store
{
    EKEvent *event = [EKEvent eventWithEventStore:store];
    event.title = objLocalAppointment.strProvider;
    event.startDate = objLocalAppointment.dateValue;
    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
    event.calendar = [store defaultCalendarForNewEvents];
    event.notes=objLocalAppointment.strNotes;
    NSError *err = nil;
    [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    
    if(err==nil)
    {
        NSString* str = [[NSString alloc] initWithFormat:@"%@", event.eventIdentifier];
        objLocalAppointment.strEventIdentifier = str;
        [App_Delegate.dbObj updateAppointments:objLocalAppointment];
        
        if (self.editFlag==0)
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"MDS Manager\u2122" message:@"Event sucessfully exported!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [altView show];
        }
        
    }
    else
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:err.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [altView show];
        
    }
}

-(void)deleteEvent:(EKEventStore *)store
{
    EKEvent* eventToRemove = [store eventWithIdentifier:objLocalAppointment.strEventIdentifier];
    if (eventToRemove != nil) {
        NSError* error = nil;
        [store removeEvent:eventToRemove span:EKSpanThisEvent error:&error];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==105)   //for Add Provider
    {
        [self clickOnAddContact:nil];
    }
    else if (alertView.tag == AlertConfirmTag)
    {
        if (buttonIndex ==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


//Code for UIlocal notificaion

-(void)setReminderForAppointment:(int)forRowId
{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:objLocalAppointment.strProvider forKey:@"AppointmentWith"];
    [dict setObject:objLocalAppointment.strDateTime forKey:@"ForTime"];
    [dict setObject:[NSString stringWithFormat:@"%d",forRowId] forKey:@"appointmentID"];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody =[NSString stringWithFormat:@"Today you have an appointment with '%@'.",objLocalAppointment.strProvider] ;
    localNotification.userInfo=dict;
    
    localNotification.fireDate =objLocalAppointment.dateValue;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertAction = @"View";
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    localNotification.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
  
    
}

-(void)deleteReminder:(int)appointmentId
{
    //For delete locat notification
    
    UIApplication *app1 = [UIApplication sharedApplication];
    // [app1 cancelAllLocalNotifications];
    NSArray *eventArray = [app1 scheduledLocalNotifications];
    
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        
        
        if ([[userInfoCurrent objectForKey:@"appointmentID"]integerValue] == appointmentId )
        {
            // Cancelling local notification
            [app1 cancelLocalNotification:oneEvent];
            NSLog(@"reminder Delete");
        }
    }
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==0)
    {
        if (IsActionSheetVisible==NO)
        {
            IsActionSheetVisible=YES;
            [self clickOnOpenDatePicker:nil];
        }
        
        return NO;
    }
    else if (textField.tag==1)
    {
        if (IsActionSheetVisible==NO)
        {
            IsActionSheetVisible=YES;
            [self clickOnValuePicker:textField.tag withSection:textField.superview.tag];
        }
        
        return NO;
    }
    return YES;
}



-(void)MoveViewUp
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,-150,self.view.frame.size.width,self.view.frame.size.height)];
}

-(void)MoveViewDown
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}

#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    tvTemp=textView;
    if (self.view.frame.size.height<=568)
    {
        IsUp=YES;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewUp];
         }
                         completion:^(BOOL finished)
         {}];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    objLocalAppointment.strNotes=textView.text;
    if (self.view.frame.size.height<=568)
    {
        IsUp=NO;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self MoveViewDown];
         }
                         completion:^(BOOL finished)
         {}];
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   return YES;
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)range
{
    return YES;
}
- (void) dealloc
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end

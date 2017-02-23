//
//  AddMedicineVC.m
//  MyMDSManager
//
//  Created by CEPL on 08/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "AddMedicineVC.h"
#import "ProfileContentDisplayCell.h"
#import "AddNotesCell.h"
#import "PrescribedByCell.h"
#import "AddMediaProfessionalVC.h"
#import "EndDateCellWithNA.h"
#import "ReminderVC.h"
#import "NSDate-Utilities.h"

@interface AddMedicineVC ()

@end

@implementation AddMedicineVC

@synthesize strActionValue,objLocalMedical,medicineUpdateDelegte;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    isNotApplicable=NO;
    dateformater=[[NSDateFormatter alloc]init];
    if (!objLocalMedical)
    {
        objLocalMedical=[[MedicalObject alloc]initDefaults];
    }
    else
    {
        if (objLocalMedical.strImageName.length>0)
        {
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
            NSString *filePath = [dataPath stringByAppendingPathComponent:objLocalMedical.strImageName];
            [imgMedicine setImage:[UIImage imageWithContentsOfFile:filePath]];
        }
        if ([objLocalMedical.strEndDate isEqualToString:@"N/A"])
        {
            isNotApplicable=YES;
            objLocalMedical.endDate=nil;
        }
        if (objLocalMedical.strStartDate.length<=0)
        {
            objLocalMedical.startDate=nil;
        }
        [self createReminderDataToDisplay];

    }
    if ([objLocalMedical.strReminder isEqualToString:@""])
    {
        objLocalMedical.strReminder=@"Add Reminder";
    }
      //Add done button on keyboard
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    txtTemp.delegate=self;
    tvTemp.delegate=self;
    [self updateSaveOrEditButtonTitle];
    [tblView reloadData];
    // Do any additional setup after loading the view from its nib.
    
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
    return 12;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==101)
    {
        return 44;
    }
    else
    {
        if (indexPath.row==11)
        {
            return 110;
        }
        else if (indexPath.row==10)
        {
            if ([self.strActionValue isEqualToString:@"Edit"] || [self.strActionValue isEqualToString:@"Add"])
            {
                return 84;
            }
            return 44;
        }
        else if (indexPath.row==6)
        {
            if ([self.strActionValue isEqualToString:@"Edit"] || [self.strActionValue isEqualToString:@"Add"])
            {
                return 74;
            }
            return 44;
        }
        return 44;
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //View for Section Header of TableView
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==AddNote)
    {
        static NSString *CellIdentifier = @"AddNotesCell";
        
        AddNotesCell *cell = (AddNotesCell *) [tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddNotesCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        if ([self.strActionValue isEqualToString:@"Edit"] || [self.strActionValue isEqualToString:@"Add"])
        {
            cell.tvNotes.userInteractionEnabled=YES;
        }
        else
        {
            cell.tvNotes.userInteractionEnabled=NO;
        }
        cell.tvNotes.text=objLocalMedical.strNotes;
        cell.tvNotes.delegate=self;
        cell.tvNotes.inputAccessoryView=numberToolbar;
        cell.imgSeperator.hidden=YES;
        
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.row==PrescribeBy)
    {
        static NSString *CellIdentifier = @"PrescribedByCell";
        
        PrescribedByCell  *cell = (PrescribedByCell *) [tableView
                                                        dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PrescribedByCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        cell.imgSeperator.hidden=YES;
        cell.txtField.inputAccessoryView = numberToolbar;
        if ([self.strActionValue isEqualToString:@"Edit"] || [self.strActionValue isEqualToString:@"Add"])
        {
            cell.lblValue.hidden=YES;
            
            cell.txtField.delegate=self;
            cell.txtField.hidden=NO;
            cell.txtField.userInteractionEnabled=YES;
            cell.txtField.tag=indexPath.row;
            cell.txtField.superview.tag=indexPath.section;
            cell.btnAddProvider.hidden=NO;
            cell.btnAddProvider.userInteractionEnabled=YES;
        }
        else
        {
            cell.lblValue.hidden=NO;
            cell.txtField.hidden=YES;
            cell.txtField.userInteractionEnabled=NO;
            cell.btnAddProvider.hidden=YES;
            cell.btnAddProvider.userInteractionEnabled=NO;
        }
        cell.lblTitle.text=@"Prescribed By";
        cell.lblValue.text=objLocalMedical.strPrescribedBy;
        cell.txtField.text=objLocalMedical.strPrescribedBy;
        [cell.btnAddProvider addTarget:self action:@selector(clickOnAddContact:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.row==EndDate)
    {
        static NSString *CellIdentifier = @"EndDateCellWithNA";
        
        EndDateCellWithNA *cell = (EndDateCellWithNA *) [tableView
                                                         dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"EndDateCellWithNA" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        if ([self.strActionValue isEqualToString:@"Edit"] || [self.strActionValue isEqualToString:@"Add"])
        {
            cell.lblValue.hidden=YES;
            
            cell.txtField.delegate=self;
            cell.txtField.hidden=NO;
            cell.txtField.userInteractionEnabled=YES;
            cell.txtField.tag=indexPath.row;
            cell.txtField.superview.tag=indexPath.section;
            cell.btnNA.hidden=NO;
            cell.lblNA.hidden=NO;
            [cell.btnNA addTarget:self action:@selector(clickOnUpdateEnddate:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {
            cell.lblValue.hidden=NO;
            cell.txtField.hidden=YES;
            cell.txtField.userInteractionEnabled=NO;
            cell.btnNA.hidden=YES;
            cell.lblNA.hidden=YES;
        }
        if ([objLocalMedical.strEndDate isEqualToString:@"N/A"])
        {
            [cell.btnNA setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.btnNA setImage:[UIImage imageNamed:@"uncheck_box.png"] forState:UIControlStateNormal];
        }
        cell.lblTitle.text=@"End Date";
        cell.lblValue.text=objLocalMedical.strEndDate;
        cell.txtField.text=objLocalMedical.strEndDate;
        cell.imgSeperator.hidden=YES;
        cell.contentView.backgroundColor=[UIColor clearColor];
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
        if ([self.strActionValue isEqualToString:@"Edit"] || [self.strActionValue isEqualToString:@"Add"])
        {
            cell.lblValue.hidden=YES;
            cell.txtField.delegate=self;
            cell.txtField.hidden=NO;
            cell.txtField.userInteractionEnabled=YES;
            cell.txtField.tag=indexPath.row;
            cell.txtField.superview.tag=indexPath.section;
            cell.txtField.inputAccessoryView=numberToolbar;
        }
        else
        {
            cell.lblValue.hidden=NO;
            cell.txtField.hidden=YES;
            cell.txtField.userInteractionEnabled=NO;
            
        }
        
        if (indexPath.row==DrugName)
        {
            cell.lblTitle.text=@"Drug Name *";
            cell.lblValue.text=objLocalMedical.strDrugName;
            cell.txtField.text=objLocalMedical.strDrugName;
            
            cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

        }
        else if (indexPath.row==GenericName)
        {
            cell.lblTitle.text=@"Generic Name";
            cell.lblValue.text=objLocalMedical.strGenericName;
            cell.txtField.text=objLocalMedical.strGenericName;
            
            cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        }
        else if (indexPath.row==Dosage)
        {
            cell.lblTitle.text=@"Dosage";
            cell.lblValue.text=objLocalMedical.strDosage;
            cell.txtField.text=objLocalMedical.strDosage;

            //cell.txtField.keyboardType=UIKeyboard;
            cell.txtField.tag = Dosage;
            
            cell.txtField.inputAccessoryView=numberToolbar;
            
            cell.txtField.autocapitalizationType = UITextAutocapitalizationTypeSentences;

        }
        else if (indexPath.row==Type)
        {
            cell.lblTitle.text=@"Type *";
            cell.lblValue.text=objLocalMedical.strType;
            cell.txtField.text=objLocalMedical.strType;
        }
        else  if (indexPath.row==Frequency)
        {
            cell.lblTitle.text=@"Frequency";
            cell.lblValue.text=objLocalMedical.strFrequency;
            cell.txtField.text=objLocalMedical.strFrequency;
        }
        else  if (indexPath.row==StartDate)
        {
            cell.lblTitle.text=@"Start Date";
            cell.lblValue.text=objLocalMedical.strStartDate;
            cell.txtField.text=objLocalMedical.strStartDate;
        }
        else  if (indexPath.row==Reminder)
        {
            cell.lblTitle.text=@"Reminder";
            
            if ([App_Delegate.strReminderString isEqualToString:@""])
            {
                cell.lblValue.text=@"Add Reminder";
                cell.txtField.text=@"Add Reminder";;
            }
            else
            {
                cell.lblValue.text=App_Delegate.strReminderString;
                cell.txtField.text=App_Delegate.strReminderString;
            }
        }
        else  if (indexPath.row==RefillDate)
        {
            cell.lblTitle.text=@"Refill Date";
            cell.lblValue.text=objLocalMedical.strRefillDate;
            cell.txtField.text=objLocalMedical.strRefillDate;
        }
        else  if (indexPath.row==RefillFrq)
        {
            cell.lblTitle.text=@"Refill frequency";
            cell.lblValue.text=objLocalMedical.strRefillFrequency;
            cell.txtField.text=objLocalMedical.strRefillFrequency;
        }
        
        cell.imgSeperator.hidden=YES;
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


#pragma mark - Function Methods

-(void)clickOnUpdateEnddate:(id)sender
{
    if (isNotApplicable)
    {
        isNotApplicable=NO;
        if (sender)
        {
            objLocalMedical.strEndDate=@"";
            objLocalMedical.endDate=nil;
        }
    }
    else
    {
        isNotApplicable=YES;
        objLocalMedical.strEndDate=@"N/A";
        objLocalMedical.endDate=nil;
    }
    [tblView reloadData];
}


-(void)updateSaveOrEditButtonTitle
{
    if ([self.strActionValue isEqualToString:@"Edit"])
    {
       [btnEditOrSave setTitle:@"Save" forState:UIControlStateNormal];
    }
    else if ([self.strActionValue isEqualToString:@"View"])
    {
        [btnEditOrSave setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else if ([self.strActionValue isEqualToString:@"Add"])
    {
        [btnEditOrSave setTitle:@"Save" forState:UIControlStateNormal];
    }
}

-(IBAction)clickOnSave:(id)sender
{
   
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
   
    if ([self.strActionValue isEqualToString:@"Edit"])
    {
        if ( objLocalMedical.strDrugName.length>0 && objLocalMedical.strType.length>0)
        {
            BOOL checkDate=NO;
            NSLog(@"End Date: %@",objLocalMedical.strEndDate);
            if (![objLocalMedical.strEndDate isEqualToString:@"N/A"] && objLocalMedical.strEndDate != NULL && objLocalMedical.strEndDate.length>0)
            {
                if (objLocalMedical.startDate && objLocalMedical.endDate)
                {
                    checkDate=[self isEndDateIsSmallerThanCurrent:objLocalMedical.endDate withStart:objLocalMedical.startDate];
                    NSLog(@"checkDate: %d",checkDate);
                }
            }
            if (checkDate)
            {
                UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please set start date and end date correctly!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
                [altView show];
            }
            else
            {
                [self createReminderDataToSave];
                [self deleteReminder:[objLocalMedical.strId intValue]];
                
                [App_Delegate.dbObj updateMedicine:objLocalMedical];
                
                if (App_Delegate.reminderSwitch && App_Delegate.strReminderString.length>0)
                {
                    [self setReminder:[objLocalMedical.strId intValue]];
                }
                if (imgMedicine.image)
                {
                    NSString *strImageName=@"";
                    if (objLocalMedical.strImageName.length>0)
                    {
                        strImageName=objLocalMedical.strImageName;
                        
                    }
                    else
                    {
                        strImageName=[NSString stringWithFormat:@"%@_MedicineInfo.png",objLocalMedical.strId];
                    }
                    
                    [self saveImage:strImageName];
                    objLocalMedical.strImageName=strImageName;
                    [App_Delegate.dbObj updateMedicine:objLocalMedical];

                }
               
                App_Delegate.dictReminder=nil;
                App_Delegate.strReminderString=@"";
                
                if(self.medicineUpdateDelegte && [(id) self.medicineUpdateDelegte respondsToSelector:@selector(newMedicineAdd)])
                {
                    [self.medicineUpdateDelegte newMedicineAdd];
                }
                [self.view removeFromSuperview];
                
                [self performSelector:@selector(Upload) withObject:nil afterDelay:1.0];

            }
            
        }
        else
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [altView show];
            
        }

    }
    else if ([self.strActionValue isEqualToString:@"View"])
    {
        self.strActionValue=@"Edit";
        [btnEditOrSave setTitle:@"Update" forState:UIControlStateNormal];
        [tblView reloadData];
    }
    else if ([self.strActionValue isEqualToString:@"Add"])
    {
        if (objLocalMedical.strDrugName.length>0 && objLocalMedical.strType.length>0)
        {
            BOOL checkDate=NO;
            if (![objLocalMedical.strEndDate isEqualToString:@"N/A"])
            {
                if (objLocalMedical.startDate && objLocalMedical.endDate)
                {
                    checkDate=[self isEndDateIsSmallerThanCurrent:objLocalMedical.endDate withStart:objLocalMedical.startDate];
                    NSLog(@"checkDate: %d",checkDate);
                }
            }
            if (checkDate)
            {
                UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please set start date and end date correctly!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
                [altView show];
            }
            else
            {
                [self createReminderDataToSave];
                int medicineId=[App_Delegate.dbObj insertMedicine:objLocalMedical];
                if (App_Delegate.reminderSwitch && App_Delegate.strReminderString.length>0)
                {
                    [self setReminder:medicineId];
                }
                if (imgMedicine.image)
                {
                    NSString *strImageName=@"";
                    if (objLocalMedical.strImageName.length>0)
                    {
                        strImageName=objLocalMedical.strImageName;
                        
                    }
                    else
                    {
                        strImageName=[NSString stringWithFormat:@"%d_MedicineInfo.png",medicineId];
                    }
                    
                    [self saveImage:strImageName];
                    objLocalMedical.strImageName=strImageName;
                    objLocalMedical.strId = [NSString stringWithFormat:@"%d",medicineId];
                    [App_Delegate.dbObj updateMedicine:objLocalMedical];
                    
                }
                App_Delegate.strReminderString=@"";
                App_Delegate.dictReminder=nil;
                if(self.medicineUpdateDelegte && [(id) self.medicineUpdateDelegte respondsToSelector:@selector(newMedicineAdd)])
                {
                    [self.medicineUpdateDelegte newMedicineAdd];
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsLatestUpdate"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                [self.view removeFromSuperview];
                
                [self performSelector:@selector(Upload) withObject:nil afterDelay:1.0];

            }
        }
        else
        {
            UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please complete the required fields (*) before saving" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [altView show];
            
        }
    }
}

-(void)Upload
{
    [App_Delegate CheckBeforeUploadMainDB];
}

-(void)setReminder:(int)forMedicineId
{
    NSMutableArray *arrDate=[App_Delegate.dictReminder valueForKey:@"reminderDateArray"];
    [dateformater setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    for (int i = 0; i<arrDate.count; i++)
    {
        NSDate *startDate=[arrDate objectAtIndex:i];
        NSLog(@"Remindar Date: %@",[dateformater stringFromDate:startDate]);
        
        NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
        [dict setObject:[NSString stringWithFormat:@"%d",forMedicineId] forKey:@"medicineID"];
        [dict setObject:[dateformater stringFromDate:startDate] forKey:@"ForTime"];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody =[NSString stringWithFormat:@"Take your medicine '%@'.",objLocalMedical.strDrugName] ;
        localNotification.userInfo=dict;
        
        localNotification.fireDate =startDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.alertAction = @"View";
        int soundValue= [[App_Delegate.dictReminder valueForKey:@"soundFileIndex"] intValue];
        
        objLocalMedical.strRemdinerSoundIndex = [App_Delegate.dictReminder valueForKey:@"soundFileIndex"];
        objLocalMedical.strReminderSoundName = [App_Delegate.dictReminder valueForKey:@"soundFile"];
       
        if (soundValue == 0)
        {
            localNotification.soundName = UILocalNotificationDefaultSoundName;
        }
        else
        {
            NSString *strSound = [NSString stringWithFormat:@"%@.mp3",[App_Delegate.arrSoundFiles objectAtIndex:soundValue-1]];
            localNotification.soundName = strSound;
        }
        
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        NSCalendar *gregCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponent = [gregCalendar components:NSYearCalendarUnit  | NSWeekCalendarUnit fromDate:startDate];
        

        NSString *strSchedule=[App_Delegate.dictReminder valueForKey:@"selecetedScheduleTitle"];
        if ([strSchedule isEqualToString:@"Daily"])
        {
            localNotification.repeatInterval = NSCalendarUnitDay;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        else
        {
            NSArray *arrObje=[[NSArray alloc]initWithObjects:@"Daily",@"Sun",@"Mon",@"Tues",@"Wed",@"Thus",@"Fri",@"Sat", nil];
            NSArray *arr=[objLocalMedical.strScheduleDays componentsSeparatedByString:@","];
            for (NSUInteger i = 0; i < arr.count; i++)
            {
                NSString *strValu=[arr objectAtIndex:i];
                NSDateComponents *components = [gregCalendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
                NSInteger hour = [components hour];
                NSInteger minute = [components minute];
                
                [dateComponent setMinute:minute];
                NSInteger tag=[arrObje indexOfObject:strValu];
                [dateComponent setWeekday:tag]; // 2 = mon // 3= tues // 4 = wends // 5 = thurs // 6 = fri
                [dateComponent setHour:hour];
                
                NSDate *fireDate = [gregCalendar dateFromComponents:dateComponent];
                
                UILocalNotification *localNotification2 = [[UILocalNotification alloc] init];
                localNotification2.fireDate = fireDate;
                localNotification2.alertBody =[NSString stringWithFormat:@"Take your medicine '%@'.",objLocalMedical.strDrugName] ;
                localNotification2.userInfo=dict;

                localNotification2.timeZone = [NSTimeZone systemTimeZone];
                localNotification2.alertAction = @"View";
                
                if (soundValue == 0)
                {
                    localNotification2.soundName = UILocalNotificationDefaultSoundName;
                }
                else
                {
                    NSString *strSound = [NSString stringWithFormat:@"%@.mp3",[App_Delegate.arrSoundFiles objectAtIndex:soundValue-1]];
                    localNotification2.soundName = strSound;
                }
                localNotification2.repeatInterval = NSCalendarUnitWeekOfYear;
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification2];
                NSLog(@"%lu",(unsigned long)i);
                
            }
        }
        
    }
    
}



-(NSDate *)getSundayDate:(NSDate *)weekDate
{
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *currentComps = [myCalendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:weekDate];
    
    [currentComps setWeekday:2]; // 1: sunday
    NSDate *firstDayOfTheWeek = [myCalendar dateFromComponents:currentComps];
    return firstDayOfTheWeek;
}


-(void)deleteReminder:(int)meditionId
{
   //For delete locat notification
   
    UIApplication *app1 = [UIApplication sharedApplication];
    NSArray *eventArray = [app1 scheduledLocalNotifications];
    
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        
        if ([[userInfoCurrent objectForKey:@"medicineID"]intValue] == meditionId )
        {
            // Cancelling local notification
            [app1 cancelLocalNotification:oneEvent];
            NSLog(@"reminder Delete");
        }
    }
}



-(void)createReminderDataToSave
{
    if (App_Delegate.reminderSwitch && App_Delegate.strReminderString.length>0)
    {
        objLocalMedical.strReminder=App_Delegate.strReminderString;
        objLocalMedical.strRFrequencyTitle=[App_Delegate.dictReminder valueForKey:@"selectedFrequencyTitle"];
        objLocalMedical.strReminderCounts=[App_Delegate.dictReminder valueForKey:@"noOfReminder"];
        objLocalMedical.reminderStartTime=[App_Delegate.dictReminder valueForKey:@"startTime"];
        objLocalMedical.strScheduleDays=[App_Delegate.dictReminder valueForKey:@"selecetedScheduleTitle"];
        
        objLocalMedical.strRemdinerSoundIndex = [App_Delegate.dictReminder valueForKey:@"soundFileIndex"];
        objLocalMedical.strReminderSoundName = [App_Delegate.dictReminder valueForKey:@"soundFile"];

    }
    else
    {
        objLocalMedical.strReminder=@"";
        objLocalMedical.strRFrequencyTitle=@"";
        objLocalMedical.strReminderCounts=@"";
        objLocalMedical.reminderStartTime=nil;
    }
}

-(void)createReminderDataToDisplay
{
    if (objLocalMedical.strReminder.length>0 && ![objLocalMedical.strReminder isEqualToString:@"Add Reminder"])
    {
        if (!App_Delegate.dictReminder)
        {
            App_Delegate.dictReminder=[[NSMutableDictionary alloc] init];
        }
        App_Delegate.reminderSwitch=YES;
        [App_Delegate.dictReminder setValue:objLocalMedical.strRFrequencyTitle forKey:@"selectedFrequencyTitle"];
        [App_Delegate.dictReminder setObject:objLocalMedical.reminderStartTime forKey:@"startTime"];
        [App_Delegate.dictReminder setValue:objLocalMedical.strReminderCounts forKey:@"noOfReminder"];
        [App_Delegate.dictReminder setValue:@"Daily" forKey:@"selecetedScheduleTitle"];
        
        [App_Delegate.dictReminder setObject:[NSIndexPath indexPathForItem:[objLocalMedical.strReminderCounts intValue] inSection:0] forKey:@"selectedFrequency"];
        
        App_Delegate.strReminderString=objLocalMedical.strReminder;
        
        [App_Delegate.dictReminder setValue:objLocalMedical.strScheduleDays forKey:@"selecetedScheduleTitle"];
        
        [App_Delegate.dictReminder setValue:objLocalMedical.strReminderSoundName forKey:@"soundFile"];
        [App_Delegate.dictReminder setValue:objLocalMedical.strRemdinerSoundIndex forKey:@"soundFileIndex"];
        
        NSMutableDictionary *dicSch=[[NSMutableDictionary alloc] init];
        
        if ([objLocalMedical.strScheduleDays isEqualToString:@"Daily"])
        {
            [dicSch setValue:@"Daily" forKey:@"0"];
        }
        else
        {
            NSArray *arrObje=[[NSArray alloc]initWithObjects:@"Daily",@"Sun",@"Mon",@"Tues",@"Wed",@"Thus",@"Fri",@"Sat", nil];
            NSArray *arr=[objLocalMedical.strScheduleDays componentsSeparatedByString:@","];
            for (int i=0; i<arr.count; i++)
            {
                NSString *strValu=[arr objectAtIndex:i];
                NSInteger tag=[arrObje indexOfObject:strValu];
                [dicSch setValue:strValu forKey:[NSString stringWithFormat:@"%d",(int)tag]];
            }
        }
        
       [App_Delegate.dictReminder setObject:dicSch forKey:@"schedulDict"];
        
        NSMutableArray *arrStrinDate=[[NSMutableArray alloc]init];
        NSMutableArray *arrDate=[[NSMutableArray alloc]init];
        [dateformater setDateFormat:@"hh:mm a"];
        NSDate *myDate=[App_Delegate.dictReminder valueForKey:@"startTime"];
        
        NSArray *arrSDate = [objLocalMedical.strReminder componentsSeparatedByString:@","];
        NSDate *workingDate;

        for (int i=0; i<arrSDate.count; i++)
        {
            [dateformater setDateFormat:@"dd-MM-yyyy"];
            NSString *SDate = [dateformater stringFromDate:myDate];
            [dateformater setDateFormat:@"dd-MM-yyyy hh:mm a"];
            SDate = [NSString stringWithFormat:@"%@ %@",SDate,[arrSDate objectAtIndex:i]];
            workingDate = [dateformater dateFromString:SDate];
            [dateformater setDateFormat:@"hh:mm a"];
            NSString *strDate=[dateformater stringFromDate:workingDate];
            [arrStrinDate addObject:strDate];
            [arrDate addObject:workingDate];
            
        }
        [App_Delegate.dictReminder setObject:arrDate forKey:@"reminderDateArray"];
        [App_Delegate.dictReminder setObject:arrStrinDate forKey:@"reminderStringDateArray"];
        
        [tblView reloadData];
    }
}

- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate withStart:(NSDate *)checkStartDate
{
    if (isNotApplicable)
    {
        return NO;
    }
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = checkStartDate;
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}
-(IBAction)clickOnClose:(id)sender
{
    if ([self.strActionValue isEqualToString:@"View"])
    {
        App_Delegate.dictReminder=nil;
        App_Delegate.strReminderString=@"";
        
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [self.view removeFromSuperview];
        [[self.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    }
    else
    {
        UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You haven’t saved data yet. Do you really want to cancel the process?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        altView.tag=110;
        [altView show];
    }
}

-(void)doneWithNumberPad
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

    if ([App_Delegate.dbObj GetAllMedicalProvidersName].count<=0 && rowTag==10)
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
        if (rowTag==10)
        {
            objPicker.EntryTag=6;
        }
        else
        {
            objPicker.EntryTag=3;
        }
        objPicker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             objPicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
        [self.view addSubview:objPicker.view];
    }
    
    
}


-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger)section andForRow:(NSInteger)row
{
    IsActionSheetVisible=NO;
    if (section==0)
    {
        if (row==Type)
        {
            objLocalMedical.strType=strValue;
        }
        else if (row==Frequency)
        {
            objLocalMedical.strFrequency=strValue;
        }
        else if (row==RefillFrq)
        {
            objLocalMedical.strRefillFrequency=strValue;
        }
        else if (row==PrescribeBy)
        {
            objLocalMedical.strPrescribedBy=strValue;
        }
    }
    [tblView reloadData];
}


-(void)clickOnOpenDatePicker
{
    [txtTemp resignFirstResponder];
    [tvTemp resignFirstResponder];
    if (IsUp)
    {
        IsUp=NO;
        [self MoveViewDown];
    }
    objDatePicker=[[DatePickerVC alloc] initWithNibName:@"DatePickerVC" bundle:nil];
    objDatePicker.datePickerDel=self;
    // objDate.view.frame=self.view.frame;
    objDatePicker.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         objDatePicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    [self.view addSubview:objDatePicker.view];
    
}

-(void)didSelectDate:(NSDate *)selectedDate
{
    IsActionSheetVisible=NO;
    
    [dateformater setDateStyle:NSDateFormatterMediumStyle];
    if (datePicTag==StartDate)
    {
        objLocalMedical.startDate=selectedDate;
        objLocalMedical.strStartDate=[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]];
    }
    else if (datePicTag==EndDate)
    {
        objLocalMedical.endDate=selectedDate;
        objLocalMedical.strEndDate=[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]];
        isNotApplicable=YES;
        [self clickOnUpdateEnddate:nil];
    }
    else
    {
        objLocalMedical.strRefillDate=[NSString stringWithFormat:@"%@",[dateformater stringFromDate:selectedDate]];
    }
    [tblView reloadData];
}

-(void)didCancelPicker
{
    IsActionSheetVisible=NO;
}

-(IBAction)clickOnAddContact:(id)sender
{
    if(self.medicineUpdateDelegte && [(id) self.medicineUpdateDelegte respondsToSelector:@selector(addManagingProvider)])
    {
        [self.medicineUpdateDelegte addManagingProvider];
    }
}

-(IBAction)addPhoto:(id)sender
{
    if ([self.strActionValue isEqualToString:@"View"])
    {
        UIAlertView *altView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do you want to edit medicine?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil ];
        altView.tag=101;
        [altView show];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Photo Library"
                                      otherButtonTitles:@"Camera", nil];
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:self.view];
        
    }
}

#pragma mark Image Picker delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!imagePicker)
    {
        imagePicker = [[UIImagePickerController alloc] init];    
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    switch (buttonIndex)
    {
        case 0: NSLog(@"Photo Butten Clicked");
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
            
        case 1: NSLog(@"Camera Butten Clicked");
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                UIAlertView *altnot=[[UIAlertView alloc]initWithTitle:@"Camera Not Available" message:@"Camera Not Available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [altnot show];
            }
            [self presentViewController:imagePicker animated:YES completion:nil];

            break;
            
        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage= info[UIImagePickerControllerEditedImage];
    if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
        });
    }
    
    
    [imgMedicine setImage:selectedImage];
    [picker dismissViewControllerAnimated:NO completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}

-(NSString *)saveImage:(NSString *)strFileName
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyImages"];
    NSString *filePath = @"";
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    filePath = [dataPath stringByAppendingPathComponent:strFileName];
    NSData *imageData = UIImagePNGRepresentation(imgMedicine.image);
    [imageData writeToFile:filePath atomically:YES];
    return filePath;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}


-(void)openAddReminder
{

    UIStoryboard *objStroy=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ReminderVC *objReminder=[objStroy instantiateViewControllerWithIdentifier:@"ReminderVC"];
    [self presentModalViewController:objReminder animated:YES];
}


#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101)   //for enable Editing
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([title isEqualToString:@"YES"])
        {
            self.strActionValue=@"Edit";
            [btnEditOrSave setTitle:@"Update" forState:UIControlStateNormal];
            [tblView reloadData];
            [self addPhoto:nil];
        }
    }
    else if(alertView.tag==105)   //for Add Provider
    {
        [self clickOnAddContact:nil];
    }
    else if (alertView.tag == 110)
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([title isEqualToString:@"YES"])
        {
            App_Delegate.dictReminder=nil;
            App_Delegate.strReminderString=@"";
            
            CATransition *applicationLoadViewIn =[CATransition animation];
            [applicationLoadViewIn setDuration:0.5];
            [applicationLoadViewIn setType:kCATransitionReveal];
            [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [self.view removeFromSuperview];
            [[self.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];

        }
    }
}


#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==Type || textField.tag==Frequency  || textField.tag==RefillFrq || textField.tag==PrescribeBy)
    {
        if (IsActionSheetVisible==NO)
        {
            IsActionSheetVisible=YES;
            [self clickOnValuePicker:textField.tag withSection:textField.superview.tag];
        }
        
        return NO;
    }
    else if (textField.tag==7)
    {
        
        [self openAddReminder];
        return NO;
    }
    else if (textField.tag==5 || textField.tag==6 || textField.tag==8)
    {
        if (IsActionSheetVisible==NO)
        {
            IsActionSheetVisible=YES;
            datePicTag=textField.tag;
            [self clickOnOpenDatePicker];
        }
        return NO;
    }
    else if (textField.tag == DrugName || textField.tag == GenericName || textField.tag == Dosage)
    {
        IsUp=YES;
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self.view setFrame:CGRectMake(self.view.frame.origin.x,-150,self.view.frame.size.width,self.view.frame.size.height)];
         }
                         completion:^(BOOL finished)
         {}];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==DrugName)
    {
        objLocalMedical.strDrugName=textField.text;
    }
    else if (textField.tag==GenericName)
    {
        objLocalMedical.strGenericName=textField.text;
    }
    else if (textField.tag==Dosage)
    {
        objLocalMedical.strDosage=textField.text;
    }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtTemp=textField;
    

    
    
    if (textField.tag==6 || textField.tag==7 || textField.tag==8 || textField.tag==9 )
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ( textField.tag==6 || textField.tag==7 || textField.tag==8 || textField.tag==9 || IsUp)
    {
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
        
    }
    [textField resignFirstResponder];
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (textField.tag == Dosage)
    {
        return stringIsValid;
    }
    else
    {
        return YES;
    }
    */
    return YES;

}

-(void)MoveViewUp
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,-250,self.view.frame.size.width,self.view.frame.size.height)];
}
-(void)MoveViewDown
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0,self.view.frame.size.width,self.view.frame.size.height)];
}


#pragma mark UITextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    tvTemp=textView;
    IsUp=YES;
    [UIView animateWithDuration:0.40f animations:
     ^{
         [self MoveViewUp];
     }
                     completion:^(BOOL finished)
     {}];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    objLocalMedical.strNotes=textView.text;
    if (IsUp==YES)
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

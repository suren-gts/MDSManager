//
//  ReminderVC.m
//  MyMDSManager
//
//  Created by CEPL on 04/08/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "ReminderVC.h"
#import "AddReminderVC.h"

@interface ReminderVC ()

@end

@implementation ReminderVC

- (void)viewDidLoad
{
    tblReminderInterval.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    switchReminder.on=App_Delegate.reminderSwitch;
    dateformater=[[NSDateFormatter alloc]init];
    
   
   
    viewSwitchBack.layer.cornerRadius=10;
    viewSwitchBack.clipsToBounds=YES;
    
    btnSecheduleDay.layer.cornerRadius=10;
    btnSecheduleDay.clipsToBounds=YES;
    
    btnFrequency.layer.cornerRadius=10;
    btnFrequency.clipsToBounds=YES;
    
    btnSoundName.layer.cornerRadius=10;
    btnSoundName.clipsToBounds=YES;
    
    [self clickOnReminderSwitch:switchReminder];
    [super viewDidLoad];

}


-(void)viewWillAppear:(BOOL)animated
{
    if (App_Delegate.dictReminder)
    {
        [btnFrequency setTitle:[App_Delegate.dictReminder valueForKey:@"selectedFrequencyTitle"] forState:UIControlStateNormal];
        [btnSecheduleDay setTitle:[App_Delegate.dictReminder valueForKey:@"selecetedScheduleTitle"] forState:UIControlStateNormal];
        
        arrReminders=[App_Delegate.dictReminder objectForKey:@"reminderStringDateArray"];
    }
    
    [tblReminderInterval reloadData];
}

#pragma mark Utility Functions

-(IBAction)clickOnBack:(id)sender
{
    [self saveReminder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveReminder
{
    if (App_Delegate.reminderSwitch)
    {
        App_Delegate.strReminderString=@"";
        for (int i=0; i<arrReminders.count; i++)
        {
            if ([App_Delegate.strReminderString isEqualToString:@""])
            {
                App_Delegate.strReminderString=[NSString stringWithFormat:@"%@",[arrReminders objectAtIndex:i]];
                
            }
            else
            {
                App_Delegate.strReminderString=[NSString stringWithFormat:@"%@,%@",App_Delegate.strReminderString,[arrReminders objectAtIndex:i]];
                
            }
        }
    }
    else
    {
        App_Delegate.dictReminder=nil;
        App_Delegate.strReminderString=@"";
    }
}

-(IBAction)clickOnOpenAddReminder:(UIButton*)sender
{

    UIStoryboard *objStroy=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddReminderVC *objReminder=[objStroy instantiateViewControllerWithIdentifier:@"AddReminderVC"];
    objReminder.entryTag=(int)sender.tag;
    [self presentModalViewController:objReminder animated:YES];

}

-(IBAction)clickOnReminderSwitch:(id)sender
{
    App_Delegate.reminderSwitch=switchReminder.on;
    [self swithWithAnimation];
}

-(void)swithWithAnimation
{
    BOOL state=switchReminder.on;
    
    if (state)
    {
        if (!App_Delegate.dictReminder)
        {
            App_Delegate.dictReminder=[[NSMutableDictionary alloc]init];
            
            [App_Delegate.dictReminder setObject:[NSIndexPath indexPathForItem:0 inSection:0] forKey:@"selectedFrequency"];
            [App_Delegate.dictReminder setValue:@"once a day" forKey:@"selectedFrequencyTitle"];
            [App_Delegate.dictReminder setObject:[NSDate date] forKey:@"startTime"];
            [App_Delegate.dictReminder setValue:@"1" forKey:@"noOfReminder"];
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"hh:mm a"];
            NSString *strDate=[formatter stringFromDate:[NSDate date]];
            
            [App_Delegate.dictReminder setObject:[[NSMutableArray alloc]initWithObjects:strDate, nil ] forKey:@"reminderStringDateArray"];
            [App_Delegate.dictReminder setObject:[[NSMutableArray alloc]initWithObjects:[NSDate date], nil ]  forKey:@"reminderDateArray"];
            
            [btnFrequency setTitle:[App_Delegate.dictReminder valueForKey:@"selectedFrequencyTitle"] forState:UIControlStateNormal];
            arrReminders=[App_Delegate.dictReminder objectForKey:@"reminderStringDateArray"];
            
            [App_Delegate.dictReminder setValue:@"Daily" forKey:@"selecetedScheduleTitle"];
            [btnSecheduleDay setTitle:[App_Delegate.dictReminder valueForKey:@"selecetedScheduleTitle"] forState:UIControlStateNormal];
            
            lblSoundName.text =  @"Default";
            [App_Delegate.dictReminder setValue:@"Default" forKey:@"soundFile"];
            [App_Delegate.dictReminder setValue:@"0" forKey:@"soundFileIndex"];
            
            [tblReminderInterval reloadData];
        }
        else
        {
            NSMutableArray *arrStrinDate=[[NSMutableArray alloc]init];
            NSMutableArray *arrDate=[[NSMutableArray alloc]init];
            [dateformater setDateFormat:@"hh:mm a"];
            
            if ([App_Delegate.dictReminder objectForKey:@"reminderDateArray"])
            {
                arrDate = [App_Delegate.dictReminder objectForKey:@"reminderDateArray"];
                arrStrinDate = [App_Delegate.dictReminder objectForKey:@"reminderStringDateArray"];
            }
            else
            {
                NSDate *myDate=[App_Delegate.dictReminder valueForKey:@"startTime"];
                int noOfReminder=[[App_Delegate.dictReminder valueForKey:@"noOfReminder"] intValue];
                NSDate *workingDate;
                int noOfHours=0;
                for (int i=0; i<noOfReminder; i++)
                {
                    noOfHours=24/noOfReminder;
                    if (i==0)
                    {
                        workingDate=myDate;
                    }
                    else
                    {
                        workingDate=[workingDate dateByAddingTimeInterval:noOfHours*3600];
                    }
                    NSString *strDate=[dateformater stringFromDate:workingDate];
                    [arrStrinDate addObject:strDate];
                    [arrDate addObject:workingDate];
                    
                }
                [App_Delegate.dictReminder setObject:arrDate forKey:@"reminderDateArray"];
                [App_Delegate.dictReminder setObject:arrStrinDate forKey:@"reminderStringDateArray"];
                
            }
            lblSoundName.text =  [App_Delegate.dictReminder valueForKey:@"soundFile"];
            
            [btnSecheduleDay setTitle:[App_Delegate.dictReminder valueForKey:@"selecetedScheduleTitle"] forState:UIControlStateNormal];
            
            arrReminders=arrStrinDate;
            
            [tblReminderInterval reloadData];
        }
        btnSecheduleDay.userInteractionEnabled=YES;
        tblReminderInterval.userInteractionEnabled=YES;
        btnFrequency.userInteractionEnabled=YES;
        
    }
    else
    {
        btnSecheduleDay.userInteractionEnabled=NO;
        tblReminderInterval.userInteractionEnabled=NO;
        btnFrequency.userInteractionEnabled=NO;
    }
    
}

-(IBAction)clickOnValuePicker:(id)sender
{
    objPicker=[[ContentPickerVC alloc]initWithNibName:@"ContentPickerVC" bundle:nil];
    objPicker.valueDelegate=self;
    objPicker.EntryTag=8;
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

-(void)didSelectValueFromPicker:(NSInteger)intIndex withValue:(NSString *)strValue forSection:(NSInteger)section andForRow:(NSInteger)row
{
    IsActionSheetVisible=NO;
    lblSoundName.text=strValue;
    [App_Delegate.dictReminder setValue:strValue forKey:@"soundFile"];
    [App_Delegate.dictReminder setValue:[NSString stringWithFormat:@"%lx",(long)intIndex] forKey:@"soundFileIndex"];
}

#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrReminders.count;
    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:MyIdentifier] ;
    }
    if (indexPath.row==0)
    {
        cell.textLabel.text =[arrReminders objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=@"Start Time";
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.textLabel.text = [arrReminders objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=@"";
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (IsActionSheetVisible==NO)
    {
        currentDateSectionIndex = indexPath.row;
        IsActionSheetVisible=YES;
        [self clickOnOpenDatePicker:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)])
    {
        if (tableView == tblReminderInterval)
        {
            // self.tableview if view controller is of type Table view
            CGFloat cornerRadius = 10.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 5, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:1.0f].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+5, bounds.size.height-lineHeight, bounds.size.width-5, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
    
}

-(void)clickOnOpenDatePicker:(id)sender
{
    objDatePicker=[[DatePickerVC alloc] initWithNibName:@"DatePickerVC" bundle:nil];
    objDatePicker.datePickerDel=self;
    objDatePicker.entryTag=100;
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
    
    [dateformater setDateFormat:@"hh:mm a"];
    NSMutableArray *arrStrinDate=[[NSMutableArray alloc]init];
    NSMutableArray *arrDate=[[NSMutableArray alloc]init];

    if (currentDateSectionIndex == 0)
    {
        [App_Delegate.dictReminder setObject:selectedDate forKey:@"startTime"];
       
        NSDate *myDate=[App_Delegate.dictReminder valueForKey:@"startTime"];
        int noOfReminder=[[App_Delegate.dictReminder valueForKey:@"noOfReminder"] intValue];
        NSDate *workingDate;
        int noOfHours=0;
        for (int i=0; i<noOfReminder; i++)
        {
            noOfHours=24/noOfReminder;
            if (i==0)
            {
                workingDate=myDate;
            }
            else
            {
                workingDate=[workingDate dateByAddingTimeInterval:noOfHours*3600];
            }
            NSString *strDate=[dateformater stringFromDate:workingDate];
            [arrStrinDate addObject:strDate];
            [arrDate addObject:workingDate];
            
            
        }
        [App_Delegate.dictReminder setObject:arrDate forKey:@"reminderDateArray"];
        [App_Delegate.dictReminder setObject:arrStrinDate forKey:@"reminderStringDateArray"];
        arrReminders=arrStrinDate;

    }
    else
    {
        arrDate = [App_Delegate.dictReminder objectForKey:@"reminderDateArray"];
        arrStrinDate =  [App_Delegate.dictReminder objectForKey:@"reminderStringDateArray"];
      
        NSString *strDate=[dateformater stringFromDate:selectedDate];
        [arrStrinDate replaceObjectAtIndex:currentDateSectionIndex withObject:strDate];
         [arrDate replaceObjectAtIndex:currentDateSectionIndex withObject:selectedDate];
        [App_Delegate.dictReminder setObject:arrDate forKey:@"reminderDateArray"];
        [App_Delegate.dictReminder setObject:arrStrinDate forKey:@"reminderStringDateArray"];
        arrReminders=arrStrinDate;


        
    }
    
    
    
    [tblReminderInterval reloadData];
}

-(void)didCancelPicker
{
    IsActionSheetVisible=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

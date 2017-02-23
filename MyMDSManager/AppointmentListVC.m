//
//  AppointmentListVC.m
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "AppointmentListVC.h"
#import "ProfileHeaderCell.h"
#import "ButtonCell.h"
#import "AddAppointmentVC.h"
#import "ThreeLableContentCell.h"
#import "ThreeLableHeaderCell.h"

@interface AppointmentListVC ()

@end

@implementation AppointmentListVC

@synthesize calendarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    dateFormatter = [[NSDateFormatter alloc] init];
  
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    currentDate = [[NSCalendar currentCalendar]
                         dateFromComponents:components];
    listTag=0;
    dictEvent=[App_Delegate.dbObj GetAppointmentForCalaenderEvent];
    isViewUpdate=NO;
    [self setUpCalenderView];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDBData:listTag];
    
    [tblView setFrame:CGRectMake(0,  self.calendarView.frame.origin.y+ self.calendarView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.calendarView.frame.size.height-64)];
    if(isViewUpdate)
    {
        isViewUpdate=NO;
        self.calendarView.selectedDate=nil;
        listTag=oldListTag;
        if (listTag==0)
        {
            self.calendarView.selectedDate=oldDate;
        }
        [self loadDBData:listTag];
    }
}

-(void)loadDBData:(int)index
{
    if (arrCurrentAppointment)
    {
        [arrCurrentAppointment removeAllObjects];
    }
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLog(@"CurrentDate: %@",[dateFormatter stringFromDate:currentDate]);
    dictEvent=[App_Delegate.dbObj GetAppointmentForCalaenderEvent];
    if (index==0)
    {
        arrCurrentAppointment=[App_Delegate.dbObj GetTodaysAppointments:currentDate];
    }
    else
    {
        arrCurrentAppointment=[App_Delegate.dbObj GetAllCurrentAppointments];
    }
    
    [self.view endEditing:YES];
    [tblView reloadData];
}

#pragma mark - Calender view Methods

-(void)setUpCalenderView
{
    
    self.calendarView = [[CXCalendarView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*.40)] ;
    self.calendarView.backgroundColor =[UIColor whiteColor];
    self.calendarView.delegate = self;
    self.calendarView.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.calendarView.selectedDate =currentDate;
    [self.view addSubview:self.calendarView];
    
  
}


#pragma mark CXCalendar Delegate :-----

- (void) calendarView: (CXCalendarView *) calendarView
        didSelectDate: (NSDate *) date
{
    currentDate=date;
    listTag=0;
    [self loadDBData:listTag];
    
}
- (BOOL) calendarView: (CXCalendarView *) calendarView
eventAvailableForDate: (NSDate *) selectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strKey = [formatter stringFromDate:selectedDate];
    if ([dictEvent valueForKey:strKey])
    {
        return YES;
    }
    return NO;
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //count of row in section
    if (arrCurrentAppointment.count>0)
    {
       return arrCurrentAppointment.count+1;
    }
    else
    {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Height of Row in Tableview
   if(indexPath.row==0)
   {
       return 30;
   }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Height of Section Header in TableView
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //View for Section Header of TableView
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0]];
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 21)];
    [lblTitle setTextColor:[UIColor whiteColor]];
    
    if (listTag==0)
    {
        [dateFormatter setDateFormat:@"MMM dd, YYYY"];
        NSString *strKey = [dateFormatter stringFromDate:currentDate];
        [lblTitle setText:strKey];
        
        UIButton *btnListAll=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnListAll setFrame:CGRectMake(self.view.frame.size.width-80, 2, 80, 26)];
        [btnListAll setTitle:@"List All" forState:UIControlStateNormal];
        [btnListAll setFont:[UIFont systemFontOfSize:16]];
        [btnListAll addTarget:self action:@selector(clickOnListAll) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btnListAll];
    }
    else
    {
        [lblTitle setText:@"All Appointments"];
        
    }
    [headerView addSubview:lblTitle];
    
   
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==CurrentAppointement)
    {
        if (arrCurrentAppointment.count>0)
        {
            if (indexPath.row==0)
            {
                static NSString *CellIdentifier = @"ThreeLableHeaderCell";
                
                ThreeLableHeaderCell *cell = (ThreeLableHeaderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableHeaderCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                cell.lblHeading1.text=@"Date";
                cell.lblHeading2.text=@"Time";
                cell.lblHeading3.text=@"Provider";
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            else
            {
                static NSString *CellIdentifier = @"ThreeLableContentCell";
                
                ThreeLableContentCell *cell = (ThreeLableContentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ThreeLableContentCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                }
                AppointementObject *objDia=[arrCurrentAppointment objectAtIndex:indexPath.row-1];
                NSArray *arr=[objDia.strDateTime componentsSeparatedByString:@"  "];
                if (arr.count>1)
                {
                    cell.lblTitle1.text=[arr objectAtIndex:0];
                    cell.lblTitle2.text=[arr objectAtIndex:1];
                }
                
                cell.lblTitle3.text=objDia.strProvider;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
            
        }
       
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==CurrentAppointement)
    {
        if (indexPath.row>0)
        {
            oldDate=currentDate;
            isViewUpdate=YES;
            oldListTag=listTag;
            UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AddAppointmentVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddAppointmentVC"];
            objView.objLocalAppointment=[arrCurrentAppointment objectAtIndex:indexPath.row-1];
            objView.editFlag=1;
            [self.navigationController pushViewController:objView animated:YES];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (indexPath.row>0)
    {
        return  YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.row>0 && indexPath.row !=arrCurrentAppointment.count+1)
        {
            AppointementObject *objAppint = [arrCurrentAppointment objectAtIndex:indexPath.row-1];
            
            if (objAppint.strEventIdentifier.length>0)
            {
                [self deleteEvent:objAppint.strEventIdentifier];
            }
            [self deleteReminder:[objAppint.strId intValue]];
            [App_Delegate.dbObj deleteAppointment:objAppint.strId];
            
            [App_Delegate CheckBeforeUploadMainDB];
            
            [self loadDBData:listTag];
        }
        
    }
}


#pragma mark - Function Methods
-(void)deleteEvent:(NSString *)strEventIdentifier
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
                                          
                                          EKEvent* eventToRemove = [store eventWithIdentifier:strEventIdentifier];
                                          if (eventToRemove != nil) {
                                              NSError* error = nil;
                                              [store removeEvent:eventToRemove span:EKSpanThisEvent error:&error];
                                          }

                                      });
                                  }
                              }];
    }
    else
    {
        // iOS 5
        EKEvent* eventToRemove = [store eventWithIdentifier:strEventIdentifier];
        if (eventToRemove != nil) {
            NSError* error = nil;
            [store removeEvent:eventToRemove span:EKSpanThisEvent error:&error];
        }

    }
    
}

-(void)deleteReminder:(int)appointmentId
{
    //For delete locat notification
    
    UIApplication *app1 = [UIApplication sharedApplication];
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

-(IBAction)clickOnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickOnListAll
{
    
    self.calendarView.selectedDate=nil;
    listTag=1;
    [self loadDBData:listTag];
    
}

-(IBAction)clickOnAddAppointment:(id)sender
{
    oldDate=currentDate;
    isViewUpdate=YES;
    oldListTag=listTag;
    UIStoryboard *objStoryboar=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAppointmentVC *objView=[objStoryboar instantiateViewControllerWithIdentifier:@"AddAppointmentVC"];
    [self.navigationController pushViewController:objView animated:YES];
}


- (void) dealloc
{
    tblView.delegate=nil;
    tblView.dataSource=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

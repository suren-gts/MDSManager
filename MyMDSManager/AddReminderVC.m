//
//  AddReminderVC.m
//  MyMDSManager

//  Created by CEPL on 04/08/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "AddReminderVC.h"

@interface AddReminderVC ()

@end

@implementation AddReminderVC

@synthesize entryTag;

- (void)viewDidLoad
{
    [super viewDidLoad];
    formatter=[[NSDateFormatter alloc]init];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    if (self.entryTag==0)
    {
        arrSechdeul=[[NSMutableArray alloc] initWithObjects:@"Daily",@"Sun",@"Mon",@"Tues",@"Wed",@"Thus",@"Fri",@"Sat", nil];

        if ([App_Delegate.dictReminder valueForKey:@"schedulDict"])
        {
            dictSchedule=[App_Delegate.dictReminder valueForKey:@"schedulDict"];
        }
        else
        {
            dictSchedule=[[NSMutableDictionary alloc] init];
            [dictSchedule setObject:[arrSechdeul objectAtIndex:0] forKey:@"0"];
        }
    }
    else
    {
        
        NSArray *arrSection1=[[NSArray alloc]initWithObjects:@"once a day",@"twice a day",@"3 times a day",@"4 times a day",@"6 times a day",@"8 times a day",@"12 times a day",@"24 times a day", nil ];
        arrCount1=[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"6",@"8",@"12",@"24", nil ];
        
        NSArray *arrSection2=[[NSArray alloc]initWithObjects:@"every 24 hours",@"every 12 hours",@"every 8 hours",@"every 6 hours",@"every 4 hours",@"every 3 hours",@"every 2 hours",@"every hours", nil ];
        
        arrTableContent=[[NSArray alloc]initWithObjects:arrSection1,arrSection2,nil];
    }
}


#pragma  mark Utility Function for Sechedul Day

-(void)createScheduleDay
{
    NSString *strSting=@"";
    for(int i=0; i<arrSechdeul.count; i++)
    {
        NSString *strIdex=[NSString stringWithFormat:@"%d",i];
        if ([dictSchedule valueForKey:strIdex] && i==0)
        {
            strSting=[arrSechdeul objectAtIndex:0];
            break;
        }
        else if ([dictSchedule valueForKey:strIdex])
        {
            if (dictSchedule.count>6)
            {
                strSting=[arrSechdeul objectAtIndex:0];
                break;
            }
            else if (strSting.length>0)
            {
                strSting=[NSString stringWithFormat:@"%@,%@",strSting,[dictSchedule valueForKey:strIdex]];
            }
            else
            {
                strSting=[NSString stringWithFormat:@"%@",[dictSchedule valueForKey:strIdex]];
            }
        }
    }
    [App_Delegate.dictReminder setObject:dictSchedule forKey:@"schedulDict"];
    [App_Delegate.dictReminder setValue:strSting forKey:@"selecetedScheduleTitle"];
}

#pragma mark Utility Functions

-(IBAction)clickOnBack:(id)sender
{
    if (self.entryTag==0)
    {
        [self createScheduleDay];
    }
    else
    {
        [self createTimerIntarval];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createTimerIntarval
{
    [formatter setDateFormat:@"hh:mm a"];
    NSMutableArray *arrStrinDate=[[NSMutableArray alloc]init];
    NSMutableArray *arrDate=[[NSMutableArray alloc]init];
    NSDate *myDate=[App_Delegate.dictReminder valueForKey:@"startTime"];
    NSIndexPath *indexpath=[App_Delegate.dictReminder valueForKey:@"selectedFrequency"];
    int noOfReminder=[[arrCount1 objectAtIndex:indexpath.row] intValue];
    [App_Delegate.dictReminder setValue:[NSString stringWithFormat:@"%d",noOfReminder] forKey:@"noOfReminder"];

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
        NSString *strDate=[formatter stringFromDate:workingDate];
        [arrStrinDate addObject:strDate];
        [arrDate addObject:workingDate];
    }
    [App_Delegate.dictReminder setObject:arrDate forKey:@"reminderDateArray"];
    [App_Delegate.dictReminder setObject:arrStrinDate forKey:@"reminderStringDateArray"];
}

#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.entryTag==0)
    {
        return 1;
    }
    else
    {
        return arrTableContent.count;    //count of section
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.entryTag==0)
    {
        return arrSechdeul.count;
    }
    else
    {
        return [[arrTableContent objectAtIndex:section] count];
    }
   
    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier] ;
    }
    
    if (self.entryTag==0)
    {
        cell.textLabel.text=[arrSechdeul objectAtIndex:indexPath.row];
        
        NSString *strKey=[NSString stringWithFormat:@"%lx",indexPath.row];
        if ([dictSchedule valueForKey:strKey])
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }

    }
    else
    {
        NSArray *arrLocal=[arrTableContent objectAtIndex:indexPath.section];
        cell.textLabel.text = [arrLocal objectAtIndex:indexPath.row];

        NSIndexPath *localIndexPath = [App_Delegate.dictReminder objectForKey:@"selectedFrequency"];
        
        if (localIndexPath.row==indexPath.row && localIndexPath.section ==indexPath.section)
        {
            [App_Delegate.dictReminder setValue:cell.textLabel.text forKey:@"selectedFrequencyTitle"];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSIndexPath *oldIndex = [tblView indexPathForSelectedRow];
    [[tblView cellForRowAtIndexPath:oldIndex] setSelected:NO animated:YES];

    if (self.entryTag==0)
    {
        NSString *strKey=[NSString stringWithFormat:@"%lx",indexPath.row];
        if ([dictSchedule valueForKey:strKey] && dictSchedule.count>1)
        {
            [dictSchedule removeObjectForKey:strKey];
        }
        else
        {
            if ([strKey isEqualToString:@"0"])
            {
                [dictSchedule removeAllObjects];
            }
            else
            {
                [dictSchedule removeObjectForKey:@"0"];
            }
            [dictSchedule setObject:[arrSechdeul objectAtIndex:indexPath.row] forKey:strKey];
        }
    }
    else
    {
        [App_Delegate.dictReminder setObject:indexPath forKey:@"selectedFrequency"];
        
    }
  [tblView performSelector:@selector(reloadData) withObject:self afterDelay:0.2];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 30)];
    headerView.backgroundColor=[UIColor colorWithRed:53.0/255.0 green:130.0/255.0 blue:115.0/255.0 alpha:1.0];
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, tblView.frame.size.width-10, 21)];
    lblTitle.textColor=[UIColor whiteColor];
    if (section==0)
    {
        if (self.entryTag==0)
        {
            [lblTitle setText:@"REPEAT"];
        }
        else
        {
            [lblTitle setText:@"FREQUENCY"];
        }
    }
    else
    {
        [lblTitle setText:@"INTERVALS"];
    }
    [headerView addSubview:lblTitle];
    
    return headerView;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

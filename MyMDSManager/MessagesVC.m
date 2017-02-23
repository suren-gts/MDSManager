//
//  MessagesVC.m
//  MyMDSManager
//
//  Created by CEPL on 03/09/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import "MessagesVC.h"
#import "MessageCell.h"
#import "UnirestAsyncApi.h"

@interface MessagesVC ()

@end

@implementation MessagesVC

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    dateFormater=[[NSDateFormatter alloc] init];
    [self loadMessageList];
  
}
                      
-(IBAction)loadMessageList
{
    
    NSMutableDictionary * Dic=[[NSMutableDictionary alloc]init];
    
    UIDevice *device = [UIDevice currentDevice];
    
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    
    [Dic setObject:currentDeviceId forKey:@"device_id"];
    
    [UnirestAsyncApi callPostAsyncAPI:@"notification.php" withParameter:Dic selector:@selector(callBackForUpdateDeviceToken:) toTarget:self showHUD:YES];
}

-(void)callBackForUpdateDeviceToken:(NSMutableDictionary*)DictR
{
    int status=[[DictR valueForKey:@"status"] intValue];
    if (status==1)
    {
        arrTableContent = [DictR valueForKey:@"data"];
    }
    
    if (arrTableContent.count>0)
    {
        [tblView reloadData];
    }
}

#pragma mark UItableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrTableContent.count>0)
    {
        return arrTableContent.count;
    }
    else
    {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrTableContent.count>0)
    {
        NSDictionary *dictValue=[arrTableContent objectAtIndex:indexPath.row];
        NSString *strDesc=[dictValue valueForKey:@"notification"];
        
        CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20, FLT_MAX);
        CGSize expectedLabelSize = [strDesc sizeWithFont:[UIFont fontWithName:@"NexaRegular" size:16] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        return expectedLabelSize.height+29+8+30;
    }
    else
    {
        return 72;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arrTableContent count] == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"No records to display";
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"MessageCell";
        
        MessageCell *cell = (MessageCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MessageCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        NSDictionary *dictValue=[arrTableContent objectAtIndex:indexPath.row];
        
        NSString *strMessage=[dictValue valueForKey:@"notification"];
        cell.lblMessage.numberOfLines=0;
        
        CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20, FLT_MAX);
        CGSize expectedLabelSize = [strMessage sizeWithFont:[UIFont fontWithName:@"NexaRegular" size:16] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
        CGRect newFrame = cell.lblMessage.frame;
        newFrame.size.height = expectedLabelSize.height+100;
        
        cell.lblMessage.text=strMessage;
        cell.lblMessage.frame = newFrame;
        cell.tvMessage.frame=newFrame;
        cell.tvMessage.text =strMessage;

        //cell.tvMessage.dataDetectorTypes = UIDataDetectorTypeAll;

        NSString *strTime = [dictValue valueForKey:@"createdon"];
        
        NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormater setTimeZone:gmtTimeZone];
        //2015-09-04 10:19:09
        [dateFormater setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
        NSDate *dateFromString = [dateFormater dateFromString:strTime];
        //NSDate *dateFromString = [self parseDate:strTime];
        
        
        
        NSTimeZone* sourceTimeZone = [NSTimeZone defaultTimeZone];
        [dateFormater setTimeZone:sourceTimeZone];
        [dateFormater setDateFormat:@"dd MMM yyyy hh:mm a"];
        NSString *dateRepresentation = [dateFormater stringFromDate:dateFromString];
        
        
        NSLog(@"Date formated with local time zone: %@",dateRepresentation);
        
        cell.lblDateTime.text=strTime;
      //  cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}


- (NSDate*)parseDate:(NSString*)inStrDate
{
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setLocale:[NSLocale systemLocale]];
    [dtFormatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    NSDate* dateOutput = [dtFormatter dateFromString:inStrDate];
    return dateOutput;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (IBAction)BtnMenu:(UIButton*)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

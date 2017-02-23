//
//  AppointmentListVC.h
//  MyMDSManager
//
//  Created by CEPL on 18/07/15.
//  Copyright (c) 2015 sb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointementObject.h"
#import "CXCalendarView.h"

typedef enum _AppointmentSection
{
    CurrentAppointement=0,
    PreviousAppointement=1,
}AppointmentSection;

@interface AppointmentListVC : UIViewController<CXCalendarViewDelegate>
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrCurrentAppointment;
    NSDate *currentDate;
    NSDateFormatter *dateFormatter;
    NSMutableDictionary *dictEvent;
    BOOL isViewUpdate;
    NSDate *oldDate;
    int listTag;
    int oldListTag;
}

@property(strong,nonatomic) CXCalendarView *calendarView;

@end



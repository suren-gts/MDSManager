//
//  CXCalendarView.m
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "CXCalendarView.h"

#import <QuartzCore/QuartzCore.h>

#import "CXCalendarCellView.h"
#import "UIColor+CXCalendar.h"
#import "UILabel+CXCalendar.h"
#import "UIButton+CXCalendar.h"


static const CGFloat kGridMargin = 4;
static const CGFloat kDefaultMonthBarButtonWidth = 60;

@implementation CXCalendarView

@synthesize delegate;

- (id) initWithFrame: (CGRect) frame {
    if ((self = [super initWithFrame: frame])) {
        [self setDefaults];
    }

    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setDefaults];
}

- (void) setDefaults

{
    
    //testMD
    //[UIFont fontWithName:@"Oswald-Regular" size:17.0f]
    //[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12.0f]
    
    self.backgroundColor = [UIColor clearColor];

    CGGradientRef gradient = CGGradientCreateWithColors(NULL,
        (CFArrayRef)@[
                      (id)[UIColor colorWithRed:188/255. green:200/255. blue:215/255. alpha:1].CGColor,
                      (id)[UIColor colorWithRed:125/255. green:150/255. blue:179/255. alpha:1].CGColor], NULL);

    self.monthBarBackgroundColor = [UIColor cx_colorWithGradient:gradient size:CGSizeMake(1, 40)];
   
    self.monthLabelTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor colorWithRed:25/255. green:56/255. blue:139/255. alpha:1],
        NSFontAttributeName : [UIFont fontWithName:@"NexaRegular" size:17.0f],
        NSShadowAttributeName : [UIColor grayColor],
        NSShadowAttributeName : [NSValue valueWithCGSize:CGSizeMake(0, 1)]
    };
    self.weekdayLabelTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont fontWithName:@"NexaRegular" size:15.0f]
        };
    self.cellLabelNormalTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor blueColor],
        NSFontAttributeName : [UIFont fontWithName:@"NexaRegular" size:15.0f]
    };
    self.cellLabelSelectedTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor]
    };
    
    self.cellSelectedBackgroundColor = [UIColor colorWithRed:25/255. green:56/255. blue:139/255. alpha:1];
    self.cellNormalBackgroundColor = [UIColor whiteColor];
    

    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    _calendar = [[NSCalendar currentCalendar] retain];

    _monthBarHeight = 40;
    _weekBarHeight = 30;

    self.selectedDate = nil;
    self.displayedDate = [NSDate date];
}
-(void)setMonthButtons
{
    if (!self.firstDateOfCalendar)
        self.firstDateOfCalendar=[NSDate date];
    if (!self.lastDateOfCalendar)
        self.lastDateOfCalendar=[NSDate date];
    //    if (self.lastDateOfCalendar)
    //    {
    NSDateComponents *firstcomponents = [[NSCalendar currentCalendar] components: NSMonthCalendarUnit|NSYearCalendarUnit
                                                                        fromDate:self.firstDateOfCalendar];
    
    NSDateComponents *lastcomponents = [[NSCalendar currentCalendar] components: NSMonthCalendarUnit|NSYearCalendarUnit
                                                                       fromDate:self.lastDateOfCalendar];
    
    NSDateComponents *todaycomponents = [[NSCalendar currentCalendar] components: NSMonthCalendarUnit|NSYearCalendarUnit
                                                                        fromDate:self.displayedDate];
    
    //test Arjun
    self.monthForwardButton.enabled=NO;
    if (todaycomponents.year<lastcomponents.year)
        self.monthForwardButton.enabled=YES;
    else if (todaycomponents.month<lastcomponents.month)
        self.monthForwardButton.enabled=YES;
    self.monthBackButton.enabled=NO;
    if (todaycomponents.year>firstcomponents.year)
        self.monthBackButton.enabled=YES;
    else if (todaycomponents.month>firstcomponents.month)
        self.monthBackButton.enabled=YES;
}
- (void) dealloc {
    [_calendar release];
    [_selectedDate release];
    [_displayedDate release];
    [_dateFormatter release];

    [super dealloc];
}

- (NSCalendar *) calendar {
    return _calendar;
}

- (void) setCalendar: (NSCalendar *) calendar {
    if (_calendar != calendar) {
        [_calendar release];
        _calendar = [calendar retain];
        _dateFormatter.calendar = _calendar;

        [self setNeedsLayout];
    }
}

- (NSDate *) selectedDate
{
    return _selectedDate;
}

- (void) updateSelectedDate
{
    for (CXCalendarCellView *cellView in self.dayCells) {
        BOOL isEventAvailableForDate = false;
        if ([self.delegate respondsToSelector:@selector(calendarView:eventAvailableForDate:)])
        {
            isEventAvailableForDate = [self.delegate calendarView:self eventAvailableForDate:[cellView dateWithBaseDate: self.displayedDate withCalendar: self.calendar]];
        }
        cellView.showDot = isEventAvailableForDate;
        // [cellView updateDotImage];
        cellView.selected = NO;
        
        NSDateComponents *components = [self.calendar components: NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                        fromDate: [NSDate date]];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyy-MM-dd 00:00:00 Z"];
        
        
        if (self.displayedMonth==components.month && self.displayedYear==components.year && cellView.day==components.day) {
            
            self.cellLabelNormalTextAttributes = @{
                                                   NSForegroundColorAttributeName : [UIColor colorWithRed:25/255. green:56/255. blue:139/255. alpha:1],
                                                   NSFontAttributeName :[UIFont fontWithName:@"NexaRegular" size:15.0f]};
            
            self.cellLabelSelectedTextAttributes = @{
                                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                                     };
            self.cellSelectedBackgroundColor = [UIColor colorWithRed:25/255. green:56/255. blue:139/255. alpha:1];
            self.cellNormalBackgroundColor = [UIColor whiteColor];

        }
        else
        {
            
            self.cellLabelNormalTextAttributes = @{
                                                   NSForegroundColorAttributeName : [UIColor colorWithRed:25/255. green:56/255. blue:139/255. alpha:1],
                                                   NSFontAttributeName : [UIFont fontWithName:@"NexaRegular" size:15.0f]};
            
     //       NSLog(@"Font Size %f ",[UIFont systemFontSize]);
            self.cellLabelSelectedTextAttributes = @{
                                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                                     };
            
            self.cellSelectedBackgroundColor = [UIColor colorWithRed:25/255. green:56/255. blue:139/255. alpha:1];
            self.cellNormalBackgroundColor = [UIColor whiteColor];
        }
        cellView.normalBackgroundColor = self.cellNormalBackgroundColor;
        cellView.selectedBackgroundColor = self.cellSelectedBackgroundColor;
        [cellView cx_setTitleTextAttributes:self.cellLabelNormalTextAttributes forState:UIControlStateNormal];
        [cellView cx_setTitleTextAttributes:self.cellLabelSelectedTextAttributes forState:UIControlStateSelected];
        
    }
    BOOL isEventAvailableForDate =false;
    if ([self.delegate respondsToSelector:@selector(calendarView:eventAvailableForDate:)])
    {
        isEventAvailableForDate = [self.delegate calendarView:self eventAvailableForDate:[[self cellForDate: self.selectedDate] dateWithBaseDate: self.self.selectedDate withCalendar: self.calendar]];
    }
    [self cellForDate: self.selectedDate].showDot = isEventAvailableForDate;
    [self cellForDate: self.selectedDate].selected = YES;
}

- (void) setSelectedDate: (NSDate *) selectedDate
{
    if (![selectedDate isEqual: _selectedDate])
    {
        [_selectedDate release];
        _selectedDate = [selectedDate retain];

        [self updateSelectedDate];

        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView: self didSelectDate: _selectedDate];
        }
    }
}

- (NSDate *) displayedDate {
    return _displayedDate;
}

- (void) setDisplayedDate: (NSDate *) displayedDate {
    if (_displayedDate != displayedDate) {
        [_displayedDate release];
        _displayedDate = [displayedDate retain];

        NSString *monthName = [[_dateFormatter standaloneMonthSymbols] objectAtIndex: self.displayedMonth - 1];
        self.monthLabel.text = [NSString stringWithFormat: @"%@ %lu", [monthName uppercaseString], (unsigned long)self.displayedYear];

        [self updateSelectedDate];

        [self setNeedsLayout];
    }
}

- (NSUInteger) displayedYear {
    NSDateComponents *components = [self.calendar components: NSYearCalendarUnit
                                                    fromDate: self.displayedDate];
    self.aYear = components.year;
    return components.year;
}

- (NSUInteger) displayedMonth
{
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit
                                fromDate: self.displayedDate];
  //  NSLog(@"number of month...%ld",(long)components.month);
    self.aMonth = components.month;
    return components.month;
}

- (CGFloat) monthBarHeight {
    return _monthBarHeight;
}

- (void) setMonthBarHeight: (CGFloat) monthBarHeight {
    if (_monthBarHeight != monthBarHeight) {
        _monthBarHeight = monthBarHeight;
        [self setNeedsLayout];
    }
}

- (CGFloat) weekBarHeight {
    return _weekBarHeight;
}

- (void) setWeekBarHeight: (CGFloat) weekBarHeight {
    if (_weekBarHeight != weekBarHeight) {
        _weekBarHeight = weekBarHeight;
        [self setNeedsLayout];
    }
}

- (void) touchedCellView: (CXCalendarCellView *) cellView {
    self.selectedDate = [cellView dateWithBaseDate: self.displayedDate withCalendar: self.calendar];
}

- (void) monthForward {
    NSDateComponents *monthStep = [[NSDateComponents new] autorelease];
    monthStep.month = 1;
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
}

- (void) monthBack {
    NSDateComponents *monthStep = [[NSDateComponents new] autorelease];
    monthStep.month = -1;
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
}

- (void) reset {
    self.selectedDate = nil;
}

- (NSDate *) displayedMonthStartDate {
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit|NSYearCalendarUnit
                                                    fromDate: self.displayedDate];
    components.day = 1;
    return [self.calendar dateFromComponents: components];
}

- (CXCalendarCellView *) cellForDate: (NSDate *) date {
    if (!date) {
        return nil;
    }

    NSDateComponents *components = [self.calendar components: NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                        fromDate: date];
    if (components.month == self.displayedMonth &&
            components.year == self.displayedYear &&
            [self.dayCells count] >= components.day) {

        return [self.dayCells objectAtIndex: components.day - 1];
    }
    return nil;
}

- (void) applyStyles {
  //  _monthBar.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"month_background"]];
    _monthBar.backgroundColor =[UIColor whiteColor];
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    [self applyStyles];

    CGFloat top = 0;

    if (self.monthBarHeight) {
        self.monthBar.frame = CGRectMake(0, top, self.bounds.size.width, self.monthBarHeight);
        self.monthLabel.frame = CGRectMake(0, top, self.bounds.size.width, self.monthBar.bounds.size.height);
        self.monthForwardButton.frame = CGRectMake(self.monthBar.bounds.size.width - kDefaultMonthBarButtonWidth, top,
                                                   kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
        self.monthBackButton.frame = CGRectMake(0, top, kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
        top = self.monthBar.frame.origin.y + self.monthBar.frame.size.height;
    } else {
        self.monthBar.frame = CGRectZero;
    }

    if (self.weekBarHeight) {
        self.weekdayBar.frame = CGRectMake(0, top, self.bounds.size.width, self.weekBarHeight);
        CGRect contentRect = CGRectInset(self.weekdayBar.bounds, kGridMargin, 0);
        for (NSUInteger i = 0; i < [self.weekdayNameLabels count]; ++i) {
            UILabel *label = [self.weekdayNameLabels objectAtIndex:i];
            label.frame = CGRectMake((contentRect.size.width / 7) * (i % 7), 0,
                                     contentRect.size.width / 7, contentRect.size.height);
        }
        top = self.weekdayBar.frame.origin.y + self.weekdayBar.frame.size.height;
    } else {
        self.weekdayBar.frame = CGRectZero;
    }

    // Calculate shift
    NSDateComponents *components = [self.calendar components: NSWeekdayCalendarUnit
                                                    fromDate: [self displayedMonthStartDate]];
    NSInteger shift = components.weekday - self.calendar.firstWeekday;
    if (shift < 0) {
        shift = 7 + shift;
    }

    // Calculate range
    NSRange range = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit
                                       forDate:self.displayedDate];

    self.gridView.frame = CGRectMake(kGridMargin, top,
                                     self.bounds.size.width - kGridMargin * 2,
                                     self.bounds.size.height - top);
    CGFloat cellHeight = self.gridView.bounds.size.height / 6.0;
    CGFloat cellWidth = (self.bounds.size.width - kGridMargin * 2) / 7.0;
    for (NSUInteger i = 0; i < [self.dayCells count]; ++i) {
        CXCalendarCellView *cellView = [self.dayCells objectAtIndex:i];
        cellView.frame = CGRectMake(cellWidth * ((shift + i) % 7), cellHeight * ((shift + i) / 7),
                                    cellWidth, cellHeight);
        cellView.hidden = i >= range.length;
    }
}

- (UIView *) monthBar {
    if (!_monthBar) {
        _monthBar = [[[UIView alloc] init] autorelease];
        _monthBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview: _monthBar];
    }
    return _monthBar;
}

- (UILabel *) monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[[UILabel alloc] init] autorelease];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _monthLabel.backgroundColor = [UIColor clearColor];
        [self.monthBar addSubview: _monthLabel];
    }
    return _monthLabel;
}

- (UIButton *) monthBackButton {
    if (!_monthBackButton) {
        _monthBackButton = [[[UIButton alloc] init] autorelease];
        [_monthBackButton setImage:[UIImage imageNamed:@"back_arrow_calender"] forState:UIControlStateNormal];
        [_monthBackButton addTarget: self
                             action: @selector(monthBack)
                   forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthBackButton];
    }
    return _monthBackButton;
}

- (UIButton *) monthForwardButton {
    if (!_monthForwardButton) {
        _monthForwardButton = [[[UIButton alloc] init] autorelease];
         [_monthForwardButton setImage:[UIImage imageNamed:@"forward_arrow_calender"] forState:UIControlStateNormal];
        [_monthForwardButton addTarget: self
                                action: @selector(monthForward)
                      forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthForwardButton];
    }
    return _monthForwardButton;
}

- (UIView *) weekdayBar {
    if (!_weekdayBar) {
        _weekdayBar = [[[UIView alloc] init] autorelease];
        _weekdayBar.backgroundColor = [UIColor darkGrayColor];
    }
    return _weekdayBar;
}

- (NSArray *) weekdayNameLabels {
    if (!_weekdayNameLabels) {
        NSMutableArray *labels = [NSMutableArray array];
        for (NSUInteger i = self.calendar.firstWeekday; i < self.calendar.firstWeekday + 7; ++i) {
            NSUInteger index = (i - 1) < 7 ? (i - 1) : ((i - 1) - 7);
            
            UILabel *label = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
            label.tag = i;
            [label cx_setTextAttributes:self.weekdayLabelTextAttributes];
            label.textAlignment = NSTextAlignmentCenter;
            NSString * str=[[[_dateFormatter shortWeekdaySymbols] objectAtIndex: index] uppercaseString];
            str=[str substringToIndex:3];
            label.text = str;
      //      NSLog(@"WEEKDAY %@",[[[_dateFormatter shortWeekdaySymbols] objectAtIndex: index] uppercaseString]);
            [labels addObject:label];
            [_weekdayBar addSubview: label];
        }
        [self addSubview:_weekdayBar];
        _weekdayNameLabels = [[NSArray alloc] initWithArray:labels];
    }
    return _weekdayNameLabels;
}

- (UIView *) gridView {
    if (!_gridView)
    {
        _gridView = [[[UIView alloc] init] autorelease];
        _gridView.backgroundColor = [UIColor clearColor];
        _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: _gridView];
    }
    return _gridView;
}

- (NSArray *) dayCells
{
    //testMd
    if (!_dayCells)
    {
        NSMutableArray *cells = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 31; ++i) {
            CXCalendarCellView *cell = [[CXCalendarCellView new] autorelease];
            cell.tag = i;
            cell.day = i;
            [cell addTarget: self
                     action: @selector(touchedCellView:)
           forControlEvents: UIControlEventTouchUpInside];
            cell.normalBackgroundColor = self.cellNormalBackgroundColor;
            cell.selectedBackgroundColor = self.cellSelectedBackgroundColor;
            [cell cx_setTitleTextAttributes:self.cellLabelNormalTextAttributes forState:UIControlStateNormal];
            [cell cx_setTitleTextAttributes:self.cellLabelSelectedTextAttributes forState:UIControlStateSelected];

            [cells addObject:cell];
            [self.gridView addSubview: cell];
            self.aDay = i;
        }
        _dayCells = [[NSArray alloc] initWithArray:cells];
   //     NSLog(@"\n%d,\n%d,\n%d",self.aDay,self.aMonth,self.aYear);
    }
    return _dayCells;
}

@end

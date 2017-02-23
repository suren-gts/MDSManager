//
//  CXCalendarCellView.m
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "CXCalendarCellView.h"

@implementation CXCalendarCellView

- (void) setDay: (NSUInteger) day
{
    if (_day != day)
    {
        _day = day;
        [self setTitle: [NSString stringWithFormat: @"%lu", (unsigned long)_day] forState: UIControlStateNormal];
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[[UIColor colorWithRed:127.0/255.0 green:181.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor];
        
       // self.layer.borderColor=[[UIColor lightGrayColor] CGColor];

    }
}
- (NSDate *) dateWithBaseDate: (NSDate *) baseDate withCalendar: (NSCalendar *)calendar
{
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit
                                               fromDate:baseDate];
    components.day = self.day;
    return [calendar dateFromComponents:components];
    
}
-(void)updateDotImage
{
    if (self.showDot)
    {
        if (!self.img2) {
            self.img2 = [[UIImageView alloc]initWithFrame:
                         CGRectMake(3, 3, 8, 8)];
            [self.img2 setImage:[UIImage imageNamed:@"alarmclock_icon@2x.png"]];
            
        }
        [self.img2 setImage:[UIImage imageNamed:@"alarmclock_icon@2x.png"]];
        [self addSubview:self.img2];
    }
    else
    {
//      [self.img2 removeFromSuperview];
        if (!self.img2) {
            self.img2 = [[UIImageView alloc]initWithFrame:
                         CGRectMake(3, 3, 8, 8)];
            [self.img2 setImage:[UIImage imageNamed:@""]];
            
        }
        [self.img2 setImage:[UIImage imageNamed:@""]];
        [self addSubview:self.img2];
    }

}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.backgroundColor = self.selectedBackgroundColor;
        self.img = [[UIImageView alloc]initWithFrame:
                    CGRectMake(-2, 0, 47, 38)];
        [self.img setImage:[UIImage imageNamed:@"dateselection_highlighter1"]];
        [self addSubview:self.img];
        
        //Add Dot Image.
    }
    else
    {
        self.backgroundColor = self.normalBackgroundColor;
        [self.img removeFromSuperview];
     //   [self.img2 removeFromSuperview];
        
        
    }
    [self updateDotImage];
}

@end

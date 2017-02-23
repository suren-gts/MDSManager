//
//  CXCalendarCellView.h
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//


@interface CXCalendarCellView : UIButton

@property(nonatomic, assign) NSUInteger day;

@property(nonatomic, assign) UIColor *normalBackgroundColor;
@property(nonatomic, assign) UIColor *selectedBackgroundColor;
@property(nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) UIImageView *img2;
@property(nonatomic, assign) BOOL showDot;
-(void)updateDotImage;
- (NSDate *) dateWithBaseDate: (NSDate *) baseDate withCalendar: (NSCalendar *)calendar;

@end

//
//  CalendarView.m
//  myBGI
//
//  Created by lx on 2017/5/10.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "CalendarView.h"

@implementation CalendarView
- (instancetype)initWithFrame:(CGRect)frame contentFrame:(CGRect)contentframe{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *contentView = [[UIView alloc] initWithFrame:contentframe];
        contentView.backgroundColor = RGBColor(105, 105, 105, 0);
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return self;
}

- (void)showContent{
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.dropBeginFrame = CGRectMake(0, -kCalendarH, self.contentView.frame.size.width, kCalendarH);
    self.dropEndFrame = CGRectMake(0, 0.5, self.contentView.frame.size.width, kCalendarH);
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:self.dropBeginFrame];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.todayColor = [UIColor whiteColor];
    calendar.appearance.titleTodayColor = [UIColor blackColor];
    calendar.appearance.headerTitleColor = kSubjectColor;
    calendar.appearance.weekdayTextColor = kSubjectColor;
    [self.contentView addSubview:calendar];
    self.calendar = calendar;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.frame = self.dropEndFrame;
        self.contentView.backgroundColor = RGBColor(105, 105, 105, 0.4);
    }];
}

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s", __func__);
#endif

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.2 animations:^{
        self.calendar.frame = self.dropBeginFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

#pragma mark - <FSCalendarDelegate>

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    if (self.willSelectBlock) {
        return self.willSelectBlock([self.dateFormatter stringFromDate:date]);
    }
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
#if DEBUG
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
#endif

    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.frame = self.dropBeginFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
    if (self.selectedBlock) {
        self.selectedBlock([self.dateFormatter stringFromDate:date]);
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
#if DEBUG
    NSLog(@"did change to page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
#endif

}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

#pragma mark - <FSCalendarDataSource>


- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"1990-10-01"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  CalendarView.m
//  myBGI
//
//  Created by lx on 2017/5/10.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "CalendarView.h"

@implementation CalendarView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 450 for iPad and 300 for iPhone
        CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 200, self.frame.size.width, height)];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.scrollDirection = FSCalendarScrollDirectionVertical;
        calendar.backgroundColor = [UIColor whiteColor];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.backgroundColor = RGBColor(105, 105, 105, 0.4);
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
        [self addSubview:calendar];
        self.calendar = calendar;
        self.calendar.appearance.todayColor = [UIColor whiteColor];
        self.calendar.appearance.titleTodayColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s", __func__);
#endif

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
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
    [self removeFromSuperview];
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

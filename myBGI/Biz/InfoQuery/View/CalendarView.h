//
//  CalendarView.h
//  myBGI
//
//  Created by lx on 2017/5/10.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"
#import "FSCalendar.h"

@interface CalendarView : BaseView <FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance>
@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *selectedDate;
@property (copy, nonatomic) BOOL(^willSelectBlock)(NSString *dateStr);
@property (copy, nonatomic) void(^selectedBlock)(NSString * dateStr);
@end

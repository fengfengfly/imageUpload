//
//  CalendarView.h
//  myBGI
//
//  Created by lx on 2017/5/10.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"
#import "FSCalendar.h"
#define kCalendarH 250

@interface CalendarView : BaseView <FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance>
@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *selectedDate;
@property (copy, nonatomic) BOOL(^willSelectBlock)(NSString *dateStr);
@property (copy, nonatomic) void(^selectedBlock)(NSString * dateStr, BOOL isConfirm);
@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) CGRect dropBeginFrame;
@property (assign, nonatomic) CGRect dropEndFrame;
@property (copy, nonatomic) UIView *(^myHitTestBlock)(CGPoint point, UIEvent *event);
- (instancetype)initWithFrame:(CGRect)frame contentFrame:(CGRect)contentframe;
- (void)showContent;
@end
